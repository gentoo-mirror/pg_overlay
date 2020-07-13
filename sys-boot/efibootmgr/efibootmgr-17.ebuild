# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="User-space application to modify the EFI boot manager"
HOMEPAGE="https://github.com/rhboot/efibootmgr/"
SRC_URI="https://github.com/rhboot/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ia64 ~x86"
IUSE=""

RDEPEND="sys-apps/pciutils
	>=sys-libs/efivar-25:="
DEPEND="${RDEPEND}"

PATCHES=("${FILESDIR}/efivar.patch"
	"${FILESDIR}/97668ae0bce776a36ea2001dea63d376be8274ac.patch")

src_prepare() {
	default
	sed -i -e 's/-Werror //' Make.defaults || die
}

src_configure() {
	tc-export CC
	export EFIDIR="Gentoo"
}

src_compile() {
	emake PKG_CONFIG="$(tc-getPKG_CONFIG)"
}
