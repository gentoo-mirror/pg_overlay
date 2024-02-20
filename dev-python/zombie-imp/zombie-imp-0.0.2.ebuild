# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} pypy3 )

inherit distutils-r1

DESCRIPTION="A copy of the imp module that was removed in Python 3.12."
HOMEPAGE="https://github.com/encukou/zombie-imp/"
SRC_URI="https://github.com/encukou/${PN}/archive/refs/tags/v${PV}.tar.gz"

LICENSE="SPDX"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-macos"

RDEPEND=""
BDEPEND=""
