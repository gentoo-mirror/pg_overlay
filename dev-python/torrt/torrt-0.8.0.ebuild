# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{7..9} pypy{,3} )

inherit distutils-r1


DESCRIPTION="Automates torrent updates for you"
HOMEPAGE="https://github.com/idlesign/torrt"
SRC_URI="https://github.com/idlesign/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

DEPEND=">=dev-python/torrentool-0.4.0[${PYTHON_USEDEP}]
		>=dev-python/beautifulsoup-4.5.1:4[${PYTHON_USEDEP}]
		>=dev-python/lxml-3.8.0[${PYTHON_USEDEP}]"
