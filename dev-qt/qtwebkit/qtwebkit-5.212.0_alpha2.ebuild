# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
CMAKE_MAKEFILE_GENERATOR="ninja"
PYTHON_COMPAT=( python2_7 )
QT_MIN_VER="5.9.1:5"
inherit cmake-utils python-any-r1 versionator

DESCRIPTION="WebKit rendering library for the Qt5 framework (deprecated)"

SLOT="5"

KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"

SRC_URI="http://download.qt.io/snapshots/ci/${PN}/${PV/.0_*}/latest/src/submodules/${PN}-everywhere-src-${PV/.0_*}.tar.xz -> ${P}.tar.xz"

IUSE="geolocation gstreamer gles2 +jit multimedia opengl orientation printsupport qml test webchannel webp"
REQUIRED_USE="?? ( gstreamer multimedia )"

RDEPEND="
	dev-db/sqlite:3
	dev-libs/icu:=
	dev-libs/hyphen
	dev-libs/libxml2:2
	dev-libs/libxslt
	>=dev-qt/qtcore-${QT_MIN_VER}[icu]
	>=dev-qt/qtgui-${QT_MIN_VER}
	>=dev-qt/qtnetwork-${QT_MIN_VER}
	>=dev-qt/qtsql-${QT_MIN_VER}
	>=dev-qt/qtwidgets-${QT_MIN_VER}
	media-libs/fontconfig:1.0
	media-libs/libpng:0=
	>=sys-libs/zlib-1.2.5
	virtual/jpeg:0
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXrender
	geolocation? ( >=dev-qt/qtpositioning-${QT_MIN_VER} )
	gstreamer? (
		dev-libs/glib:2
		media-libs/gstreamer:1.0
		media-libs/gst-plugins-bad:1.0
		media-libs/gst-plugins-good:1.0
	)
	multimedia? ( >=dev-qt/qtmultimedia-${QT_MIN_VER}[widgets] )
	opengl? ( >=dev-qt/qtopengl-${QT_MIN_VER} )
	orientation? ( >=dev-qt/qtsensors-${QT_MIN_VER} )
	printsupport? ( >=dev-qt/qtprintsupport-${QT_MIN_VER} )
	qml? ( >=dev-qt/qtdeclarative-${QT_MIN_VER} )
	webchannel? ( >=dev-qt/qtwebchannel-${QT_MIN_VER}[qml] )
	webp? ( media-libs/libwebp:0= )
"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	dev-lang/ruby
	dev-util/gperf
	sys-devel/bison
	sys-devel/flex
	virtual/rubygems
	test? ( >=dev-qt/qttest-${QT_MIN_VER} )
"

S=${WORKDIR}/${PN}-everywhere-src-${PV/.0_*}

src_configure() {
	local mycmakeargs=(
		-DENABLE_DEVICE_ORIENTATION=$(usex orientation)
		-DENABLE_GEOLOCATION=$(usex geolocation)
		-DENABLE_JIT=$(usex jit)
		-DENABLE_OPENGL=$(usex opengl)
		-DENABLE_PRINT_SUPPORT=$(usex printsupport)
		-DENABLE_QT_GESTURE_EVENTS=$(usex orientation)
		-DENABLE_QT_WEBCHANNEL=$(usex webchannel)
		-DUSE_GSTREAMER=$(usex gstreamer)
		-DUSE_MEDIA_FOUNDATION=$(usex multimedia)
		-DUSE_QT_MULTIMEDIA=$(usex multimedia)
		-DPORT=Qt
		-DCMAKE_BUILD_TYPE=Release
		-DENABLE_API_TESTS=OFF
		-DENABLE_GAMEPAD_DEPRECATED=OFF
		-DENABLE_NETSCAPE_PLUGIN_API=OFF
		-DENABLE_TOOLS=OFF
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	find "${ED}" -name '*.la' -delete
	# Fix pkgconfig files
	sed -e 's|qt5/Qt5WebKit|qt5/QtWebKit|' -i ${ED}/usr/lib64/pkgconfig/Qt5WebKit.pc || die
	sed -e 's|qt5/Qt5WebKitWidgets|qt5/QtWebKitWidgets|' -i ${ED}/usr/lib64/pkgconfig/Qt5WebKitWidgets.pc  || die
	sed -e '/Name/a Description: Qt WebKit module' -i  ${ED}/usr/lib64/pkgconfig/Qt5WebKit.pc || die
	sed -e '/Name/a Description: Qt WebKitWidgets module' -i ${ED}/usr/lib64/pkgconfig/Qt5WebKitWidgets.pc || die
}
