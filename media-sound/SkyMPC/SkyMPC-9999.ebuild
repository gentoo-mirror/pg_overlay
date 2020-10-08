# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PLOCALES="ja"

inherit desktop gnome2-utils qmake-utils git-r3 l10n

DESCRIPTION="a simple MPD (Music Player Daemon) client, powerd by Qt"
HOMEPAGE="https://github.com/soramimi/SkyMPC"
EGIT_REPO_URI="https://github.com/soramimi/${PN}.git"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5"

DEPEND="${RDEPEND}
	dev-lang/ruby"

src_prepare() {
	default
	rem_locale() {
		rm "${PN}_${1}.ts" || die "removing of ${1}.ts failed"
		rm "${PN}_${1}.qm" || die "removing of ${1}.qm failed"
		sed -i "s/${PN}_${1}.ts//g" ${PN}.pro || die "removing of ${1}.ts failed"
	}

	l10n_for_each_disabled_locale_do rem_locale
}

src_configure() {
	# Generate binary translations.
	lrelease ${PN}.pro || die

	eqmake5
}

pkg_preinst() { gnome2_icon_savelist; }
pkg_postinst() { xdg_icon_cache_update; }
pkg_postrm() { xdg_icon_cache_update; }
