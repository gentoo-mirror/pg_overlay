# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

WX_GTK_VER="3.2-gtk3"

inherit autotools wxwidgets xdg git-r3

DESCRIPTION="Analyse your audio files by showing their spectrogram"
HOMEPAGE="http://spek.cc"
EGIT_REPO_URI="https://github.com/alexkay/${PN}.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=media-video/ffmpeg-5:=
	x11-libs/wxGTK:${WX_GTK_VER}[X]
"
DEPEND="${RDEPEND}"
BDEPEND="
	sys-devel/gettext
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${PN}-0.8.4-disable-updates.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	setup-wxwidgets unicode
	default
}
