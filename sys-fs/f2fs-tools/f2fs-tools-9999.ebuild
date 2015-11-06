# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit autotools git-r3

DESCRIPTION="Tools for Flash-Friendly File System (F2FS)"
HOMEPAGE="http://sourceforge.net/projects/f2fs-tools/"
SRC_URI=""

EGIT_REPO_URI="git://git.kernel.org/pub/scm/linux/kernel/git/jaegeuk/f2fs-tools.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_prepare() {
	echo 'mkfs_f2fs_LDFLAGS = ' >> mkfs/Makefile.am
	eautoreconf --prefix=/ --includedir=/usr/include --disable-static
}

src_configure(){
	econf --prefix=/ --includedir=/usr/include --disable-static
}

src_install() {
	default
	rm -f "${ED}"/$(get_libdir)/libf2fs.{,l}a
}
