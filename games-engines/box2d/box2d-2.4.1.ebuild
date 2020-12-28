# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake multilib

DESCRIPTION="A C++ engine for simulating rigid bodies in 2D games"
HOMEPAGE="https://box2d.org/"
SRC_URI="https://github.com/erincatto/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="ZLIB"
SLOT="$(ver_cut 1-2).0"
KEYWORDS="~amd64 ~x86"

src_prepare() {
	default
	cmake_src_prepare
}

src_install() {
	cmake_src_install
	dodoc {CHANGELOG,README}.md
	dolib.so "${BUILD_DIR}"/lib${MY_PN}$(get_libname ${SLOT})

	local FILE
	for FILE in $(find ${MY_PN} -name *.h); do
		insinto "/usr/include/${MY_PN}-${SLOT}/${FILE%/*}"
		doins "${FILE}"
	done
}
