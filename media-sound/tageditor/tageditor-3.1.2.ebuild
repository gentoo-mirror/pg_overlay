# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="A tag editor with Qt GUI and command-line interface. Supports MP4 (iTunes), ID3, Vorbis, Opus, FLAC and Matroska"
HOMEPAGE="https://github.com/Martchus/tageditor"
SRC_URI="https://github.com/Martchus/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="5"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-qt/qtcore
	dev-qt/qtdeclarative
	dev-qt/qtgui
	dev-qt/qtwebkit
	dev-util/qtutilities
	media-sound/tagparser
"
DEPEND="${RDEPEND}"


src_configure() {
	local mycmakeargs=(
		-DJS_PROVIDER=qml
		-DWEBVIEW_PROVIDER=webkit
		-DCMAKE_BUILD_TYPE=Release
	)

	cmake-utils_src_configure
}
