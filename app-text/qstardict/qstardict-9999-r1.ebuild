# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils qmake-utils git-r3

DESCRIPTION="QStarDict is a StarDict clone written with using Qt"
HOMEPAGE="http://qstardict.ylsoftware.com/"
LICENSE="GPL-2"
KEYWORDS=""
EGIT_REPO_URI="https://github.com/a-rodin/${PN}.git"
SLOT="0"

PLUGINS="stardict swac web"
IUSE_PLUGINS=""
for p in $PLUGINS; do IUSE_PLUGINS="${IUSE_PLUGINS} plugin_${p}"; done;
IUSE="dbus debug kde nls ${IUSE_PLUGINS}"
REQUIRED_USE="|| ( ${IUSE_PLUGINS} )"

DEPEND="
	dev-libs/glib:2
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtprintsupport:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	dev-qt/linguist-tools:5
	dbus? ( dev-qt/qtdbus:5 )
	plugin_swac? ( dev-qt/qtsql:5 )
	kde? (
		kde-frameworks/kwindowsystem
	)
	"
RDEPEND="${RDEPEND}"

src_configure() {
	eplugin() {
		[ -f plugins/${1}/${1}.pro ] && eplugins+=("${1}")
	}

	local eplugins=()
	use kde && eplugin kdeintegration
	for f in $PLUGINS; do
		use "plugin_${f}" && eplugin $f
	done

	QMAKE_FLAGS=(
		ENABLED_PLUGINS="kdeintegration stardict swac web"
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
