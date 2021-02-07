# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Easy-to-use event device library in C++"

HOMEPAGE="https://github.com/YukiWorkshop/libevdevPlus"
SRC_URI="https://github.com/YukiWorkshop/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"

S=${WORKDIR}/libevdevPlus-${PV}

src_prepare() {
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
	-DCMAKE_BUILD_TYPE=Release
	-G Ninja 
	)
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
}

src_install() {
#	default
	cmake_src_install
}
