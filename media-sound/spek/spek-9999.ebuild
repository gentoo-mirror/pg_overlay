# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
WX_GTK_VER="3.0-gtk3"

inherit autotools eutils git-r3 toolchain-funcs wxwidgets

DESCRIPTION="Analyse your audio files by showing their spectrogram"
HOMEPAGE="http://www.spek-project.org/"
EGIT_REPO_URI="git://github.com/alexkay/${PN}.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="libav"

RDEPEND="
	libav? ( media-video/libav:= )
	!libav? ( media-video/ffmpeg:0= )
	x11-libs/wxGTK:${WX_GTK_VER}[X]
"
DEPEND="${RDEPEND}
	dev-util/intltool
	virtual/pkgconfig
	>=sys-devel/gcc-4.7
	sys-devel/gettext
"
src_prepare() {
	need-wxwidgets unicode
	eautoreconf
}
