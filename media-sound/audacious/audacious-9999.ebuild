# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PLOCALES="af ar be bg ca cmn cs da de el en_GB es es_AR es_MX et eu fa_IR fi fr gl hu id_ID it ja ko lt lv ml_IN ms nl pl pt_BR pt_PT ro ru si sk sl sq sr sr_RS sv ta tr uk uz zh_CN zh_TW"


MY_P="${P/_/-}"

inherit meson git-r3 plocale
EGIT_REPO_URI="https://github.com/${PN}-media-player/${PN}.git"

DESCRIPTION="Lightweight and versatile audio player"
HOMEPAGE="https://audacious-media-player.org/"

LICENSE="BSD-2"
SLOT="0"
IUSE="archive dbus gtk qt5 qt6"

BDEPEND="
	virtual/pkgconfig
"
DEPEND="
	>=dev-libs/dbus-glib-0.60
	>=dev-libs/glib-2.28
"
RDEPEND="${DEPEND}"
PDEPEND="~media-plugins/${PN}-plugins-${PV}"

S="${WORKDIR}/${MY_P}"

src_prepare() {

	rm_locale() {
		rm -vf "po/${1}.po" || die
		sed -i s/${1}.po// po/Makefile || die
	}
	plocale_find_changes po "" ".po"
	plocale_for_each_disabled_locale rm_locale
	default
}

src_configure() {
	local emesonargs=(
		$(meson_use dbus)
		$(meson_use gtk)
		$(meson_use qt5 qt)
		$(meson_use qt6)
		$(meson_use archive libarchive)
	)

	meson_src_configure
}

src_install() {
	meson_src_install
}
