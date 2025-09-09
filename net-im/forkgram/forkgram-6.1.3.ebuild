# Copyright 2020-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..13} )

inherit xdg cmake python-any-r1 optfeature flag-o-matic

DESCRIPTION="Forkgram is the fork of the official Telegram Desktop application. This fork does not fundamentally change the official client and adds only some useful small feature"
HOMEPAGE="https://github.com/forkgram/tdesktop"

SRC_URI="https://github.com/${PN}/tdesktop/releases/download/v${PV}/frk-v${PV}-full.tar.gz"
#SRC_URI="https://github.com/${PN}/tdesktop/releases/download/v${PV}/frk-v-full.tar.gz -> frk-v${PV}-full.tar.gz"

LICENSE="BSD GPL-3-with-openssl-exception LGPL-2+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="dbus enchant +fonts screencast wayland webkit +X"

CDEPEND="
	!net-im/telegram-desktop-bin
	app-arch/lz4:=
	dev-cpp/abseil-cpp:=
	dev-cpp/ada:=
	dev-cpp/cld3:=
	>=dev-cpp/glibmm-2.77:2.68
	dev-libs/glib:2
	dev-libs/libdispatch
	dev-libs/openssl:=
	dev-libs/protobuf
	dev-libs/qr-code-generator:=
	dev-libs/xxhash
	>=dev-qt/qtbase-6.5:6=[dbus?,gui,network,opengl,ssl,wayland?,widgets,X?]
	>=dev-qt/qtimageformats-6.5:6
	>=dev-qt/qtsvg-6.5:6
	media-libs/libjpeg-turbo:=
	media-libs/openal
	media-libs/opus
	media-libs/rnnoise
	>=media-libs/tg_owt-0_pre20241202:=[screencast=,X=]
	>=media-video/ffmpeg-4:=[opus,vpx]
	net-libs/tdlib:=[tde2e]
	sys-libs/zlib:=[minizip]
	kde-frameworks/kcoreaddons:6
	!enchant? ( >=app-text/hunspell-1.7:= )
	enchant? ( app-text/enchant:= )
	webkit? ( wayland? (
		>=dev-qt/qtdeclarative-6.5:6
		>=dev-qt/qtwayland-6.5:6[compositor(+),qml]
	) )
	X? (
		x11-libs/libxcb:=
		x11-libs/xcb-util-keysyms
	)
"
RDEPEND="${CDEPEND}
	webkit? ( || ( net-libs/webkit-gtk:4.1 net-libs/webkit-gtk:6 ) )
"
DEPEND="${CDEPEND}
	>=dev-cpp/cppgir-2.0_p20240315
	dev-cpp/expected
	dev-cpp/expected-lite
	>=dev-cpp/ms-gsl-4.1.0
	dev-cpp/range-v3
"
BDEPEND="
	${PYTHON_DEPS}
	>=dev-build/cmake-3.16
	>=dev-cpp/cppgir-2.0_p20240315
	dev-util/gdbus-codegen
	virtual/pkgconfig
	wayland? ( dev-util/wayland-scanner )
"

S=${WORKDIR}/frk-v${PV}-full
#S=${WORKDIR}/frk-v-full

PATCHES=(
	"${FILESDIR}"/tdesktop-5.14.3-system-cppgir.patch
	"${FILESDIR}"/tdesktop-4.11.3-system-libyuv.patch
	"${FILESDIR}"/option-to-disable-stories.patch
	"${FILESDIR}"/0000-data_data_sponsored_messages.cpp.patch
	#"${FILESDIR}"/pins.patch
	"${FILESDIR}"/invite-peeking-restrictions.patch
	"${FILESDIR}"/saving-restrictions.patch
	"${FILESDIR}"/0001-kde-theme-injection-fix.patch
)

pkg_pretend() {
	if has ccache ${FEATURES}; then
		ewarn "ccache does not work with ${PN} out of the box"
		ewarn "due to usage of precompiled headers"
		ewarn "check bug https://bugs.gentoo.org/715114 for more info"
		ewarn
	fi
}

