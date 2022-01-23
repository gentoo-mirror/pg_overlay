# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="ninja-compatible build tool written in C"
HOMEPAGE="https://github.com/michaelforney/samurai"
SRC_URI="https://github.com/michaelforney/samurai/releases/download/${PV}/${P}.tar.gz"
LICENSE="ISC Apache-2.0 MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"

RDEPEND="!dev-util/ninja"

PATCHES=(
	"${FILESDIR}/${P}-null_pointer_fix.patch" #786957
)

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}"/usr install
    dosym samu /usr/bin/ninja
    dodoc README.md
}
