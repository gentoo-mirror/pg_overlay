# Copyright 2015-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

inherit cmake

DESCRIPTION="UTF-8 C++ library"
HOMEPAGE="https://github.com/nemtrif/utfcpp"
SRC_URI="https://github.com/nemtrif/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Boost-1.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE=""

BDEPEND=""
DEPEND=""
RDEPEND=""
