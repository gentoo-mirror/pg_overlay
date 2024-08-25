# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PLOCALES="ar ast bg ca cs da de el en_GB es et_EE eu fi fr gl he hr hu it it_CH ja ko_KR lt nl nn pl pt_BR pt_PT ro ru sl sq sv tr uk zh_CN zh_TW"
WX_GTK_VER="3.2-gtk3"

inherit cmake git-r3 plocale wxwidgets xdg

DESCRIPTION="aMule, the all-platform eMule p2p client"
HOMEPAGE="https://www.amule.org/"
EGIT_REPO_URI="https://github.com/${PN}-project/${PN}.git"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS=""
IUSE="daemon debug geoip gui +nls stats upnp X webserver"

RDEPEND="
	dev-libs/boost:=
	dev-libs/crypto++:=
	sys-libs/binutils-libs:=
	sys-libs/readline:0=
	sys-libs/zlib
	>=x11-libs/wxGTK-3.0.4:${WX_GTK_VER}[gui?]
	daemon? ( acct-user/amule )
	geoip? ( dev-libs/geoip )
	nls? ( virtual/libintl )
	webserver? (
		acct-user/amule
		media-libs/libpng:0=
	)
	stats? ( media-libs/gd:=[jpeg,png] )
	upnp? ( net-libs/libupnp:0 )
"
DEPEND="${RDEPEND}
	X? ( dev-util/desktop-file-utils )
"
BDEPEND="
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
"

PATCHES=(
	"${FILESDIR}/${PN}-2.3.2-disable-version-check.patch"
)

pkg_setup() {
	setup-wxwidgets
}

src_prepare() {
	rem_locale() {
		rm "po/${1}.po" || die "removing of ${1}.po failed"
	}
	plocale_find_changes po "" ".po"
	plocale_for_each_disabled_locale rem_locale
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_BUILD_TYPE=Release
		-DwxWidgets_CONFIG_EXECUTABLE="${WX_CONFIG}"
		-DASIO_SOCKETS=ON
		-DBUILD_ALCC=OFF
		-DBUILD_AMULECMD=OFF
		-DBUILD_CAS=OFF
		-DENABLE_BOOST=ON
		-DENABLE_MMAP=ON
		-DBUILD_DAEMON=$(usex daemon)
		-DBUILD_TESTING=$(usex debug)
		-DBUILD_WEBSERVER=$(usex webserver)
		-DENABLE_NLS=$(usex nls)
		-DENABLE_UPNP=$(usex upnp)

	)

	if use gui; then
		mycmakeargs+=(
			-DBUILD_MONOLITHIC=OFF
			-DBUILD_REMOTEGUI=ON
			-DBUILD_ALC=$(usex stats)
			-DBUILD_WXCAS=$(usex stats)
		)
	else
		mycmakeargs+=(
			-DBUILD_MONOLITHIC=OFF
			-DBUILD_REMOTEGUI=OFF
			-DBUILD_ALC=OFF
			-DBUILD_WXCAS=OFF
		)
	fi

	cmake_src_configure
}

src_install() {
	default
	cmake_src_install

	if use daemon; then
		newconfd "${FILESDIR}"/amuled.confd-r1 amuled
		newinitd "${FILESDIR}"/amuled.initd amuled
	fi
	if use webserver; then
		newconfd "${FILESDIR}"/amuleweb.confd-r1 amuleweb
		newinitd "${FILESDIR}"/amuleweb.initd amuleweb
	fi

	if use gui; then
		rm ${D}/usr/bin/amule
	fi
}

pkg_postinst() {
	local ver

	if use daemon || use webserver; then
		for ver in ${REPLACING_VERSIONS}; do
			if ver_test ${ver} -lt "2.3.2-r4"; then
				elog "Default user under which amuled and amuleweb daemons are started"
				elog "have been changed from p2p to amule. Default home directory have been"
				elog "changed as well."
				echo
				elog "If you want to preserve old download/share location, you can create"
				elog "symlink /var/lib/amule/.aMule pointing to the old location and adjust"
				elog "files ownership *or* restore AMULEUSER and AMULEHOME variables in"
				elog "/etc/conf.d/{amuled,amuleweb} to the old values."

				break
			fi
		done
	fi

	use gui && xdg_desktop_database_update
}

pkg_postrm() {
	use gui && xdg_desktop_database_update
}
