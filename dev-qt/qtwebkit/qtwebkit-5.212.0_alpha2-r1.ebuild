# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )
QT_MIN_VER="5.9.1:5"
inherit cmake-utils python-any-r1 versionator

DESCRIPTION="WebKit rendering library for the Qt5 framework (deprecated)"

SLOT="5"

#KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"

SRC_URI="https://github.com/annulen/webkit/releases/download/${P/_/-}/${P/_/-}.tar.xz"

# TODO: qttestlib

IUSE="geolocation gstreamer gles2 +jit multimedia opengl orientation printsupport qml test webchannel webp"
REQUIRED_USE="?? ( gstreamer multimedia )"

RDEPEND="
	dev-db/sqlite:3
	dev-libs/icu:=
	>=dev-libs/leveldb-1.18-r1
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
	virtual/opengl
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXrender
	geolocation? ( >=dev-qt/qtpositioning-${QT_MIN_VER} )
	gstreamer? (
		dev-libs/glib:2
		media-libs/gstreamer:1.0
		media-libs/gst-plugins-base:1.0
	)
	multimedia? ( >=dev-qt/qtmultimedia-${QT_MIN_VER}[widgets] )
	opengl? (
		>=dev-qt/qtgui-${QT_MIN_VER}[gles2=]
		>=dev-qt/qtopengl-${QT_MIN_VER}
	)
	orientation? ( >=dev-qt/qtsensors-${QT_MIN_VER} )
	printsupport? ( >=dev-qt/qtprintsupport-${QT_MIN_VER} )
	qml? ( >=dev-qt/qtdeclarative-${QT_MIN_VER} )
	webchannel? ( >=dev-qt/qtwebchannel-${QT_MIN_VER} )
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

PATCHES=(
	"${FILESDIR}/${PN}-gcc7.patch"
	"${FILESDIR}/${PN}-null-pointer-dereference.patch"
	"${FILESDIR}/${PN}-cmake-3.10.patch"
	"${FILESDIR}/${PN}-5.212-up-to-date.patch"
)

S=${WORKDIR}/${P/_/-}

src_configure() {
	local mycmakeargs=(
		-DENABLE_DEVICE_ORIENTATION=$(usex orientation)
		-DENABLE_GAMEPAD_DEPRECATED=OFF
		-DENABLE_GEOLOCATION=$(usex geolocation)
		-DENABLE_PRINT_SUPPORT=$(usex printsupport)
		-DENABLE_QT_GESTURE_EVENTS=$(usex orientation)
		-DENABLE_QT_WEBCHANNEL=$(usex webchannel)
		-DUSE_GSTREAMER=$(usex gstreamer)
		-DUSE_MEDIA_FOUNDATION=$(usex multimedia)
		-DUSE_QT_MULTIMEDIA=$(usex multimedia)
		-DPORT=Qt
		-DENABLE_TOOLS=OFF
		-DENABLE_API_TESTS=OFF
	)

	cmake-utils_src_configure
}
