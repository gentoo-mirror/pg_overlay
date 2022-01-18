# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

KEYWORDS="amd64 arm arm64 ppc ppc64 ~riscv x86"
SRC_URI="https://github.com/martinus/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

DESCRIPTION="Fast & memory efficient hashtable based on robin hood hashing for C++11/14/17/20"
HOMEPAGE="https://github.com/martinus/robin-hood-hashing"

LICENSE="MIT"
SLOT="0"

src_configure() {
	local mycmakeargs=(
		-DRH_STANDALONE_PROJECT=ON
		-DCMAKE_CXX_EXTENSIONS=ON
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	insinto /usr/include
	doins src/include/robin_hood.h
}
