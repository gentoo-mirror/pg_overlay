# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-multilib git-r3

MY_P=${P}-Source
DESCRIPTION="The SoX Resampler library"
HOMEPAGE="https://sourceforge.net/p/soxr/wiki/Home/"
EGIT_REPO_URI=( {git,https}://git.code.sf.net/p/soxr/code )

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE="examples"

DEPEND=""
RDEPEND="${DEPEND}"

DOCS=( "README" "TODO" "NEWS" "AUTHORS" )
PATCHES=( "${FILESDIR}/nodoc.patch" )

src_install() {
	cmake-multilib_src_install
	if use examples ; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
}
