# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake subversion optfeature

DESCRIPTION="A set of extra plugins for Qmmp"
HOMEPAGE="http://qmmp.ylsoftware.com/"
ESVN_REPO_URI="svn://svn.code.sf.net/p/qmmp-dev/code/trunk/${PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="
	dev-qt/qtbase:6[gui,network,widgets]
	media-libs/taglib:=
	=media-sound/qmmp-$(ver_cut 1-2)*
"
DEPEND="${RDEPEND}
	dev-lang/yasm
	dev-qt/qttools:6[linguist]
	virtual/pkgconfig
"

src_configure() {
	mycmakeargs=(
		-DUSE_FFAP=ON
		-DUSE_FFVIDEO=OFF
		-DUSE_GOOM=OFF
		-DUSE_SRC=OFF
		-DUSE_YTB=OFF
	)
	cmake_src_configure
}

pkg_postinst() {
	optfeature "audio playback from YouTube" net-misc/yt-dlp
}
