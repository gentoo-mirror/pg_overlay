# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-utils git-r3

DESCRIPTION="A tag editor with Qt GUI and command-line interface. Supports MP4 (iTunes), ID3, Vorbis, Opus, FLAC and Matroska"
HOMEPAGE="https://github.com/Martchus/tageditor"
EGIT_REPO_URI="git://github.com/Martchus/tageditor.git"

LICENSE="GPL-2+"
SLOT="5"
KEYWORDS="~amd64 ~x86"
IUSE=""

REQUIRED_USE=""

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtdeclarative:5
	dev-qt/qtgui:5
	dev-qt/qtscript:5
	dev-qt/qtwebengine:5
	media-sound/tagparser
"
DEPEND="${RDEPEND}"


src_configure() {
	local mycmakeargs=(
		-DWIDGETS_GUI=ON
		-DWEBVIEW_PROVIDER=webengine
		-DCMAKE_BUILD_TYPE=Release
	)

	cmake-utils_src_configure
}
