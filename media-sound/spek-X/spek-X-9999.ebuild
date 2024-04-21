# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
WX_GTK_VER="3.2-gtk3"

inherit autotools git-r3 wxwidgets

DESCRIPTION="Spek-X (IPA: /spɛks/) is a fork of Spek-alternative, which is originally derived from Spek."
HOMEPAGE="https://github.com/MikeWang000000/spek-X"
EGIT_REPO_URI="https://github.com/MikeWang000000/${PN}.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	media-video/ffmpeg:0=
	x11-libs/wxGTK:${WX_GTK_VER}="
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	setup-wxwidgets unicode
	default
}
