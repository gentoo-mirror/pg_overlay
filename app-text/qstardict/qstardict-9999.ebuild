# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="6"

case $PV in *9999*) VCS_ECLASS="git-r3" ;; *) VCS_ECLASS="" ;; esac

inherit eutils qmake-utils confutils ${VCS_ECLASS}

DESCRIPTION="QStarDict is a StarDict clone written with using Qt"
HOMEPAGE="http://qstardict.ylsoftware.com/"
LICENSE="GPL-2"
if [ -n "${VCS_ECLASS}" ]; then
	KEYWORDS=""
	EGIT_REPO_URI="https://github.com/Ri0n/qstardict"
else
	KEYWORDS="~amd64 ~ia64 ~x86"
	SRC_URI="https://github.com/a-rodin/qstardict/archive/${P}.zip"
fi
SLOT="0"

PLUGINS="multitran stardict swac web"
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
