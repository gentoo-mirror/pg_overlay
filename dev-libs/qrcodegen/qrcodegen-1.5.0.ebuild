# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )

inherit autotools libtool python-any-r1

DESCRIPTION="Lightweight library for extracting data from files archived in a single zip file"
HOMEPAGE="https://www.nayuki.io/page/qr-code-generator-library/"
SRC_URI="https://github.com/nayuki/QR-Code-generator/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
	${PYTHON_DEPS}"

PATCHES=( "${FILESDIR}/batch-test.patch"
		"${FILESDIR}/c-lib.patch"
		"${FILESDIR}/cpp-lib.patch" )

src_compile() {
	default
	cd "${S}"/cpp
	emake
}

src_install() {
	default
}

