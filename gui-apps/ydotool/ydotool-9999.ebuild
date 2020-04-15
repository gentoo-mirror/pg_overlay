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

RDEPEND="dev-libs/boost
		dev-libs/libevdevplus
		dev-libs/libuinputplus"
DEPEND="${RDEPEND}"

src_prepare() {
	cmake_src_prepare
}

src_configure() {
	local -a mycmakeargs
	mycmakeargs=(
		-DCMAKE_BUILD_TYPE=Release \
		-DSTATIC_BUILD=0
	)

	cmake_src_configure
}
