# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic toolchain-funcs

DESCRIPTION="High level abstract threading library"
HOMEPAGE="https://www.intel.com/content/www/us/en/developer/tools/oneapi/onetbb.html"
SRC_URI="https://github.com/oneapi-src/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ppc ppc64 ~riscv ~sparc x86 ~amd64-linux ~x86-linux"
IUSE="debug examples"

DEPEND=""
RDEPEND="${DEPEND}"
S="${WORKDIR}/oneTBB-${PV}"

DOCS=( README.md )

src_prepare() {
	default
	find include -name \*.html -delete || die
	cmake_src_prepare
}
