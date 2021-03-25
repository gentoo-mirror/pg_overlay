# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake git-r3

DESCRIPTION="Generic command-line automation tool (no X!)"

HOMEPAGE="https://github.com/ReimuNotMoe/ydotool"
EGIT_REPO_URI="https://github.com/ReimuNotMoe/${PN}.git"
SRC_URI="https://github.com/YukiWorkshop/IODash/archive/refs/tags/v0.1.7.tar.gz
	https://github.com/YukiWorkshop/libuInputPlus/archive/refs/tags/v0.2.1.tar.gz
	https://github.com/YukiWorkshop/libevdevPlus/archive/refs/tags/v0.2.1.tar.gz
	https://github.com/jarro2783/cxxopts/archive/refs/heads/master.zip -> cxxopts-master.zip
	"
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
