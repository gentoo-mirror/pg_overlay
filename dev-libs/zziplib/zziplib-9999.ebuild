# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )

inherit cmake flag-o-matic python-any-r1 git-r3

DESCRIPTION="Lightweight library for extracting data from files archived in a single zip file"
HOMEPAGE="https://github.com/gdraheim/zziplib http://zziplib.sourceforge.net/"
EGIT_REPO_URI="https://github.com/gdraheim/${PN}.git"
EGIT_BRANCH="develop"

LICENSE="|| ( LGPL-2.1 MPL-1.1 )"
SLOT="0/13"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~mips ppc ppc64 s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="sdl static-libs"

# Tests require internet access
# https://github.com/gdraheim/zziplib/issues/24

BDEPEND="
	${PYTHON_DEPS}
"
DEPEND="
	sys-libs/zlib
	sdl? ( >=media-libs/libsdl-1.2.6 )
"
RDEPEND="${DEPEND}"

PATCHES=(
)

src_configure() {
	# https://github.com/gdraheim/zziplib/commit/f3bfc0dd6663b7df272cc0cf17f48838ad724a2f#diff-b7b1e314614cf326c6e2b6eba1540682R100
	append-flags -fno-strict-aliasing

	local mycmakeargs=(
		-DZZIPSDL="$(usex sdl)"
		-DBUILD_STATIC_LIBS="$(usex static-libs)"
		-DBUILD_TESTS=OFF
		-DZZIPTEST=OFF
		-DZZIPDOCS=ON
		-DZZIPWRAP=OFF
	)

	cmake_src_configure
}
