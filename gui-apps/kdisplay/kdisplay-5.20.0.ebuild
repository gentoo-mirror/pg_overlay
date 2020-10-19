# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_TEST="forceoptional"
KFMIN=5.74.0
PVCUT=$(ver_cut 1-3)
QTMIN=5.15.1
inherit ecm kde.org

if [[ ${PV} = *9999* ]]; then
	if [[ ${PV} != 9999 ]]; then
		EGIT_BRANCH="Plasma/$(ver_cut 1-2)"
	fi
	EGIT_REPO_URI="https://gitlab.com/kwinft/wrapland.git"
	inherit git-r3
else
	SRC_URI="https://gitlab.com/kwinft/${PN}/-/archive/${P/-/@}/${PN}-${P/-/@}.tar.gz"
	S="${WORKDIR}/${PN}-${P/-/@}"
	KEYWORDS="~amd64"
fi

DESCRIPTION="Small display management app. KScreen replacement"
HOMEPAGE="https://gitlab.com/kwinft/kdisplay"

LICENSE="GPL-2" # TODO: CHECK
SLOT="5"
KEYWORDS=""
IUSE=""

DEPEND="
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtdeclarative-${QTMIN}:5[widgets]
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtsensors-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=gui-libs/disman-${PVCUT}:5
	>=kde-frameworks/extra-cmake-modules-${KFMIN}:5
	>=kde-frameworks/kdeclarative-${KFMIN}:5
	>=kde-frameworks/kdbusaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kirigami-${KFMIN}:5
	>=kde-frameworks/kxmlgui-${KFMIN}:5
"
RDEPEND="${DEPEND}
	>=dev-qt/qtgraphicaleffects-${QTMIN}:5
"

# bug #580440, last checked 5.6.3
RESTRICT+=" test"
