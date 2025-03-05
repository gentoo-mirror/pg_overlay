# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib

DESCRIPTION="Simple Direct Media Layer"
HOMEPAGE="https://libsdl.org/"
SRC_URI="https://github.com/libsdl-org/SDL/releases/download/release-${PV}/SDL3-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~x86 ~amd64"

IUSE_CPU_FLAGS_X86="cpu_flags_x86_avx cpu_flags_x86_avx2 cpu_flags_x86_avx512f cpu_flags_x86_mmx cpu_flags_x86_sse cpu_flags_x86_sse2 cpu_flags_x86_sse3 cpu_flags_x86_sse4_1 cpu_flags_x86_sse4_2"
IUSE_CPU_FLAGS_PPC="cpu_flags_ppc_altivec"
IUSE_CPU_FLAGS_ARM="cpu_flags_arm_simd cpu_flags_arm_neon"
IUSE_CPU_FLAGS_LOONG="cpu_flags_loong_lsx cpu_flags_loong_lasx"
IUSE_CPU_FLAGS="${IUSE_CPU_FLAGS_X86} ${IUSE_CPU_FLAGS_PPC} ${IUSE_CPU_FLAGS_ARM} ${IUSE_CPU_FLAGS_LOONG}"
IUSE_VIDEO_CARDS="video_cards_vc4 video_cards_rockchip video_cards_vivante"
IUSE="alsa dbus gles2 +haptic +hidapi ibus jack +joystick kms libdecor libusb opengl oss pic pipewire pulseaudio sndio +sound static-libs test +threads udev +video vulkan wayland webcam X xscreensaver"
IUSE+=" ${IUSE_CPU_FLAGS} ${IUSE_VIDEO_CARDS}"

RESTRICT="!test? ( test )"
REQUIRED_USE="
	alsa? ( sound )
	jack? ( sound )
	oss? ( sound )
	pulseaudio? ( sound )
	sndio? ( sound )
	X? ( video )
	webcam? ( video )
	gles2? ( video )
	kms? ( video )
	opengl? ( video )
	video_cards_rockchip? ( video )
	video_cards_vc4? ( video )
	vulkan? ( video )
	wayland? ( video )
	xscreensaver? ( X )
	libdecor? ( wayland )
	static-libs? ( pic )
"

DEPEND="
	virtual/libiconv[${MULTILIB_USEDEP}]
	alsa? ( >=media-libs/alsa-lib-1.0.27.2[${MULTILIB_USEDEP}] )
	dbus? ( >=sys-apps/dbus-1.6.18-r1[${MULTILIB_USEDEP}] )
	gles2? ( >=media-libs/mesa-9.1.6[${MULTILIB_USEDEP},gles2(+)] )
	ibus? ( app-i18n/ibus )
	jack? ( virtual/jack[${MULTILIB_USEDEP}] )
	kms? (
		>=x11-libs/libdrm-2.4.82[${MULTILIB_USEDEP}]
		>=media-libs/mesa-9.0.0[${MULTILIB_USEDEP},gbm(+)]
	)
	opengl? (
		>=virtual/opengl-7.0-r1[${MULTILIB_USEDEP}]
		>=virtual/glu-9.0-r1[${MULTILIB_USEDEP}]
	)
	pipewire? ( media-video/pipewire:=[${MULTILIB_USEDEP}] )
	pulseaudio? ( media-libs/libpulse[${MULTILIB_USEDEP}] )
	sndio? ( media-sound/sndio:=[${MULTILIB_USEDEP}] )
	udev? ( >=virtual/libudev-208:=[${MULTILIB_USEDEP}] )
	wayland? (
		>=dev-libs/wayland-1.20[${MULTILIB_USEDEP}]
		>=media-libs/mesa-9.1.6[${MULTILIB_USEDEP},egl(+),gles2(+),wayland]
		>=x11-libs/libxkbcommon-0.2.0[${MULTILIB_USEDEP}]
	)
	X? (
		>=x11-libs/libX11-1.6.2[${MULTILIB_USEDEP}]
		>=x11-libs/libXcursor-1.1.14[${MULTILIB_USEDEP}]
		>=x11-libs/libXext-1.3.2[${MULTILIB_USEDEP}]
		>=x11-libs/libXfixes-6.0.0[${MULTILIB_USEDEP}]
		>=x11-libs/libXi-1.7.2[${MULTILIB_USEDEP}]
		>=x11-libs/libXrandr-1.4.2[${MULTILIB_USEDEP}]
		xscreensaver? ( >=x11-libs/libXScrnSaver-1.2.2-r1[${MULTILIB_USEDEP}] )
	)
"
RDEPEND="
	${DEPEND}
	!<media-libs/libsdl2-2.30.50
"
BDEPEND=""

S="${WORKDIR}/SDL3-${PV}"

