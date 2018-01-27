# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PLOCALES="cs de fi fr gr he it ja nl pl pt pt_BR ru tr zh_CN zh_TW"

inherit eutils qmake-utils git-r3 l10n

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

S=${WORKDIR}/${P}/${PN}/${PN}qt

src_prepare() {
	default
	rem_locale() {
		rm "lang/${PN}_${1}.ts" || die "removing of ${1}.ts failed"
	}

	l10n_find_plocales_changes lang "" ".ts"
	l10n_for_each_disabled_locale_do rem_locale

	sed 's/LIBS += -lz/LIBS += -lz -lcryptopp/' -i rbutilqt.pro || die
}

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
