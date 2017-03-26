# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3 toolchain-funcs

DESCRIPTION="User-space application to modify the EFI boot manager"
HOMEPAGE="https://github.com/rhinstaller/efibootmgr"
EGIT_REPO_URI="git://github.com/rhinstaller/${PN}.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="sys-apps/pciutils
	>=sys-libs/efivar-27:="
DEPEND="${RDEPEND}"

src_prepare() {
	default
	sed -i -e s/-Werror// Make.defaults || die
}

src_configure() {
	tc-export CC
	export EFIDIR="Gentoo"
}
