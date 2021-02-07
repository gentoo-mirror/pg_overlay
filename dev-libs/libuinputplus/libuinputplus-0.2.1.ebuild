# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Easy-to-use uinput library in C++"

HOMEPAGE="https://github.com/YukiWorkshop/libuInputPlus"
SRC_URI="https://github.com/YukiWorkshop/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"

S=${WORKDIR}/libuInputPlus-${PV}

src_install() {
	default
	DESTDIR="${D}" ${CMAKE_MAKEFILE_GENERATOR} -C ${P}_build install
}
