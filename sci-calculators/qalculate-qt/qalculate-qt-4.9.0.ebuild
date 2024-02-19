# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Bump with sci-libs/libqalculate and sci-calculators/qalculate-gtk!

inherit qmake-utils

DESCRIPTION="Qt-based UI for libqalculate"
HOMEPAGE="https://github.com/Qalculate/qalculate-qt"
SRC_URI="https://github.com/Qalculate/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	dev-qt/qtbase[gui,network,widgets]:6
	>=sci-libs/libqalculate-${PV}
"
RDEPEND="${DEPEND}"
BDEPEND="dev-qt/qttools[linguist]:6"

src_prepare() {
	default
	eqmake6 PREFIX="${EPREFIX}/usr"
}

src_install() {
	emake INSTALL_ROOT="${ED}" install
}
