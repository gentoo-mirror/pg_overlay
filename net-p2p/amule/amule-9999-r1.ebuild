# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
WX_GTK_VER="3.2-gtk3"
PLOCALES="ar ast bg ca cs da de el en_GB es et_EE eu fi fr gl he hr hu it it_CH ja ko_KR lt nl nn pl pt_BR pt_PT ro ru sl sq sv tr uk zh_CN zh_TW"

inherit autotools eapi9-ver flag-o-matic wxwidgets xdg-utils plocale

if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://github.com/amule-project/amule"
	inherit git-r3
else
	MY_P="${PN/m/M}-${PV}"
	SRC_URI="https://download.sourceforge.net/${PN}/${MY_P}.tar.xz"
	S="${WORKDIR}/${MY_P}"
	KEYWORDS="~alpha ~amd64 ~arm ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"
fi

DESCRIPTION="aMule, the all-platform eMule p2p client"
HOMEPAGE="https://www.amule.org/"

LICENSE="GPL-2+"
SLOT="0"
IUSE="daemon debug geoip +gui nls webserver stats upnp"

RDEPEND="
	dev-libs/boost:=
	dev-libs/crypto++:=
	sys-libs/binutils-libs:0=
	sys-libs/readline:0=
	sys-libs/zlib
	x11-libs/wxGTK:${WX_GTK_VER}=
	daemon? ( acct-user/amule )
	geoip? ( dev-libs/geoip )
	gui? ( x11-libs/wxGTK:${WX_GTK_VER}=[gui] )
	nls? ( virtual/libintl )
	webserver? (
		acct-user/amule
		media-libs/libpng:0=
	)
	stats? ( media-libs/gd:=[jpeg,png] )
	upnp? ( net-libs/libupnp:0 )
"
DEPEND="${RDEPEND}
	gui? ( dev-util/desktop-file-utils )
"
BDEPEND="
	virtual/pkgconfig
	>=dev-build/boost-m4-0.4_p20221019
	nls? ( sys-devel/gettext )
"

PATCHES=(
	"${FILESDIR}/${PN}-2.3.2-disable-version-check.patch"
	"${FILESDIR}/${PN}-2.3.3-fix-exception.patch"
)

src_prepare() {
	default
	rm m4/boost.m4 || die

	rem_locale() {
		rm "po/${1}.po" || die "removing of ${1}.po failed"
	}
	plocale_find_changes po "" ".po"
	plocale_for_each_disabled_locale rem_locale

	if [[ ${PV} == 9999 ]]; then
		./autogen.sh || die
	else
		eautoreconf
	fi
}

src_configure() {
	setup-wxwidgets

	use debug || append-cppflags -DwxDEBUG_LEVEL=0
	append-cxxflags -std=gnu++14

	local myconf=(
		--with-denoise-level=0
		--with-wx-config="${WX_CONFIG}"
		--disable-amulecmd
		--with-boost
		$(use_enable debug)
		$(use_enable daemon amule-daemon)
		$(use_enable geoip)
		$(use_enable nls)
		$(use_enable webserver webserver)
		$(use_enable stats cas)
		$(use_enable stats alcc)
		$(use_enable upnp)
		--enable-mmap
	)

	if use gui; then
		myconf+=(
			$(use_enable gui amule-gui)
			$(use_enable stats alc)
			$(use_enable stats wxcas)
		)
	else
		myconf+=(
			--disable-monolithic
			--disable-amule-gui
			--disable-alc
			--disable-wxcas
		)
	fi

	econf "${myconf[@]}"
}

src_test() {
	emake check
}

src_install() {
	default

	if use daemon; then
		newconfd "${FILESDIR}"/amuled.confd-r1 amuled
		newinitd "${FILESDIR}"/amuled.initd amuled
	fi
	if use webserver; then
		newconfd "${FILESDIR}"/amuleweb.confd-r1 amuleweb
		newinitd "${FILESDIR}"/amuleweb.initd amuleweb
	fi

	if use daemon || use webserver; then
		keepdir /var/lib/${PN}
		fowners amule:amule /var/lib/${PN}
		fperms 0750 /var/lib/${PN}
	fi

	if use gui && use !daemon; then
		rm ${D}/usr/bin/amule
	fi
}

pkg_postinst() {
	if use daemon || use webserver && ver_replacing -lt "2.3.2-r4"; then
		elog "Default user under which amuled and amuleweb daemons are started"
		elog "have been changed from p2p to amule. Default home directory have been"
		elog "changed as well."
		echo
		elog "If you want to preserve old download/share location, you can create"
		elog "symlink /var/lib/amule/.aMule pointing to the old location and adjust"
		elog "files ownership *or* restore AMULEUSER and AMULEHOME variables in"
		elog "/etc/conf.d/{amuled,amuleweb} to the old values."
	fi

	use gui && xdg_desktop_database_update
}

pkg_postrm() {
	use gui && xdg_desktop_database_update
}
