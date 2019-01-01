# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit desktop gnome2-utils qmake-utils git-r3

DESCRIPTION="Birdtray is a free system tray notification for new mail for Thunderbird. Its primary platform is Linux/X Windows"
HOMEPAGE="https://github.com/gyunaev/birdtray"
EGIT_REPO_URI="https://github.com/gyunaev/birdtray.git"
LICENSE="GPLv3"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-db/sqlite
	dev-qt/qtcore:5=
	dev-qt/qtx11extras:5=
	"

S="${WORKDIR}/${P}/src"

src_configure() {
	eqmake5
}

src_install() {
	default
}

pkg_preinst() { gnome2_icon_savelist; }
pkg_postinst() { gnome2_icon_cache_update; }
pkg_postrm() { gnome2_icon_cache_update; }