src_prepare() {
	# Happily fail if libraries aren't found...
	find -type f \( -name 'CMakeLists.txt' -o -name '*.cmake' \) \
		\! -path './Telegram/lib_webview/CMakeLists.txt' \
		\! -path './cmake/external/expected/CMakeLists.txt' \
		\! -path './cmake/external/kcoreaddons/CMakeLists.txt' \
		\! -path './cmake/external/qt/package.cmake' \
		\! -path './cmake/external/lz4/CMakeLists.txt' \
		\! -path './cmake/external/opus/CMakeLists.txt' \
		\! -path './cmake/external/xxhash/CMakeLists.txt' \
		-print0 | xargs -0 sed -i \
		-e '/pkg_check_modules(/s/[^ ]*)/REQUIRED &/' \
		-e '/find_package(/s/)/ REQUIRED)/' \
		-e '/find_library(/s/)/ REQUIRED)/' || die
	# Make sure to check the excluded files for new
	# CMAKE_DISABLE_FIND_PACKAGE entries.

	# Some packages are found through pkg_check_modules, rather than find_package
	sed -e '/find_package(lz4 /d' -i cmake/external/lz4/CMakeLists.txt || die
	sed -e '/find_package(Opus /d' -i cmake/external/opus/CMakeLists.txt || die
	sed -e '/find_package(xxHash /d' -i cmake/external/xxhash/CMakeLists.txt || die

	# Control QtDBus dependency from here, to avoid messing with QtGui.
	# QtGui will use find_package to find QtDbus as well, which
	# conflicts with the -DCMAKE_DISABLE_FIND_PACKAGE method.
	if ! use dbus; then
		sed -e '/find_package(Qt[^ ]* OPTIONAL_COMPONENTS/s/DBus *//' \
			-i cmake/external/qt/package.cmake || die
	fi

	# Control automagic dep only needed when USE="webkit wayland"
	if ! use webkit || ! use wayland; then
		sed -e 's/QT_CONFIG(wayland_compositor_quick)/0/' \
			-i Telegram/lib_webview/webview/platform/linux/webview_linux_compositor.h || die
	fi

	cmake_src_prepare
}

src_configure() {
	# Having user paths sneak into the build environment through the
	# XDG_DATA_DIRS variable causes all sorts of weirdness with cppgir:
	# - bug 909038: can't read from flatpak directories (fixed upstream)
	# - bug 920819: system-wide directories ignored when variable is set
	export XDG_DATA_DIRS="${EPREFIX}/usr/share"

	# Evil flag (bug #919201)
	filter-flags -fno-delete-null-pointer-checks

	# The ABI of media-libs/tg_owt breaks if the -DNDEBUG flag doesn't keep
	# the same state across both projects.
	# See https://bugs.gentoo.org/866055
	append-cppflags '-DNDEBUG'

	local use_webkit_wayland=$(use webkit && use wayland && echo yes || echo no)
	local mycmakeargs=(
		-DQT_VERSION_MAJOR=6

		# Override new cmake.eclass defaults (https://bugs.gentoo.org/921939)
		# Upstream never tests this any other way
		-DCMAKE_DISABLE_PRECOMPILE_HEADERS=OFF

		# Control automagic dependencies on certain packages
		## Header-only lib, some git version.
		-DCMAKE_DISABLE_FIND_PACKAGE_tl-expected=ON
		#-DCMAKE_DISABLE_FIND_PACKAGE_QtQt6Quick=${use_webkit_wayland}
		#-DCMAKE_DISABLE_FIND_PACKAGE_QtQt6QuickWidgets=${use_webkit_wayland}
		#-DCMAKE_DISABLE_FIND_PACKAGE_QtQt6WaylandClient=$(usex !wayland)
		#-DCMAKE_DISABLE_FIND_PACKAGE_QtQt6WaylandCompositor=${use_webkit_wayland}
		## KF6CoreAddons is currently unavailable in ::gentoo
		#-DCMAKE_DISABLE_FIND_PACKAGE_KFQt6CoreAddons=ON

		-DDESKTOP_APP_DISABLE_X11_INTEGRATION=$(usex !X)
		## Enables enchant and disables hunspell
		-DDESKTOP_APP_USE_ENCHANT=$(usex enchant)
		## Use system fonts instead of bundled ones
		-DDESKTOP_APP_USE_PACKAGED_FONTS=$(usex !fonts)
	)

	if [[ -n ${MY_TDESKTOP_API_ID} && -n ${MY_TDESKTOP_API_HASH} ]]; then
		einfo "Found custom API credentials"
		mycmakeargs+=(
			-DTDESKTOP_API_ID="${MY_TDESKTOP_API_ID}"
			-DTDESKTOP_API_HASH="${MY_TDESKTOP_API_HASH}"
		)
	else
		# https://github.com/telegramdesktop/tdesktop/blob/dev/snap/snapcraft.yaml
		# Building with snapcraft API credentials by default
		# Custom API credentials can be obtained here:
		# https://github.com/telegramdesktop/tdesktop/blob/dev/docs/api_credentials.md
		# After getting credentials you can export variables:
		#  export MY_TDESKTOP_API_ID="17349""
		#  export MY_TDESKTOP_API_HASH="344583e45741c457fe1862106095a5eb"
		# and restart the build"
		# you can set above variables (without export) in /etc/portage/env/net-im/telegram-desktop
		# portage will use custom variable every build automatically
		mycmakeargs+=(
			-DTDESKTOP_API_ID="611335"
			-DTDESKTOP_API_HASH="d524b414d21f4d37f08684c1df41ac9c"
		)
	fi

	cmake_src_configure
}

pkg_postinst() {
	xdg_pkg_postinst
	if ! use X && ! use screencast; then
		ewarn "both the 'X' and 'screencast' USE flags are disabled, screen sharing won't work!"
		ewarn
	fi
	optfeature_header
	optfeature "AVIF, HEIF and JpegXL image support" kde-frameworks/kimageformats:6[avif,heif,jpegxl]
}
