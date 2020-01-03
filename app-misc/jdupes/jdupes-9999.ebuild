# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools git-r3 toolchain-funcs

DESCRIPTION="A powerful duplicate file finder and an enhanced fork of 'fdupes'."
HOMEPAGE="https://github.com/jbruchon/jdupes"
EGIT_REPO_URI="https://github.com/jbruchon/${PN}.git"

LICENSE="MIT"
SLOT="0"

KEYWORDS=""
IUSE="ncurses"

DEPEND="dev-libs/libpcre2[pcre32]"

DOCS=( CHANGES README.md )

src_prepare() {
	default
}
src_compile() {
	emake
}
src_install() {
	emake DESTDIR="${D}" prefix="${EPREFIX}/usr" install
}
