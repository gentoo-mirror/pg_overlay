# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Get PV from lcl/interfaces/qt6/cbindings/Qt6Pas.pro
inherit qmake-utils

LAZARUS_PV=3.0

LAZ_COMMIT="84bc039c0f205bb3379017997f2d5451e527d5e6"

DESCRIPTION="Free Pascal Qt6 bindings library updated by lazarus IDE."
HOMEPAGE="https://gitlab.com/freepascal.org/lazarus/lazarus/-/tree/main/lcl/interfaces/qt6/cbindings"
SRC_URI="https://gitlab.com/freepascal.org/lazarus/lazarus/-/archive/${LAZ_COMMIT}/lazarus-main.tar.gz?path=${LAZ_DIRECTORY} -> ${P}.tar.gz"
S="${WORKDIR}/lazarus-${LAZ_COMMIT}/lcl/interfaces/qt6/cbindings"

LICENSE="LGPL-3"
SLOT="0/${LAZARUS_PV}"
KEYWORDS="~amd64 ~x86"

DEPEND="
	dev-qt/qtbase:6
"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/01_inlines-hidden.patch" )

src_configure() {
	eqmake6 Qt6Pas.pro
}

src_install() {
	emake INSTALL_ROOT="${D}" install
}
