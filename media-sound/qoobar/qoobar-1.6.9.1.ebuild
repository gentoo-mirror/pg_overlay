# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit qmake-utils 

DESCRIPTION="Qoobar - Audio Tagger for Classical Music"
HOMEPAGE="http://qoobar.sourceforge.net"
SRC_URI="http://downloads.sourceforge.net/sourceforge/${PN}/${P}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	app-i18n/enca
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	media-libs/flac
	media-libs/libdiscid
	media-sound/shntool
"
DEPEND="${RDEPEND}"

src_configure() {
	export QT_SELECT="5"
	lrelease src/${PN}_app/${PN}_app.pro
	qmake
}

src_compile() {
	emake
}
