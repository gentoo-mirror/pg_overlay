# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-multilib

DESCRIPTION="Header-only library for parsing TOML"
HOMEPAGE="https://github.com/skystrife/cpptoml"
SRC_URI="https://github.com/skystrife/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="libcxx examples"

RDEPEND="
        libcxx? ( sys-libs/libcxx )"

src_prepare() {
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_LIBCXX=$(usex libcxx)
        -DCPPTOML_BUILD_EXAMPLES=$(usex examples)
	)
	cmake-multilib_src_configure
}
