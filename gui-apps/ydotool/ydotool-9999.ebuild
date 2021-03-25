# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake git-r3

DESCRIPTION="Generic command-line automation tool (no X!)"

HOMEPAGE="https://github.com/ReimuNotMoe/ydotool"
EGIT_REPO_URI="https://github.com/ReimuNotMoe/${PN}.git"
LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="dev-libs/boost"
DEPEND="${RDEPEND}
		app-text/scdoc"

src_configure() {
	local mycmakeargs=(
		-DSTATIC_BUILD=0
		-DCXXOPTS_ENABLE_INSTALL=OFF
	)
	cmake_src_configure
}
