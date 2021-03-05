# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools git-r3 linux-info

DESCRIPTION="BitTorrent Client using libtorrent"
HOMEPAGE="https://rakshasa.github.io/rtorrent/"
EGIT_REPO_URI="https://github.com/rakshasa/${PN}.git"
EGIT_BRANCH="feature/bind-merge"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="daemon debug selinux test xmlrpc ipv6"
RESTRICT="!test? ( test )"

COMMON_DEPEND="=net-libs/libtorrent-9999
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

pkg_setup() {
	if ! linux_config_exists || ! linux_chkconfig_present IPV6; then
		ewarn "rtorrent will not start without IPv6 support in your kernel"
		ewarn "without further configuration. Please set bind=0.0.0.0 or"
		ewarn "similar in your rtorrent.rc"
		ewarn "Upstream bug: https://github.com/rakshasa/rtorrent/issues/732"
	fi
}

src_prepare() {
	default

	# https://github.com/rakshasa/rtorrent/issues/332
	cp "${FILESDIR}"/rtorrent.1 "${S}"/doc/ || die

	eautoreconf
}

src_configure() {
	default

	# configure needs bash or script bombs out on some null shift, bug #291229
	local myeconfargs=(
		--disable-dependency-tracking \
		--disable-static \
		$(use_enable debug) \
		$(use_enable ipv6) \
		$(use_with xmlrpc xmlrpc-c)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default
	doman doc/rtorrent.1

	if use daemon; then
		newinitd "${FILESDIR}/rtorrentd.init" rtorrentd
		newconfd "${FILESDIR}/rtorrentd.conf" rtorrentd
	fi
}
