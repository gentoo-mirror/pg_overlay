# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils qmake-utils git-r3

DESCRIPTION="Rockbox opensource firmware manager for mp3 players"
HOMEPAGE="http://www.rockbox.org/wiki/RockboxUtility"
EGIT_REPO_URI="git://git.rockbox.org/rockbox.git"
EGIT_COMMIT="28bf763373ef35ac27a70d5af4afee22bf25e15b"
#EGIT_COMMIT="16d1788356e82c639302a884437341e039574822"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-fbsd -x86-fbsd"
IUSE=""

RDEPEND="dev-qt/qtcore:5
	dev-qt/qtgui:5
	virtual/libusb"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${P}/${PN}/${PN}qt

src_configure() {
	export QT_SELECT="5"
	# generate binary translations
	lrelease ${PN}qt.pro || die
	# noccache is required in order to call the correct compiler
	eqmake5 CONFIG+=noccache
}

src_install() {
	newbin RockboxUtility ${PN}
	newicon icons/rockbox-256.png ${PN}.png
	make_desktop_entry ${PN} "Rockbox Utility"
}
