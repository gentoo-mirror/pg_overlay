# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

AUTOTOOLS_IN_SOURCE_BUILD=1
AUTOTOOLS_AUTORECONF=1

inherit eutils autotools-utils flag-o-matic wxwidgets user git-r3

EGIT_REPO_URI="git://github.com/amule-project/amule.git"
EGIT_BRANCH="master"

DESCRIPTION="aMule, the all-platform eMule p2p client"
HOMEPAGE="http://www.amule.org/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ppc ppc64 ~sparc x86"
IUSE="+daemon -debug -geoip +nls remote -stats +unicode -upnp +X +mmap"

DEPEND=">=dev-libs/crypto++-5
	>=sys-libs/zlib-1.2.1
	dev-libs/boost
	dev-util/boost-build
	stats? ( >=media-libs/gd-2.0.26[jpeg] )
	geoip? ( dev-libs/geoip )
	upnp? ( >=net-libs/libupnp-1.6.6 )
	remote? ( >=media-libs/libpng-1.2.0
	unicode? ( >=media-libs/gd-2.0.26 ) )
	X? ( >=x11-libs/wxGTK-3.0:3.0[X] )
	!X? ( >=x11-libs/wxGTK-3.0:3.0 )"
RDEPEND="${DEPEND}"

pkg_setup() {
	if use stats && ! use X; then
		einfo "Note: You would need both the X and stats USE flags"
		einfo "to compile aMule Statistics GUI."
		einfo "I will now compile console versions only."
	fi
}

src_prepare() {
	sed -i \
	-e 's/AM_INIT_AUTOMAKE/\0([subdir-objects])/'  \
	configure.in || die
	mv configure.in configure.ac || die

	# Ugly pixmaps hack
	OLDPWD="`pwd`"
	cd src/pixmaps/flags_xpm
	./makeflags.sh
	cd "$OLDPWD"

	autotools-utils_src_prepare
}

src_configure() {
	local myconf

	WX_GTK_VER="3.0"

	if use X; then
		einfo "wxGTK with X support will be used"
		need-wxwidgets unicode
	else
		einfo "wxGTK without X support will be used"
		need-wxwidgets base-unicode
	fi

	if use X ; then
		use stats && myconf="${myconf}
			--enable-wxcas
			--enable-alc"
		myconf="${myconf}
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
		--disable-amulecmd \
		--with-boost \
		$(use_enable debug) \
		$(use_enable !debug optimize) \
		$(use_enable daemon amule-daemon) \
		$(use_enable geoip) \
		$(use_enable nls) \
		$(use_enable remote webserver) \
		$(use_enable stats cas) \
		$(use_enable stats alcc) \
		$(use_enable upnp) \
		$(use_enable mmap mmap) \
		${myconf} || die
}

src_install() {
	emake DESTDIR="${D}" install || die

	if use daemon; then
		newconfd "${FILESDIR}"/amuled.confd amuled
		newinitd "${FILESDIR}"/amuled.initd amuled
	fi
	if use remote; then
		newconfd "${FILESDIR}"/amuleweb.confd amuleweb
		newinitd "${FILESDIR}"/amuleweb.initd amuleweb
	fi
}
