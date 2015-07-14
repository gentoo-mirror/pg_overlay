# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit git-r3 toolchain-funcs

DESCRIPTION="Interact with the EFI Boot Manager"
HOMEPAGE="https://github.com/rhinstaller/efibootmgr"
EGIT_REPO_URI="https://github.com/rhinstaller/efibootmgr.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~x86"
IUSE=""

RDEPEND="sys-apps/pciutils
	>=sys-libs/efivar-0.19"
DEPEND="${RDEPEND}"

src_prepare() {
	sed -i -e s/-Werror// Makefile || die
}

src_configure() {
	tc-export CC
	export EXTRA_CFLAGS=${CFLAGS}
}

src_install() {
	# build system uses perl, so just do it ourselves
	dosbin src/efibootmgr/efibootmgr
	doman src/man/man8/efibootmgr.8
	dodoc AUTHORS README doc/ChangeLog doc/TODO
}
