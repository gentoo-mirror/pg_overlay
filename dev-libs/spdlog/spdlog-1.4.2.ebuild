# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils flag-o-matic

DESCRIPTION="Very fast, header only, C++ logging library"
HOMEPAGE="https://github.com/gabime/spdlog"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/gabime/spdlog"
else
	SRC_URI="https://github.com/gabime/spdlog/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="MIT"
SLOT="0/1"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="
	>=dev-libs/libfmt-5.0.0
"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/include_cassert.patch" )

src_configure() {
	local mycmakeargs=(
		-DSPDLOG_BUILD_EXAMPLE=OFF
		-DSPDLOG_BUILD_BENCH=OFF
		-DSPDLOG_BUILD_TESTS=$(usex test)
		-DCMAKE_BUILD_TYPE=Release
		-DSPDLOG_BUILD_SHARED=ON
		-DSPDLOG_FMT_EXTERNAL=ON
	)

	cmake-utils_src_configure
}
