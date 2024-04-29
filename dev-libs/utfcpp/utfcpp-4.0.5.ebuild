# Copyright 2015-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

inherit cmake

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/nemtrif/utfcpp"
	EGIT_SUBMODULES=()
fi

DESCRIPTION="UTF-8 C++ library"
HOMEPAGE="https://github.com/nemtrif/utfcpp"
if [[ "${PV}" == "9999" ]]; then
	SRC_URI=""
else
	SRC_URI="https://github.com/nemtrif/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="Boost-1.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE=""

BDEPEND=""
DEPEND=""
RDEPEND=""

src_unpack() {
	if [[ "${PV}" == "9999" ]]; then
		git-r3_src_unpack
	fi

	rmdir "${S}/extern/ftest" || die
	ln -s ../../ftest "${S}/extern/ftest" || die
}

src_configure() {
	cmake_src_configure
}
