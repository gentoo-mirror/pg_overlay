# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic

DESCRIPTION="WebRTC build for Telegram"
HOMEPAGE="https://github.com/desktop-app/tg_owt"

TG_OWT_COMMIT="d618d0b5ff3e59bea0143e6070481f8f4316a428"
LIBYUV_COMMIT="b4ddbaf549a1bf5572bf703fd2862d1eb7380c6a"
SRC_URI="https://github.com/desktop-app/tg_owt/archive/${TG_OWT_COMMIT}.tar.gz -> ${P}.tar.gz
	https://chromium.googlesource.com/libyuv/libyuv/+archive/${LIBYUV_COMMIT}.tar.gz -> libyuv-${LIBYUV_COMMIT}.tar.gz"
	#https://archive.org/download/libyuv-${LIBYUV_COMMIT}.tar/libyuv-${LIBYUV_COMMIT}.tar.gz"
S="${WORKDIR}/${PN}-${TG_OWT_COMMIT}"
# Fetch libyuv archive from: https://chromium.googlesource.com/libyuv/libyuv/+archive/${LIBYUV_COMMIT}.tar.gz

LICENSE="BSD"
SLOT="0/${PV##*pre}"
#KEYWORDS="amd64 ~ppc64 ~riscv"
IUSE="screencast +X"

# This package's USE flags may change the ABI and require a rebuild of
#  dependent pacakges. As such, one should make sure to depend on
#  media-libs/tg_owt[x=,y=,z=] for any package that uses this.

# Bundled libs:
# - libyuv (no stable versioning, www-client/chromium and media-libs/libvpx bundle it)
# - libsrtp (project uses private APIs)
# - pffft (no stable versioning, patched)
# media-libs/libjpeg-turbo is required for libyuv
DEPEND="
	dev-cpp/abseil-cpp:=[cxx17(+)]
	dev-libs/libevent:=
	dev-libs/openssl:=
	dev-libs/protobuf:=
	media-libs/libjpeg-turbo:=
	>=media-libs/libvpx-1.10.0:=
	media-libs/openh264:=
	media-libs/opus
	media-video/ffmpeg:=
	net-libs/usrsctp
	screencast? (
		dev-libs/glib:2
		media-video/pipewire:=
	)
	X? (
		x11-libs/libX11
		x11-libs/libXcomposite
		x11-libs/libXdamage
		x11-libs/libXext
		x11-libs/libXfixes
		x11-libs/libXrender
		x11-libs/libXrandr
		x11-libs/libXtst
	)
"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	#"${FILESDIR}/${PN}-0_pre20210626-allow-disabling-pipewire.patch"
	"${FILESDIR}/${PN}-0_pre20211207-allow-disabling-X11.patch"
	"${FILESDIR}/${PN}-0_pre20210626-allow-disabling-pulseaudio.patch"
	"${FILESDIR}/${PN}-0_pre20211207-fix-dcsctp-references.patch"
	"${FILESDIR}/1d1f6a5fa57bdbe1889c0f2a17533fbf0c512531.patch"
)

src_unpack() {
	unpack "${P}.tar.gz"
	cd "${S}/src/third_party/libyuv" || die
	unpack "libyuv-${LIBYUV_COMMIT}.tar.gz"
}

src_prepare() {
	# libvpx source files aren't included in the repository
	sed -i '/include(cmake\/libvpx.cmake)/d' CMakeLists.txt || die

	# libopenh264 has GENERATED files with yasm that aren't excluded by
	# EXCLUDE_FROM_ALL, and I have no clue how to avoid this.
	# These source files aren't used with system-openh264, anyway.
	sed -i '/include(cmake\/libopenh264.cmake)/d' CMakeLists.txt || die

	cmake_src_prepare
}

src_configure() {
	# Defined by -DCMAKE_BUILD_TYPE=Release, avoids crashes
	# see https://bugs.gentoo.org/754012
	# EAPI 8 still wipes this flag.
	append-cppflags '-DNDEBUG'

	local mycmakeargs=(
		-DTG_OWT_USE_X11=$(usex X)
		-DTG_OWT_USE_PIPEWIRE=$(usex screencast)

		# Not required by net-im/telegram-desktop right now, I'd rather avoid
		#  the (ABI compatibility) headache.
		-DTG_OWT_BUILD_AUDIO_BACKENDS=OFF
		#-DTG_OWT_BUILD_AUDIO_BACKENDS=$(usex alsa)
		#-DTG_OWT_BUILD_PULSE_BACKEND=$(usex pulseaudio)
		-DBUILD_SHARED_LIBS=ON
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install

	# Save about 15MB of useless headers
	rm -r "${ED}/usr/include/tg_owt/rtc_base/third_party" || die
	rm -r "${ED}/usr/include/tg_owt/common_audio/third_party" || die
	rm -r "${ED}/usr/include/tg_owt/modules/third_party" || die
	rm -r "${ED}/usr/include/tg_owt/third_party" || die

	# Install a few headers anyway, as required by net-im/telegram-desktop...
	local headers=(
		third_party/libyuv/include
		rtc_base/third_party/sigslot
		rtc_base/third_party/base64
	)
	for dir in "${headers[@]}"; do
		pushd "${S}/src/${dir}" > /dev/null || die
		find -type f -name "*.h" -exec install -Dm644 '{}' "${ED}/usr/include/tg_owt/${dir}/{}" \; || die
		popd > /dev/null || die
	done
}
