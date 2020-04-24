# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3

DESCRIPTION="A powerful duplicate file finder and an enhanced fork of 'fdupes'."
HOMEPAGE="https://github.com/jbruchon/jdupes"
EGIT_REPO_URI="https://github.com/jbruchon/${PN}.git"

LICENSE="MIT"
SLOT="0"

KEYWORDS=""
IUSE=""

DOCS=( CHANGES README.md )

src_install() {
	default
	emake DESTDIR="${D}" PREFIX=/usr install
}
