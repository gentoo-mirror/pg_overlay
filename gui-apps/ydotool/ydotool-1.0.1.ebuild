# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Generic command-line automation tool (no X!)"

HOMEPAGE="https://github.com/ReimuNotMoe/ydotool"
SRC_URI="https://github.com/ReimuNotMoe/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
	app-text/scdoc"

src_compile() {
	cmake_src_compile ydotool ydotoold
}

src_install() {
	cmake_src_install ydotool ydotoold
}
