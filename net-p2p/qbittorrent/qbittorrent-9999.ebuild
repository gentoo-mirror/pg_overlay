# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg

DESCRIPTION="BitTorrent client in C++ and Qt"
HOMEPAGE="https://www.qbittorrent.org
	  https://github.com/qbittorrent"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/${PN}/qBittorrent.git"
else
	SRC_URI="https://github.com/qbittorrent/qBittorrent/archive/release-${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"
	S="${WORKDIR}/qBittorrent-release-${PV}"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="+dbus +gui webui"
REQUIRED_USE="dbus? ( gui )"

RDEPEND="
	>=dev-libs/boost-1.65.0-r1:=
	dev-libs/openssl:=
	dev-qt/qtcore:5
	dev-qt/qtnetwork:5[ssl]
	dev-qt/qtsql:5
	dev-qt/qtxml:5
	>=net-libs/libtorrent-rasterbar-1.2.14:=
	sys-libs/zlib
	dbus? ( dev-qt/qtdbus:5 )
	gui? (
		dev-libs/geoip
		dev-qt/qtgui:5
		dev-qt/qtsvg:5
		dev-qt/qtwidgets:5
	)"
DEPEND="${RDEPEND}"
BDEPEND="dev-qt/linguist-tools:5
	virtual/pkgconfig"

DOCS=( AUTHORS Changelog CONTRIBUTING.md README.md )

src_prepare() {
	default
	sed -i "s/QBT_VERSION_MINOR 5/QBT_VERSION_MINOR 3/g" src/base/version.h.in
	sed -i "s/QBT_VERSION_BUGFIX 0/QBT_VERSION_BUGFIX 9/g" src/base/version.h.in
	sed -i "s/alpha1//g" src/base/version.h.in
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DDBUS=$(usex dbus)
		-DGUI=$(usex gui)
		-DWEBUI=$(usex webui)

		# musl lacks execinfo.h
		-DSTACKTRACE=$(usex !elibc_musl)

		-DSYSTEMD=OFF

		# More verbose build logs are preferable for bug reports
		-DVERBOSE_CONFIGURE=OFF

		# Not yet in ::gentoo
		-DQT6=OFF
		-DCMAKE_BUILD_TYPE=Release
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install
	einstalldocs
}
