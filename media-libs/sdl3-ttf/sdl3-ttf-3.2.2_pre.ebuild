# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib poly-c_ebuilds

REAL_P="SDL3_ttf-${MY_PV}"
DESCRIPTION="Library that allows you to use TrueType fonts in SDL applications"
HOMEPAGE="https://github.com/libsdl-org/SDL_ttf"
SRC_URI="https://github.com/libsdl-org/SDL_ttf/releases/download/release-${MY_PV}/${REAL_P}.tar.gz"
S="${WORKDIR}/${REAL_P}"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~x86"
IUSE="+harfbuzz static-libs X"

# On bumps, check external/ for versions of bundled freetype + harfbuzz
# to crank up the dep bounds.
RDEPEND="
	>=media-libs/libsdl3-3.2.2[${MULTILIB_USEDEP}]
	>=media-libs/freetype-2.13.2[harfbuzz?,${MULTILIB_USEDEP}]
	virtual/opengl[${MULTILIB_USEDEP}]
	harfbuzz? ( >=media-libs/harfbuzz-8.1.1:=[${MULTILIB_USEDEP}] )
"
DEPEND="${RDEPEND}"

multilib_src_configure() {
	local mycmakeargs=(
		-DSDLTTF_VENDORED=OFF
		-DSDLTTF_HARFBUZZ=$(usex harfbuzz)
	)

	cmake_src_configure
}

multilib_src_install_all() {
	dodoc CHANGES.txt README.md

	rm -rf "${ED}"/usr/share/licenses/ || die
}
