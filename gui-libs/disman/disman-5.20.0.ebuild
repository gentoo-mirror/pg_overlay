# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_QTHELP="true"
ECM_TEST="forceoptional"
KFMIN=5.74.0
PVCUT=$(ver_cut 1-3)
QTMIN=5.15.1
VIRTUALX_REQUIRED="test"
inherit ecm kde.org

if [[ ${PV} = *9999* ]]; then
	if [[ ${PV} != 9999 ]]; then
		EGIT_BRANCH="Plasma/$(ver_cut 1-2)"
	fi
	EGIT_REPO_URI="https://gitlab.com/kwinft/${PN}.git"
	inherit git-r3
else
	MY_PV=0.${PV/./}
	SRC_URI="https://gitlab.com/kwinft/${PN}/-/archive/${PN}@${MY_PV}/${PN}-${PN}@${MY_PV}.tar.gz"
	S="${WORKDIR}/${PN}-${PN}@${MY_PV}"
	KEYWORDS="~amd64"
fi

DESCRIPTION="A display management service and library. LibKScreen replacement"

LICENSE="GPL-2" # TODO: CHECK
SLOT="5/7"
KEYWORDS=""
IUSE=""

DEPEND="
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtx11extras-${QTMIN}:5
	gui-libs/wrapland
	>=kde-frameworks/extra-cmake-modules-${KFMIN}:5
	x11-libs/libxcb
"
RDEPEND="${DEPEND}"

# requires running session
RESTRICT+=" test"
