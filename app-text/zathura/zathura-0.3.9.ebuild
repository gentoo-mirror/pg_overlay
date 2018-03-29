# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PLOCALES="ca cs de el eo es es_CL et fr he hr id_ID it lt nl no pl pt_BR ru ta_IN tr uk_UA"

inherit l10n meson multilib toolchain-funcs virtualx xdg-utils

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://git.pwmt.org/pwmt/zathura.git"
	EGIT_BRANCH="develop"
else
	KEYWORDS="~amd64 ~arm ~x86 ~amd64-linux ~x86-linux"
	SRC_URI="http://pwmt.org/projects/${PN}/download/${P}.tar.xz"
fi

DESCRIPTION="A highly customizable and functional document viewer"
HOMEPAGE="http://pwmt.org/projects/zathura/"

LICENSE="ZLIB"
SLOT="0"
IUSE="+magic sqlite synctex test"

RDEPEND=">=dev-libs/girara-0.2.8:3=
	>=dev-libs/glib-2.32:2=
	x11-libs/cairo:=
	>=x11-libs/gtk+-3.6:3
	magic? ( sys-apps/file:= )
	sqlite? ( dev-db/sqlite:3= )
	synctex? ( >=app-text/texlive-core-2015 )"
DEPEND="${RDEPEND}
	dev-python/sphinx
	sys-devel/gettext
	virtual/pkgconfig
	test? ( dev-libs/check )"

src_prepare() {
	rem_locale() {
		rm "po/${1}.po" || die "removing of ${1}.po failed"
		sed -i s/${1}// po/LINGUAS || die
	}

	l10n_find_plocales_changes po "" ".po"
	l10n_for_each_disabled_locale_do rem_locale	

	default
}

multulib_src_configure() {
	local emesonargs=(
		-Denable-magic=$(usex magic 1 0)
		-Denable-sqlite=$(usex sqlite 1 0)
		-Denable-syntex=$(usex synctex 1 0)
		-Denable-seccomp=1
	)
	meson_src_configure
}

multilib_src_compile() {
	meson_src_compile
}

multilib_src_test() {
	meson_src_test
}

multilib_src_install() {
	meson_src_install
}

pkg_postinst() {
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
}
