# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qmake-utils xdg

DESCRIPTION="Multi-purpose cross-platform desktop calculator"
HOMEPAGE="https://qalculate.github.io/"
SRC_URI="https://github.com/Qalculate/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
	>=sci-libs/libqalculate-${PV}:=
"
DEPEND="${RDEPEND}"

src_configure() {
	eqmake5 PREFIX="${EPREFIX}"/usr
}

src_install() {
	emake INSTALL_ROOT="${D}" install
}
