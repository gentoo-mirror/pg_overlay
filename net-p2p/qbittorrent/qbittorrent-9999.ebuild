# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg-utils

DESCRIPTION="BitTorrent client in C++ and Qt"
HOMEPAGE="https://www.qbittorrent.org
	  https://github.com/qbittorrent"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/${PN}/qBittorrent.git"
else
	SRC_URI="https://github.com/qbittorrent/qBittorrent/archive/release-${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 ~arm ~ppc64 x86"
	S="${WORKDIR}/qBittorrent-release-${PV}"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="dbus debug webui gui"
REQUIRED_USE="dbus? ( gui )"

RDEPEND="
	>=dev-libs/boost-1.62.0-r1:=
	dev-qt/qtcore:5
	dev-qt/qtnetwork:5[ssl]
	dev-qt/qtsql:5
	dev-qt/qtxml:5
	>=net-libs/libtorrent-rasterbar-1.2.12:0=
	sys-libs/zlib
	dbus? ( dev-qt/qtdbus:5 )
	gui? (
		dev-libs/geoip
		dev-qt/qtgui:5
		dev-qt/qtsvg:5
		dev-qt/qtwidgets:5
	)"
DEPEND="${RDEPEND}
	dev-qt/linguist-tools:5"

BDEPEND="virtual/pkgconfig"

DOCS=( AUTHORS Changelog CONTRIBUTING.md README.md TODO )

src_prepare() {
	default
	sed -i "s/QBT_VERSION_MINOR 4/QBT_VERSION_MINOR 3/g" src/base/version.h.in
	sed -i "s/QBT_VERSION_BUGFIX 0/QBT_VERSION_BUGFIX 9/g" src/base/version.h.in
	sed -i "s/rc1//g" src/base/version.h.in
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DDBUS=$(usex dbus ON OFF)
		-DGUI=$(usex gui ON OFF)
		-DSTACKTRACE=$(usex debug ON OFF)
		-DWEBUI=$(usex webui ON OFF)
		-DSYSTEMD=OFF
	)

	cmake_src_configure
}

pkg_postinst() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}
