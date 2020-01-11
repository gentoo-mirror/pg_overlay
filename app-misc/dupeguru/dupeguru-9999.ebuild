# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )
PYTHON_REQ_USE="sqlite"

inherit git-r3 python-single-r1

DESCRIPTION="dupeGuru is a cross-platform GUI tool to find duplicate files in a system"
HOMEPAGE="https://dupeguru.voltaicideas.net"
EGIT_REPO_URI="https://github.com/arsenetar/${PN}.git"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE=""

RDEPEND="${PYTHON_DEPS}
	dev-python/PyQt5[${PYTHON_USEDEP},gui,widgets]
	>=dev-qt/qtgui-5.10[jpeg,png,gif]
	>=dev-python/hsaudiotag3k-1.1.3[${PYTHON_USEDEP}]
	>=dev-python/send2trash-1.3.0[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/polib[${PYTHON_USEDEP}]"

PATCHES=(
    # Recent pip update in Gentoo requires us to use --user at all times, even in venvs :(
	"${FILESDIR}/fix-pip-call-in-makefile.patch"
)

src_compile() {
	emake PYTHON=${EPYTHON} all build
}

src_install() {
	emake DESTDIR="${D}" PREFIX="/usr" install
}
