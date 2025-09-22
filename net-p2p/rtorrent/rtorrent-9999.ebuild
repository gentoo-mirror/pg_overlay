# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# require 64-bit integer
LUA_COMPAT=( lua5-{3,4} )

inherit autotools git-r3 linux-info lua-single

DESCRIPTION="BitTorrent Client using libtorrent"
HOMEPAGE="https://rakshasa.github.io/rtorrent/"
EGIT_REPO_URI="https://github.com/rakshasa/${PN}.git"
EGIT_BRANCH="master"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="debug lua selinux test tinyxml2 xmlrpc"
RESTRICT="!test? ( test )"
REQUIRED_USE="
	lua? ( ${LUA_REQUIRED_USE} )
	tinyxml2? ( !xmlrpc )
"

COMMON_DEPEND="
	~net-libs/libtorrent-${PV}
	sys-libs/ncurses:0=
	lua? ( ${LUA_DEPS} )
	tinyxml2? ( dev-libs/tinyxml2:= )
	xmlrpc? ( dev-libs/xmlrpc-c:= )
"
DEPEND="${COMMON_DEPEND}
	dev-cpp/nlohmann_json
"
RDEPEND="${COMMON_DEPEND}
	selinux? ( sec-policy/selinux-rtorrent )
"
BDEPEND="
	virtual/pkgconfig
	test? ( dev-util/cppunit )
"

DOCS=( doc/rtorrent.rc )

PATCHES=(
	"${FILESDIR}"/${PN}-0.15.3-unbundle_json.patch
	"${FILESDIR}"/${PN}-0.15.3-unbundle_tinyxml2.patch
)

pkg_setup() {
	if ! linux_config_exists || ! linux_chkconfig_present IPV6; then
		ewarn "rtorrent will not start without IPv6 support in your kernel"
		ewarn "without further configuration. Please set bind=0.0.0.0 or"
		ewarn "similar in your rtorrent.rc"
		ewarn "Upstream bug: https://github.com/rakshasa/rtorrent/issues/732"
	fi
	use lua && lua-single_pkg_setup
}

src_prepare() {
	default

	# use system-json
	rm -r src/rpc/nlohmann || die
	sed -e 's@"rpc/nlohmann/json.h"@<nlohmann/json.hpp>@' \
		-i src/rpc/jsonrpc.cc || die

	# use system-tinyxml2
	rm -r src/rpc/tinyxml2 || die
	sed -i "/rpc\\/tinyxml2/d" src/Makefile.am

	# https://github.com/rakshasa/rtorrent/issues/332
	cp "${FILESDIR}"/rtorrent.1 "${S}"/doc/ || die

	if [[ ${CHOST} != *-darwin* ]]; then
		# syslibroot is only for macos, change to sysroot for others
		sed -i 's/Wl,-syslibroot,/Wl,--sysroot,/' "${S}/scripts/common.m4" || die
	fi

	eautoreconf
}

src_configure() {
	# configure needs bash or script bombs out on some null shift, bug #291229
	export CONFIG_SHELL=${BASH}

	local myeconfargs=(
		LIBS="-ltinyxml2"
		$(use_enable debug)
		$(use_with lua)
		$(usev xmlrpc --with-xmlrpc-c)
		$(usev tinyxml2 --with-xmlrpc-tinyxml2)
	)

	use lua && myeconfargs+=(
		LUA_INCLUDE="-I$(lua_get_include_dir)"
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default
	doman doc/rtorrent.1

	if use lua; then
		insinto $(lua_get_lmod_dir)
		doins ${PN}.lua
	fi

	newinitd "${FILESDIR}/rtorrent-r1.init" rtorrent
	newconfd "${FILESDIR}/rtorrentd.conf" rtorrent
}
