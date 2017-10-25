# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6} pypy{,3} )

inherit distutils-r1


DESCRIPTION="Interfaces for Python"
HOMEPAGE="https://pypi.python.org/pypi/daemonize https://github.com/thesharp/daemonize"
SRC_URI="https://github.com/thesharp/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ZPL"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="test"

DEPEND=">=dev-python/setuptools-33.1.1[${PYTHON_USEDEP}]"


python_compile() {
	distutils-r1_python_compile
}

python_install_all() {
	distutils-r1_python_install_all

	find "${D}" -name '*.pth' -delete || die
}
