# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PLOCALES="de es fr"
PYTHON_COMPAT=( python3_{12..13} )

inherit git-r3 gnome2-utils plocale python-single-r1 scons-utils

DESCRIPTION="rmlint finds space waste and other broken things on your filesystem and offers to remove it"
HOMEPAGE="https://github.com/sahib/rmlint"
EGIT_REPO_URI="https://github.com/sahib/${PN}.git"
EGIT_COMMIT="v2.10.3"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="gui"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="gui? ( 
		${PYTHON_DEPS}
		x11-libs/gtksourceview:3.0
		$(python_gen_cond_dep '
			dev-python/pygobject:3[${PYTHON_SINGLE_USEDEP}]
		')
		dev-libs/json-glib
		gnome-base/librsvg:2
		x11-libs/gtk+:3 )"
DEPEND="${RDEPEND}
	sys-devel/gettext
	virtual/pkgconfig
	dev-python/sphinx"

src_prepare(){
	default
	plocale_find_changes po "" .po
	rm_locale() {
		rm -fv po/"${1}".po || die "removing of ${1}.po failed"
	}
	plocale_for_each_disabled_locale rm_locale
}

src_configure(){
	MYSCONS=(
		CC="$(tc-getCC)"
		DEBUG=0
	)

	if ! use gui; then
		MYSCONS+=( --without-gui )
	fi

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
}

pkg_postinst() {
	use gui && gnome2_schemas_update
	xdg_icon_cache_update
}

pkg_postrm() {
	use gui && gnome2_schemas_update
	xdg_icon_cache_update
}
