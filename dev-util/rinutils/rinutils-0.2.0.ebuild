# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="C11 / gnu11 utilities C library"
HOMEPAGE="https://www.shlomifish.org/open-source/projects/"
SRC_URI="https://github.com/shlomif/${PN}/releases/download/${PV}/${P}.tar.xz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm64 x86"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"

src_configure() {
	local mycmakeargs=(
		-DWITH_TEST_SUITE=OFF
	)

	cmake_src_configure
}
