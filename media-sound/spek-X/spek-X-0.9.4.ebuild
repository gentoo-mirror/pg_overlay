# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
WX_GTK_VER="3.3-gtk3"

inherit autotools wxwidgets xdg

DESCRIPTION="Analyse your audio files by showing their spectrogram"
HOMEPAGE="https://spek.cc/"
SRC_URI="https://github.com/MikeWang000000/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=media-video/ffmpeg-5:=
	x11-libs/wxGTK:${WX_GTK_VER}=[X]
"
DEPEND="${RDEPEND}"
BDEPEND="
	sys-devel/gettext
	virtual/pkgconfig
"

PATCHES=(
)

src_prepare() {
	setup-wxwidgets unicode
	default
	eautoreconf
}
