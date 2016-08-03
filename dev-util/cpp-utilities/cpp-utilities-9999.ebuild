# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-utils git-r3

DESCRIPTION="Common C++ classes and routines used by my applications such as argument parser, IO and conversion utilities"
HOMEPAGE="https://github.com/Martchus/cpp-utilities"
EGIT_REPO_URI="git://github.com/Martchus/cpp-utilities.git"

LICENSE="GPL-2+"
SLOT="5"
KEYWORDS="~amd64 ~x86"
IUSE="+doxygen"

RDEPEND="
	doxygen? ( app-doc/doxygen )
	dev-util/cmake
	sys-devel/gcc
"
DEPEND="${RDEPEND}"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package doxygen DOXYGEN)
	)

	cmake-utils_src_configure
}
