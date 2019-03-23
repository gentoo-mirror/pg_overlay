# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python3_{5,6,7} )

inherit cmake-utils python-any-r1

DESCRIPTION="A program that automatically solves layouts of Freecell and similar variants of Card Solitaire"
HOMEPAGE="https://fc-solve.shlomifish.org"

SRC_URI="https://fc-solve.shlomifish.org/downloads/fc-solve/${P}.tar.xz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
REQUIRED_USE=""

RDEPEND="dev-python/pysol-cards
	dev-python/random2
	dev-python/six"

DEPEND="${RDEPEND}
	dev-perl/Path-Tiny
	dev-perl/Template-Toolkit
	dev-util/gperf"

src_prepare() {
	mycmakeargs=(
		-DBUILD_STATIC_LIBRARY=OFF \
		-DFCS_WITH_TEST_SUITE=OFF \
		-DFCS_AVOID_TCMALLOC=OFF \
		-DFCS_BUILD_DOCS=OFF
	)

	cmake-utils_src_prepare
}
