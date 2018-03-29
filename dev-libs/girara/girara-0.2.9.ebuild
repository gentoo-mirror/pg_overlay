# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PLOCALES=( de el eo es fr he it nl pl pt_BR ru tr )

inherit l10n meson multilib toolchain-funcs virtualx
[[ ${PV} == 9999* ]] && inherit git-r3

DESCRIPTION="UI library that focuses on simplicity and minimalism"
HOMEPAGE="http://pwmt.org/projects/girara/"
if ! [[ ${PV} == 9999* ]]; then
SRC_URI="http://pwmt.org/projects/${PN}/download/${P}.tar.xz"
fi
EGIT_REPO_URI="https://git.pwmt.org/pwmt/${PN}.git"
EGIT_BRANCH="develop"

LICENSE="ZLIB"
SLOT="3"
if ! [[ ${PV} == 9999* ]]; then
KEYWORDS="~amd64 ~arm ~x86 ~amd64-linux ~x86-linux"
fi
IUSE="docs +json libnotify test"

RDEPEND=">=dev-libs/glib-2.28
	>=x11-libs/gtk+-3.4:3
	json? ( dev-libs/json-c )
	!<${CATEGORY}/${PN}-0.1.6
	libnotify? ( >=x11-libs/libnotify-0.7 )"
DEPEND="${RDEPEND}
	sys-devel/gettext
	virtual/pkgconfig
	test? ( x11-apps/xhost
		dev-libs/check )"

pkg_setup() {
	mygiraraconf=(
		-Denable-notify=$(usex libnotify 1 0)
		-Denable-json=$(usex json 1 0)
		-Denable-docs=$(usex docs 1 0)
	)
}
src_prepare() {
	rem_locale() {
		rm -fv "po/${1}.po" || die "removing of ${1}.po failed"
		sed -i s/${1}.po// po/LINGUAS || die
	}

	l10n_find_plocales_changes po "" ".po"
	l10n_for_each_disabled_locale_do rem_locale

	default
}

multilib_src_coonfigure() {
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