multilib_src_configure() {
	local mycmakeargs=(
		-DSDL_AUDIO=$(usex sound)
		-DSDL_VIDEO=$(usex video)
		-DSDL_RENDER=ON
		-DSDL_CAMERA=$(usex webcam)
		-DSDL_JOYSTICK=$(usex joystick)
		-DSDL_HAPTIC=$(usex haptic)
		-DSDL_HIDAPI=$(usex hidapi)
		-DSDL_POWER=ON
		-DSDL_SENSOR=ON
		-DSDL_DIALOG=ON

		-DSDL_ASSEMBLY=ON
		-DSDL_AVX=$(usex cpu_flags_x86_avx)
		-DSDL_AVX2=$(usex cpu_flags_x86_avx2)
		-DSDL_AVX512F=$(usex cpu_flags_x86_avx512f)
		-DSDL_SSE=$(usex cpu_flags_x86_sse)
		-DSDL_SSE2=$(usex cpu_flags_x86_sse2)
		-DSDL_SSE3=$(usex cpu_flags_x86_sse3)
		-DSDL_SSE4_1=$(usex cpu_flags_x86_sse4_1)
		-DSDL_SSE4_2=$(usex cpu_flags_x86_sse4_2)
		-DSDL_MMX=$(usex cpu_flags_x86_mmx)
		-DSDL_ALTIVEC=$(usex cpu_flags_ppc_altivec)
		-DSDL_ARMSIMD=$(usex cpu_flags_arm_simd)
		-DSDL_ARMNEON=$(usex cpu_flags_arm_neon)
		-DSDL_LSX=$(usex cpu_flags_loong_lsx)
		-DSDL_LASX=$(usex cpu_flags_loong_lasx)

		-DSDL_LIBC=ON
		-DSDL_SYSTEM_ICONV=ON
		-DSDL_LIBICONV=ON
		-DSDL_GCC_ATOMICS=ON
		-DSDL_DBUS=$(usex dbus)
		-DSDL_DISKAUDIO=$(usex sound)
		-DSDL_DUMMYAUDIO=$(usex sound)
		-DSDL_DUMMYVIDEO=$(usex video)
		-DSDL_IBUS=$(usex ibus)
		-DSDL_OPENGL=$(usex opengl)
		-DSDL_OPENGLES=$(usex gles2)
		-DSDL_PTHREADS=$(usex threads)
		-DSDL_PTHREADS_SEM=$(usex threads)
		-DSDL_OSS=$(usex oss)
		-DSDL_ALSA=$(usex alsa)
		-DSDL_ALSA_SHARED=OFF
		-DSDL_JACK=$(usex jack)
		-DSDL_JACK_SHARED=OFF
		-DSDL_PIPEWIRE=$(usex pipewire)
		-DSDL_PIPEWIRE_SHARED=OFF
		-DSDL_PULSEAUDIO=$(usex pulseaudio)
		-DSDL_PULSEAUDIO_SHARED=OFF
		-DSDL_SNDIO=$(usex sndio)
		-DSDL_SNDIO_SHARED=OFF
		-DSDL_RPATH=OFF
		-DSDL_CLOCK_GETTIME=ON
		-DSDL_X11=$(usex X)
		-DSDL_X11_SHARED=OFF
		-DSDL_X11_XCURSOR=$(usex X)
		-DSDL_X11_XDBE=$(usex X)
		-DSDL_X11_XINPUT=$(usex X)
		-DSDL_X11_XFIXES=$(usex X)
		-DSDL_X11_XRANDR=$(usex X)
		-DSDL_X11_XSCRNSAVER=$(usex xscreensaver)
		-DSDL_X11_XSHAPE=$(usex X)
		-DSDL_WAYLAND=$(usex wayland)
		-DSDL_WAYLAND_SHARED=OFF
		-DSDL_WAYLAND_LIBDECOR=$(usex libdecor)
		-DSDL_WAYLAND_LIBDECOR_SHARED=OFF
		-DSDL_RPI=$(usex video_cards_vc4)
		-DSDL_ROCKCHIP=$(usex video_cards_rockchip)
		-DSDL_RENDER_D3D=OFF
		-DSDL_VIVANTE=$(usex video_cards_vivante)
		-DSDL_VULKAN=$(usex vulkan)
		-DSDL_RENDER_VULKAN=$(usex vulkan)
		-DSDL_KMSDRM=$(usex kms)
		-DSDL_KMSDRM_SHARED=OFF
		-DSDL_OFFSCREEN=ON
		-DSDL_DUMMYCAMERA=$(usex webcam)
		-DSDL_HIDAPI=$(usex hidapi)
		-DSDL_HIDAPI_LIBUSB=$(usex libusb)
		-DSDL_HIDAPI_LIBUSB_SHARED=ON
		-DSDL_HIDAPI_JOYSTICK=$(usex joystick)
		-DSDL_VIRTUAL_JOYSTICK=$(usex joystick)
		-DSDL_LIBUDEV=$(usex udev)
		-DSDL_ASAN=OFF
		-DSDL_CCACHE=OFF
		-DSDL_CLANG_TIDY=OFF

		-DSDL_SHARED=ON
		-DSDL_STATIC=$(usex static-libs)
		-DSDL_TEST_LIBRARY=$(usex test)

		-DSDL_TESTS=$(usex test)
		-DSDL_INSTALL_TESTS=$(usex test)
		-DSDL_TESTS_LINK_SHARED=$(usex test)
	)

	cmake_src_configure
}
