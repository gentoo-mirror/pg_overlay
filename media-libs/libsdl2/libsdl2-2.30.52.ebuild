# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib

MY_P="sdl2-compat-${PV}"
DESCRIPTION="Simple Direct Media Layer"
HOMEPAGE="https://www.libsdl.org/"
SRC_URI="https://github.com/libsdl-org/sdl2-compat/releases/download/release-${PV}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"

IUSE="alsa gles2 haptic +joystick opengl +sound test +video vulkan X"
REQUIRED_USE="test? ( joystick opengl sound video )"

RDEPEND="
	>=media-libs/libsdl3-3.2.0[${MULTILIB_USEDEP},alsa=,gles2=,haptic=,joystick=,opengl=,sound=,video=,vulkan=,X=]
"
DEPEND="
	${RDEPEND}
	test? ( virtual/opengl[${MULTILIB_USEDEP}] )
"

MULTILIB_WRAPPED_HEADERS=(
	/usr/include/SDL2/SDL_config.h
	/usr/include/SDL2/SDL_platform.h
	/usr/include/SDL2/begin_code.h
	/usr/include/SDL2/close_code.h
)

src_sonfigure() {
	local mycmakeargs=(
		-DSDL2TESTS=$(usex test)
	)
	cmake-multilib_src_configure
}
