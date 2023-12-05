# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..12} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 xdg-utils git-r3

DESCRIPTION="A fork of nicotine, a Soulseek client in Python"
HOMEPAGE="https://github.com/Nicotine-Plus/nicotine-plus"
EGIT_REPO_URI="https://github.com/nicotine-plus/nicotine-plus.git"

LICENSE="GPL-3 LGPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="${PYTHON_DEPS}"
RDEPEND="
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	gui-libs/gtk:4[introspection]
	${DEPEND}
"

DEPEND="${RDEPEND}"

#S="${WORKDIR}/nicotine-plus-${PV}"

EPYTEST_IGNORE=(
	"test/integration/test_startup.py"
)

distutils_enable_tests pytest

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
