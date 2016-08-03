# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-utils git-r3

DESCRIPTION="C++ library for reading and writing MP4 (iTunes), ID3, Vorbis, Opus, FLAC and Matroska tags"
HOMEPAGE="https://github.com/Martchus/tagparser"
EGIT_REPO_URI="git://github.com/Martchus/tagparser.git"

LICENSE="GPL-2+"
SLOT="5"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-util/cpp-utilities
	sys-libs/zlib	
"
DEPEND="${RDEPEND}"

src_prepare() {
	eapply "${FILSDIR}"/CMakeLists.patch
	default
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_BUILD_TYPE=Release
	)

	cmake-utils_src_configure
}
