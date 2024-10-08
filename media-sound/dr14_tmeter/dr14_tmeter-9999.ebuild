# Copyright 2017-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..13} )

DISTUTILS_USE_SETUPTOOLS=no

inherit distutils-r1 git-r3

DESCRIPTION="Compute the DR14 value of the given audio files"
HOMEPAGE="http://dr14tmeter.sourceforge.net/"
EGIT_REPO_URI="https://github.com/simon-r/dr14_t.meter.git"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="dev-python/numpy[${PYTHON_USEDEP}]
		media-libs/flac
		media-libs/mutagen
		media-video/ffmpeg[encode]"

src_prepare() {
	default

	sed -i '/cmdclass/d' setup.py
}


python_install_all() {
	distutils-r1_python_install_all

	doman man/dr14_tmeter.1
}
