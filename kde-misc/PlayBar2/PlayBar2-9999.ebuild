# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PLOCALES="de es pl pt ru zh_CN"

inherit cmake-utils git-r3 kde5-functions l10n

DESCRIPTION="MPRIS2 client, written in QML for Plasma 5"
HOMEPAGE="https://github.com/audoban/PlayBar2"
EGIT_REPO_URI="https://github.com/audoban/${PN}.git"

LICENSE="GPL-3"
SLOT="0"
IUSE=""
KEYWORDS=""

DEPEND="$(add_frameworks_dep extra-cmake-modules)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kdoctools)
	$(add_frameworks_dep kglobalaccel)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kwindowsystem)
	$(add_frameworks_dep kxmlgui)
	$(add_frameworks_dep plasma)
	$(add_qt_dep qtcore)
	$(add_qt_dep qtdeclarative)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtquickcontrols)
	$(add_qt_dep qtwidgets)"
RDEPEND="${DEPEND}"

src_prepare() {
	rem_locale() {
		rm -rf "po/${1}" || die "removing of ${1}.po failed"
	}

	l10n_find_plocales_changes po "" ""
	l10n_for_each_disabled_locale_do rem_locale

	default
	cmake-utils_src_prepare
}
