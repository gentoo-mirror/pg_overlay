# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools git-r3 toolchain-funcs

DESCRIPTION="Identify/delete duplicate files residing within specified directories"
HOMEPAGE="https://github.com/adrianlopezroche/fdupes"
EGIT_REPO_URI="https://github.com/adrianlopezroche/${PN}.git"

LICENSE="MIT"
SLOT="0"

KEYWORDS=""

DOCS=( CHANGES CONTRIBUTORS README )

src_prepare() {
	default
	eautoreconf
}
src_install() {
	default
}
