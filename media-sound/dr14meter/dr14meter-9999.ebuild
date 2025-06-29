# Copyright 2017-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..13} )

inherit distutils-r1 git-r3

DESCRIPTION="dr14meter is a free and open-source command line tool for computing the Dynamic Range of your music."
HOMEPAGE="https://github.com/pe7ro/dr14meter/"
EGIT_REPO_URI="https://github.com/pe7ro/${PN}.git"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="dev-python/numpy[${PYTHON_USEDEP}]
		media-libs/flac
		media-libs/mutagen
		media-video/ffmpeg"

src_prepare() {
	cp ${FILESFIR}/setup.cfg ${S}/setup.cfg
	default
}

python_prepare_all() {
	distutils-r1_python_prepare_all
}

python_install_all() {
	distutils-r1_python_install_all
}
