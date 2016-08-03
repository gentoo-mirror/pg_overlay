# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

KDE_LINGUAS="cs de es et fi fr it nl pl ru sr sr@ijekavian sr@ijekavianlatin
sr@Latn tr zh_CN zh_TW"
KDE_REQUIRED="optional"
KDE_HANDBOOK="optional"
inherit kde5

DESCRIPTION="A simple tag editor for KDE"
HOMEPAGE="http://kid3.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="5"
KEYWORDS="~amd64 ~x86"
IUSE="acoustid flac kde mp3 mp4 +phonon +taglib vorbis"

REQUIRED_USE="flac? ( vorbis )"

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtdeclarative:5
	dev-qt/qtgui:5
	dev-qt/qtmultimedia:5
	sys-libs/readline:0
	acoustid? (
		media-libs/chromaprint
		virtual/ffmpeg
	)
	flac? (
		media-libs/flac[cxx]
		media-libs/libvorbis
	)
	mp3? ( media-libs/id3lib )
	mp4? ( media-libs/libmp4v2:0 )
	phonon? ( || (
		media-libs/phonon[qt5]
	) )
	taglib? ( >=media-libs/taglib-1.9.1 )
	vorbis? (
		media-libs/libogg
		media-libs/libvorbis
	)
"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}/${PN}-3.3.2-libdir.patch" )

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package acoustid libchromaprint)
		$(cmake-utils_use_find_package flac flac)
		$(cmake-utils_use_find_package mp3 ID3LIB)
		$(cmake-utils_use_find_package mp4 MP4V2)
		$(cmake-utils_use_find_package phonon phonon)
		$(cmake-utils_use_find_package taglib taglib)
		$(cmake-utils_use_find_package vorbis vorbis)
		"-DWITH_QT5=ON"
	)

	if use kde; then
		mycmakeargs+=("-DWITH_APPS=KDE;CLI")
	else
		mycmakeargs+=("-DWITH_APPS=Qt;CLI")
	fi

	kde5_src_configure
}
