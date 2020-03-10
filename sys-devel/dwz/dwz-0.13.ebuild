# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

FPKG_HASH="8dc5e647a99ab652fbbed2d37c595a072a2e31198e66f84220d4caf04a9ee0b2900b116932f268b68015e4cc6b49b87313bf1a2d00748d2b3c4799c9ee58c2f4"

DESCRIPTION="DWARF optimization and duplicate removal tool"
HOMEPAGE="https://sourceware.org/git/?p=dwz.git;a=summary"
SRC_URI="https://src.fedoraproject.org/repo/pkgs/${PN}/${P}.tar.xz/sha512/${FPKG_HASH}/${P}.tar.xz"

LICENSE="GPL-2+ GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-libs/elfutils"
RDEPEND="${DEPEND}"
BDEPEND=""

src_prepare() {
	default
	sed -i \
		-e '/^CFLAGS/d' \
		Makefile || die "sed failed"
	tc-export CC
}
