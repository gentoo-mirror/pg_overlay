# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PLOCALES="zh_CN"

inherit cmake-utils kde5-functions l10n

DESCRIPTION="A KDE gui frontend for aMule"
HOMEPAGE="https://www.linux-apps.com/content/show.php?content=150270"
SRC_URI="https://dl.opendesktop.org/api/files/download/id/1466632134/150270-${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
IUSE=""
KEYWORDS=""

DEPEND="$(add_frameworks_dep extra-cmake-modules)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kiconthemes)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep knotifications)
	$(add_frameworks_dep kpty)
	$(add_qt_dep qtcore)
	$(add_qt_dep qtnetwork)
	$(add_qt_dep qtwidgets)"
RDEPEND="${DEPEND}"

src_prepare() {
	rem_locale() {
		rm -rf "po/${1}.po" || die "removing of ${1}.po failed"
	}

	l10n_find_plocales_changes po "" "po"
	l10n_for_each_disabled_locale_do rem_locale

	default
	cmake-utils_src_prepare
}
