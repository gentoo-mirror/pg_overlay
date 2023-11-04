# Copyright 2006-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic tmpfiles xdg-utils

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/${PN}/${PN}.git"
else
	SRC_URI="https://github.com/${PN}/${PN}-releases/raw/master/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm ~arm64 ~mips ~ppc ~ppc64 ~x86 ~amd64-linux"
fi

DESCRIPTION="A fast, easy, and free BitTorrent client"
HOMEPAGE="https://transmissionbt.com/"

# web/LICENSE is always GPL-2 whereas COPYING allows either GPL-2 or GPL-3 for the rest
# transmission in licenses/ is for mentioning OpenSSL linking exception
# MIT is in several libtransmission/ headers
LICENSE="|| ( GPL-2 GPL-3 Transmission-OpenSSL-exception ) GPL-2 MIT"
SLOT="0"
IUSE="appindicator cli debug gtk nls mbedtls qt5 qt6 test"
REQUIRED_USE="?? ( qt5 qt6 )"
RESTRICT="!test? ( test )"

ACCT_DEPEND="
	acct-group/transmission
	acct-user/transmission
"
BDEPEND="
	virtual/pkgconfig
	nls? (
		gtk? ( sys-devel/gettext )
	)
	qt5? ( dev-qt/linguist-tools:5 )
	qt6? ( dev-qt/qttools:6[linguist] )
"
COMMON_DEPEND="
	>=dev-libs/libevent-2.1.0:=[threads(+)]
	!mbedtls? ( dev-libs/openssl:0= )
	mbedtls? ( net-libs/mbedtls:0= )
	>=net-libs/libpsl-0.21.1
	>=net-misc/curl-7.28.0[ssl]
	sys-libs/zlib:=
	nls? ( virtual/libintl )
	gtk? (
		>=dev-cpp/gtkmm-3.24.0:4.0
		>=dev-cpp/glibmm-2.60.0:2.68
		appindicator? ( dev-libs/libayatana-appindicator )
	)
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtdbus:5
		dev-qt/qtgui:5
		dev-qt/qtnetwork:5
		dev-qt/qtsvg:5
		dev-qt/qtwidgets:5
	)
	qt6? (
		dev-qt/qtbase:6[dbus,gui,network,widgets]
		dev-qt/qtsvg:6
	)
"
DEPEND="${COMMON_DEPEND}
	nls? ( virtual/libintl )
"
RDEPEND="${COMMON_DEPEND}
	${ACCT_DEPEND}
"

src_prepare() {
	default
	sed -i 's/3.00+/3.00/g' CMakeLists.txt
	sed -i 's/TR300Z/TR3000/g' CMakeLists.txt
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_DOCDIR=share/doc/${PF}

		-DENABLE_CLI=$(usex cli ON OFF)
		-DENABLE_GTK=$(usex gtk ON OFF)
		-DENABLE_MAC=OFF
		-DENABLE_NLS=$(usex nls ON OFF)
		-DENABLE_TESTS=$(usex test ON OFF)
		-DENABLE_UTP=ON
		-DREBUILD_WEB=OFF

		-DINSTALL_LIB=OFF
		-DRUN_CLANG_TIDY=OFF

		-DUSE_SYSTEM_EVENT2=ON
		-DUSE_SYSTEM_DEFLATE=OFF
		-DUSE_SYSTEM_DHT=OFF
		-DUSE_SYSTEM_MINIUPNPC=OFF
		-DUSE_SYSTEM_NATPMP=OFF
		-DUSE_SYSTEM_UTP=OFF
		-DUSE_SYSTEM_B64=OFF
		-DUSE_SYSTEM_PSL=ON

		-DWITH_CRYPTO=$(usex mbedtls mbedtls openssl)
		-DWITH_INOTIFY=ON
		-DWITH_APPINDICATOR=$(usex appindicator ON OFF)
		-DWITH_SYSTEMD=OFF
		-DCMAKE_BUILD_TYPE=Release
	)

	if use qt6; then
		mycmakeargs+=( -DENABLE_QT=ON -DUSE_QT_VERSION=6 )
	elif use qt5; then
		mycmakeargs+=( -DENABLE_QT=ON -DUSE_QT_VERSION=5 )
	else
		mycmakeargs+=( -DENABLE_QT=OFF )
	fi

	# Disable assertions by default, bug 893870.
	use debug || append-cppflags -DNDEBUG

	cmake_src_configure
}

src_install() {
	cmake_src_install

	newinitd "${FILESDIR}"/transmission-daemon.initd.10 transmission-daemon
	newconfd "${FILESDIR}"/transmission-daemon.confd.4 transmission-daemon
}

pkg_postrm() {
	if use gtk || use qt5 || use qt6; then
		xdg_desktop_database_update
		xdg_icon_cache_update
	fi
}

pkg_postinst() {
	if use gtk || use qt5 || use qt6; then
		xdg_desktop_database_update
		xdg_icon_cache_update
	fi
}
