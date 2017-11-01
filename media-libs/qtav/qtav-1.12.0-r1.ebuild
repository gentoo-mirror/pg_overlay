# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_PN="QtAV"
CAPI_HASH="b43aa93"
inherit qmake-utils

DESCRIPTION="Multimedia playback framework based on Qt + FFmpeg"
HOMEPAGE="https://www.qtav.org"
SRC_URI="https://github.com/wang-bin/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
https://dev.gentoo.org/~johu/distfiles/${P}-capi.h-${CAPI_HASH}.xz"

LICENSE="GPL-3+ LGPL-2.1+"
SLOT="0/1"
KEYWORDS="~amd64"
IUSE="gui libav opengl portaudio pulseaudio vaapi"
REQUIRED_USE="gui? ( opengl )"

DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtdeclarative:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	gui? ( dev-qt/qtsql:5 )
	libav? (
		media-video/libav:=
		x11-libs/libX11
	)
	!libav? ( media-video/ffmpeg:= )
	opengl? ( dev-qt/qtopengl:5 )
	portaudio? ( media-libs/portaudio )
	pulseaudio? ( media-sound/pulseaudio )
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_PN}-${PV}"

PATCHES=( "${FILESDIR}/${P}-multilib.patch" )

src_prepare() {
	sed -e 's|\$\$\[QT_INSTALL_BINS\]\/\.\.\/mkspecs|\$\$\[QT_INSTALL_ARCHDATA\]\/mkspecs|g' -i tools/install_sdk/install_sdk.pro
	default
}

src_configure() {
	local myconf=()

	if use gui; then
		myconf+=( x11 )
		myconf+=( xv )
	else
		myconf+=( no-x11 no-xv )
	fi

	if use opengl; then
		myconf+=( gl )
	else
		myconf+=( no-gl )
	fi

	if use portaudio; then
		myconf+=( portaudio )
	else
		myconf+=( no-portaudio )
	fi

	if use pulseaudio; then
		myconf+=( pulseaudio )
	else
		myconf+=( no-pulseaudio )
	fi

	if use vaapi; then
		myconf+=( vaapi )
	else
		myconf+=( no-vaapi )
	fi

	eqmake5 CONFIG+='recheck no-cedarv'
}
