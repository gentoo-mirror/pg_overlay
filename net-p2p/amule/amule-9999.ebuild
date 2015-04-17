# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/amule/amule-9999.ebuild,v 0.1 2011/05/20 15:33:01 drzraf Exp $

EAPI="4"

EGIT_REPO_URI="git://repo.or.cz/amule.git"
EGIT_BRANCH="master"

inherit eutils flag-o-matic wxwidgets git-2

DESCRIPTION="aMule, the all-platform eMule p2p client"
HOMEPAGE="http://www.amule.org"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="daemon -debug fileview geoip +gtk +mmap nls plasma remote stats unicode +upnp -xchat"

DEPEND=">=x11-libs/wxGTK-2.8.12
	>=dev-libs/crypto++-5
	>=sys-libs/zlib-1.2.1
	stats? ( >=media-libs/gd-2.0.26[jpeg] )
	geoip? ( dev-libs/geoip )
	upnp? ( >=net-libs/libupnp-1.6.6 )
	remote? ( >=media-libs/libpng-1.2.0
	unicode? ( >=media-libs/gd-2.0.26 ) )"
RDEPEND="${DEPEND}"

REQUIRED_USE="|| ( gtk remote daemon )"

pkg_setup() {
	if use stats && ! use gtk; then
		einfo "Note: You would need both the gtk and stats USE flags"
		einfo "to compile aMule Statistics GUI."
		einfo "I will now compile console versions only."
	fi
}

pkg_preinst() {
	if use daemon || use remote; then
		enewgroup p2p
		enewuser p2p -1 -1 /home/p2p p2p
	fi
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-fallocate.diff
}

src_configure() {
	local myconf

	WX_GTK_VER="2.8"

	if use gtk; then
		einfo "wxGTK with gtk support will be used"
		need-wxwidgets unicode
	else
		einfo "wxGTK without X support will be used"
		need-wxwidgets base-unicode
	fi

	if use gtk ; then
		use stats && myconf="${myconf}
			--enable-wxcas
			--enable-alc"
		use remote && myconf="${myconf}
			--enable-amule-gui"
	else
		myconf="
			--disable-monolithic
			--disable-amule-gui
			--disable-wxcas
			--disable-alc"
	fi

	econf \
		--with-wx-config=${WX_CONFIG} \
		--enable-amulecmd \
		$(use_enable debug) \
		$(use_enable !debug optimize) \
		$(use_enable daemon amule-daemon) \
		$(use_enable geoip) \
		$(use_enable nls) \
		$(use_enable remote webserver) \
		$(use_enable stats cas) \
		$(use_enable stats alcc) \
		$(use_enable upnp upnp) \
		$(use_enable xchat xas) \
		$(use_enable fileview fileview) \
		$(use_enable plasma plasmamule) \
		$(use_enable mmap mmap) \
		${myconf}
}

src_install() {
	emake DESTDIR="${D}" install

	if use daemon; then
		newconfd "${FILESDIR}"/amuled.confd amuled
		newinitd "${FILESDIR}"/amuled.initd amuled
	fi
	if use remote; then
		newconfd "${FILESDIR}"/amuleweb.confd amuleweb
		newinitd "${FILESDIR}"/amuleweb.initd amuleweb
	fi
}
