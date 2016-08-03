# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-utils

DESCRIPTION="A tag editor with Qt GUI and command-line interface. Supports MP4 (iTunes), ID3, Vorbis, Opus, FLAC and Matroska"
HOMEPAGE="https://github.com/Martchus/tageditor"
SRC_URI="https://github.com/Martchus/${PN}/archive/v${PV}.tar.gz"

LICENSE="GPL-2+"
SLOT="5"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtdeclarative:5
	dev-qt/qtgui:5
	dev-qt/qtscript:5
	dev-qt/qtwebengine:5
	dev-util/qtutilities
	media-sound/tagparser
"
DEPEND="${RDEPEND}"


src_configure() {
	local mycmakeargs=(
		-DWIDGETS_GUI=ON
		-DJS_PROVIDER=qml
		-DWEBVIEW_PROVIDER=webengine
		-DCMAKE_BUILD_TYPE=Release
	)

	cmake-utils_src_configure
}
