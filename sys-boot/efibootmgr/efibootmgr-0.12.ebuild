# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit toolchain-funcs

DESCRIPTION="User-space application to modify the EFI boot manager"
HOMEPAGE="https://github.com/rhinstaller/efibootmgr"
SRC_URI="https://github.com/rhinstaller/${PN}/archive/5e9700c2252eed45f4568f3a7c08c866c2c83c0b.zip -> ${P}.zip"

S=${WORKDIR}/${PN}-5e9700c2252eed45f4568f3a7c08c866c2c83c0b

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~x86"
IUSE=""

RDEPEND="sys-apps/pciutils
	>=sys-libs/efivar-0.24"
DEPEND="${RDEPEND}"

src_prepare() {
	default
	sed -i -e s/-Werror// Makefile || die
}

src_configure() {
	tc-export CC
	export EXTRA_CFLAGS=${CFLAGS}
}

src_install() {
	default
	dosbin src/efibootdump
	doman src/man/efibootmgr.8
	dodoc AUTHORS README TODO
}
