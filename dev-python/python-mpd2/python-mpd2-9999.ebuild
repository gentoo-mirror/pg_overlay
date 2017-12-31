# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{2_7,3_6} pypy )

inherit distutils-r1 git-r3

DESCRIPTION="Python MPD client library"
HOMEPAGE="https://github.com/Mic92/python-mpd2"
EGIT_REPO_URI="https://github.com/Mic92/${PN}.git"

LICENSE="LGPL-3"
KEYWORDS="amd64 ~ppc ~ppc64 x86"
SLOT="0"
IUSE="test"

DEPEND="test? ( dev-python/mock[${PYTHON_USEDEP}] )
	dev-python/setuptools[${PYTHON_USEDEP}]"

DOCS=( doc/changes.rst doc/topics/{advanced,commands,getting-started,logging}.rst README.rst )

python_test() {
	"${PYTHON}" test.py || die "Tests fail with ${EPYTHON}"
}
