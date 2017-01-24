# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils qmake-utils git-r3

DESCRIPTION="Rockbox opensource firmware manager for mp3 players"
HOMEPAGE="http://www.rockbox.org/wiki/RockboxUtility"
EGIT_REPO_URI="git://git.rockbox.org/rockbox.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="dev-qt/qtcore:5
	dev-qt/qtgui:5
	virtual/libusb"
DEPEND="${RDEPEND}"

src_prepare() {
	S=${WORKDIR}/${P}
	default
}

src_configure() {
	S=${WORKDIR}/${P}/${PN}/${PN}qt
	export QT_SELECT="5"
	# generate binary translations
	lrelease ${WORKDIR}/${P}/${PN}/${PN}qt/${PN}qt.pro || die

	# noccache is required in order to call the correct compiler
	eqmake5 CONFIG+=noccache ${WORKDIR}/${P}/${PN}/${PN}qt
}

src_install() {
	S=${WORKDIR}/${P}/${PN}/${PN}qt
	newbin RockboxUtility ${PN}
	newicon icons/rockbox-256.png ${PN}.png
	make_desktop_entry ${PN} "Rockbox Utility"
}
