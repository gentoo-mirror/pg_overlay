# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils qmake-utils ${VCS_ECLASS}

DESCRIPTION="QStarDict is a StarDict clone written with using Qt"
HOMEPAGE="http://qstardict.ylsoftware.com/"
LICENSE="GPL-2"
KEYWORDS=""
EGIT_REPO_URI="https://github.com/a-rodin/qstardict.git"
SLOT="0"

PLUGINS="stardict swac web"
IUSE="dbus kde nls ${PLUGINS}"
REQUIRED_USE="|| ( ${PLUGINS} )"

DEPEND="dev-qt/qtgui:5
	dbus? ( dev-qt/qtdbus:5 )
	dev-libs/glib:2
	swac? ( dev-qt/qtsql:5 )
	kde? ( kde-frameworks/kwindowsystem )
"
RDEPEND="${RDEPEND}"

src_configure() {
	local eplugins=()
	for f in $PLUGINS; do
		use "${f}" && eplugins+=("${f}")
	done
	use kde && eplugins+=("kdeintegration")

	QMAKE_FLAGS=(
		ENABLED_PLUGINS="${eplugins[@]}"
		LIB_DIR="${EPREFIX}/usr/$(get_libdir)/${PN}"
	)
	if ! use dbus; then
		QMAKE_FLAGS+=(NO_DBUS=1)
	fi
	if ! use nls; then
		QMAKE_FLAGS+=(NO_TRANSLATIONS=1)
	fi

	eqmake5 "${PN}".pro "${QMAKE_FLAGS[@]}"
}

src_install() {
	emake install INSTALL_ROOT="${D}"
	einstalldocs
}
