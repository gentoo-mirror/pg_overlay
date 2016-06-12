# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools eutils flag-o-matic git-r3

DESCRIPTION="BitTorrent Client using libtorrent"
HOMEPAGE="https://rakshasa.github.io/rtorrent/"
EGIT_REPO_URI="git://github.com/rakshasa/${PN}.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="+daemon debug ipv6 selinux test xmlrpc"

COMMON_DEPEND="=net-libs/libtorrent-9999
	>=dev-libs/libsigc++-2.2.2:2
	>=net-misc/curl-7.19.1
	sys-libs/ncurses:0=
	xmlrpc? ( dev-libs/xmlrpc-c )"
RDEPEND="${COMMON_DEPEND}
	daemon? ( app-misc/screen )
	selinux? ( sec-policy/selinux-rtorrent )
"
DEPEND="${COMMON_DEPEND}
	dev-util/cppunit
	virtual/pkgconfig"

DOCS=( doc/rtorrent.rc )

src_prepare() {
	eautoreconf
}

src_configure() {
	append-cflags -fno-strict-aliasing
	append-cxxflags -fno-strict-aliasing

	# configure needs bash or script bombs out on some null shift, bug #291229
	CONFIG_SHELL=${BASH} econf \
		--disable-dependency-tracking \
		$(use_enable debug) \
		$(use_enable ipv6) \
		$(use_with xmlrpc xmlrpc-c) --enable-largefile --with-ncurces --with-ncurcesw
}

src_install() {
	default

	if use daemon; then
		newinitd "${FILESDIR}/rtorrentd.init" rtorrentd
		newconfd "${FILESDIR}/rtorrentd.conf" rtorrentd
	fi
}
