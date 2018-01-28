# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{4,5,6} )

inherit eutils git-r3 gnome2-utils python-r1 scons-utils

DESCRIPTION="rmlint finds space waste and other broken things on your filesystem and offers to remove it"
HOMEPAGE="https://github.com/sahib/rmlint"
EGIT_REPO_URI="https://github.com/sahib/rmlint.git"
EGIT_BRANCH="develop"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="X doc"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="X? ( x11-libs/gtksourceview:3.0
		dev-python/colorlog[${PYTHON_USEDEP}]
		dev-python/pygobject:3[${PYTHON_USEDEP}] )"
DEPEND="${RDEPEND}
		dev-util/scons[${PYTHON_USEDEP}]
		dev-python/sphinx[${PYTHON_USEDEP}]
		sys-devel/gettext"

src_compile(){
	escons CC="$(tc-getCC)"
}

src_install(){
	escons install LIBDIR=/usr/$(get_libdir) --prefix="${ED}"/usr
    rm -f ${ED}/usr/share/glib-2.0/schemas/gschemas.compiled
    if ! use X; then
    	rm -rf "${D}"/usr/share/{glib-2.0,icons,applications}
    	rm -rf "${D}"/usr/lib
	fi
	if ! use doc; then
		rm -rf "${D}"/usr/share/man
	fi
}

pkg_postinst() {
	use X && gnome2_schemas_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	use X && gnome2_schemas_update
	gnome2_icon_cache_update
}
