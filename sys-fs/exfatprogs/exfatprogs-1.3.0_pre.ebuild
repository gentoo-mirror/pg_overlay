# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit poly-c_ebuilds

DESCRIPTION="Userspace utilities for the exFAT filesystem"
HOMEPAGE="https://github.com/exfatprogs/exfatprogs"

if [[ ${MY_PV} == *9999 ]] ; then
	inherit autotools git-r3
	EGIT_REPO_URI="https://github.com/exfatprogs/exfatprogs.git"
else
	SRC_URI="https://github.com/${PN}/${PN}/releases/download/${MY_PV}/${MY_P}.tar.xz"
	KEYWORDS="~amd64 ~arm64 ~loong ~ppc ~ppc64 ~riscv ~x86"
fi

LICENSE="GPL-2"
SLOT="0"

RDEPEND="!sys-fs/exfat-utils"

src_prepare() {
	default

	[[ ${MY_PV} == *9999 ]] && eautoreconf
}
