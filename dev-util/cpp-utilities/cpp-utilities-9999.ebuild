# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-utils git-r3

DESCRIPTION="A simple tag editor for KDE"
HOMEPAGE="https://github.com/Martchus/cpp-utilities"
EGIT_REPO_URI="git://github.com/Martchus/cpp-utilities.git"

LICENSE="GPL-2+"
SLOT="5"
KEYWORDS="~amd64 ~x86"
IUSE=""

REQUIRED_USE="flac? ( vorbis )"

RDEPEND="
	dev-util/cmake
	sys-devel/gcc
"
DEPEND="${RDEPEND}"
