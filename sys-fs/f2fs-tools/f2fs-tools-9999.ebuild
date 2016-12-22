# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"

inherit autotools git-r3 multilib

DESCRIPTION="Tools for Flash-Friendly File System (F2FS)"
HOMEPAGE="https://git.kernel.org/?p=linux/kernel/git/jaegeuk/f2fs-tools.git;a=summary"
EGIT_REPO_URI="git://git.kernel.org/pub/scm/linux/kernel/git/jaegeuk/${PN}.git"

LICENSE="GPL-2"
SLOT="0/1"
KEYWORDS=""
IUSE=""

DEPEND="
	sys-apps/util-linux
	sys-libs/libselinux"

src_prepare() {
	eautoreconf
}

src_configure() {
	#This is required to install to /sbin, bug #481110
	econf --prefix=/ --includedir=/usr/include
}

src_install() {
	default
	rm -f "${ED}"/$(get_libdir)/libf2fs.{,l}a
	rm -f "${ED}"/$(get_libdir)/libf2fs_format.{,l}a
}
