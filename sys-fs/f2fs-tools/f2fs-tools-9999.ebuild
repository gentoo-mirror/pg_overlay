# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools eutils git-r3 multilib

DESCRIPTION="Tools for Flash-Friendly File System (F2FS)"
HOMEPAGE="http://sourceforge.net/projects/f2fs-tools/"
EGIT_REPO_URI="git://git.kernel.org/pub/scm/linux/kernel/git/jaegeuk/${PN}.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

src_prepare() {
	epatch "${FILESDIR}"\f2fs-tools-1.7.0-lisselinux.patch
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
