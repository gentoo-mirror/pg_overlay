# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PLOCALES="de es fr"
PYTHON_COMPAT=( python3_{11..13} )

inherit git-r3 gnome2-utils plocale python-single-r1 scons-utils

DESCRIPTION="rmlint finds space waste and other broken things on your filesystem and offers to remove it"
HOMEPAGE="https://github.com/sahib/rmlint"
EGIT_REPO_URI="https://github.com/sahib/${PN}.git"
EGIT_BRANCH="develop"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="gui doc"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="gui? ( 
		${PYTHON_DEPS}
		x11-libs/gtksourceview:3.0
		$(python_gen_cond_dep '
		doc? ( dev-python/sphinx[${PYTHON_MULTI_USEDEP}] )
		dev-python/pygobject:3[${PYTHON_MULTI_USEDEP}]
		')
		dev-libs/json-glib
		gnome-base/librsvg:2
		x11-libs/gtk+:3 )"
DEPEND="${RDEPEND}
	sys-devel/gettext
	virtual/pkgconfig"

src_prepare(){
	default
	plocale_find_changes po "" .po
	rm_locale() {
		rm -fv po/"${1}".po || die "removing of ${1}.po failed"
	}
	plocale_for_each_disabled_locale rm_locale

	if ! use doc; then
		rm -rf docs
	fi
}

src_configure(){
	MYSCONS=(
		CC="$(tc-getCC)"
		DEBUG=0
	)
}

src_compile(){
	escons "${MYSCONS[@]}" LIBDIR=/usr/$(get_libdir) --prefix="${ED}"/usr --actual-prefix=/usr
}

src_install(){
	escons "${MYSCONS[@]}" LIBDIR=/usr/$(get_libdir) --prefix="${ED}"/usr --actual-prefix=/usr install
	rm -f ${ED}/usr/share/glib-2.0/schemas/gschemas.compiled
	if ! use gui; then
		rm -rf "${D}"/usr/share/{glib-2.0,icons,applications}
		rm -rf "${D}"/usr/lib
	fi
	if ! use doc; then
		rm -rf "${D}"/usr/share/man
	fi
}

pkg_postinst() {
	use gui && gnome2_schemas_update
	xdg_icon_cache_update
}

pkg_postrm() {
	use gui && gnome2_schemas_update
	xdg_icon_cache_update
}
