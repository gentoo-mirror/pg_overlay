# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PLOCALES="ar be bg ca cs da de el en en_AU en_GB eo es eu fi fr gl he hi_IN hr hu hy id is it ja ka ko lt lv_LV ms_MY nb nl oc pl pt_BR pt_PT ro ru sk sl sr sv tr uk uz@Latn vi zh zh_HK zh_TW"

inherit cmake-utils gnome2-utils l10n xdg-utils

DESCRIPTION="BitTorrent client in C++ and Qt"
HOMEPAGE="https://www.qbittorrent.org/"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/${PN}/qBittorrent.git"
else
	MY_P=${P/_}
	SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.xz"
	KEYWORDS="~amd64 ~arm ~ppc64 ~x86"
	S=${WORKDIR}/${MY_P}
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="+dbus debug webui +X"
REQUIRED_USE="dbus? ( X )"

RDEPEND="
	>=dev-libs/boost-1.62.0-r1:=
	dev-qt/qtcore:5
	dev-qt/qtnetwork:5[ssl]
	>=dev-qt/qtsingleapplication-2.6.1_p20130904-r1[qt5(+),X?]
	dev-qt/qtxml:5
	>=net-libs/libtorrent-rasterbar-1.0.6:0=
	sys-libs/zlib
	dbus? ( dev-qt/qtdbus:5 )
	X? (
		dev-qt/linguist-tools:5
		dev-qt/qtgui:5
		dev-qt/qtsvg:5
		dev-qt/qtwidgets:5
	)"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=( AUTHORS Changelog CONTRIBUTING.md README.md TODO )

src_prepare() {
	local loc_dir="${S}/src/lang"
	l10n_find_plocales_changes "${loc_dir}" "${PN}_" ".ts"
	rm_loc() {
		rm -vf "${loc_dir}/${PN}_${1}.ts" || die
		sed -i s/${PN}_${1}.qm// src/lang/lang.qrc || die
	}
	l10n_for_each_disabled_locale_do rm_loc

	cmake-utils_src_prepare

	#To last stable version for Pedro's BTMusic
	sed -i s/"VER_MINOR = 2"/"VER_MINOR = 1"/g version.pri || die
	sed -i s/"VER_BUGFIX = 0"/"VER_BUGFIX = 1"/g version.pri || die
	sed -i s/"VER_STATUS = alpha"/"VER_STATUS ="/g version.pri || die
}

src_configure() {
	local mycmakeargs=(
		-DSTACKTRACE=$(usex debug)
		-DWEBUI=$(usex webui)
	)
	cmake-utils_src_configure
}

pkg_postinst() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}
