# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qmake-utils

LAZ_COMMIT="2fc4aa79cb7741b77edbbc6be0d5f91932728dde"
LAZ_DIRECTORY="lcl/interfaces/qt6/cbindings"
LAZ_UNPACKED_DIR="lazarus-${LAZ_COMMIT}-${LAZ_DIRECTORY//\//-}"

DESCRIPTION="Free Pascal Qt6 bindings library updated by lazarus IDE."
HOMEPAGE="https://gitlab.com/freepascal.org/lazarus/lazarus/-/tree/main/lcl/interfaces/qt6/cbindings"
SRC_URI="	https://gitlab.com/freepascal.org/lazarus/lazarus/-/archive/${LAZ_COMMIT}/lazarus-main.tar.gz?path=${LAZ_DIRECTORY} -> ${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	dev-qt/qtbase:6[gui,network]
"
RDEPEND="${DEPEND}"
BDEPEND=""

PATCHES=( "${FILESDIR}/01_inlines-hidden.patch" )

src_unpack() {
	default

	mv "${WORKDIR}/${LAZ_UNPACKED_DIR}/${LAZ_DIRECTORY}" "${WORKDIR}/${P}"
}

src_configure() {
	eqmake6 Qt6Pas.pro
}

src_install() {
	emake INSTALL_ROOT="${D}" install
}
