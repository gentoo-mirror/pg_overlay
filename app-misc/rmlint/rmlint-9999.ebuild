# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit gnome2-utils scons-utils eutils git-r3

DESCRIPTION="commandline tool to clean your filesystem from various sort of lint (unused files, twins, etc.)."
HOMEPAGE="https://github.com/sahib/rmlint"
SRC_URI=""
EGIT_REPO_URI="git://github.com/sahib/rmlint.git"
EGIT_BRANCH="master"

LICENSE=""
SLOT="0"
KEYWORDS=""
IUSE="X"

RDEPEND="X? ( x11-libs/gtksourceview:3.0
		dev-python/colorlog )"
DEPEND="${RDEPEND}
		dev-util/scons
		dev-python/sphinx
		sys-devel/gettext"

src_compile(){
	escons CC="$(tc-getCC)"
}

src_install(){
	escons install LIBDIR=/usr/$(get_libdir) --prefix="${ED}"/usr
    rm -f ${ED}/usr/share/glib-2.0/schemas/gschemas.compiled
}

pkg_postinst() {
	use X && gnome2_schemas_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	use X && gnome2_schemas_update
	gnome2_icon_cache_update
}
