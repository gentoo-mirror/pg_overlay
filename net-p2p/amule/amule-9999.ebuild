# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
WX_GTK_VER="3.0-gtk3"

inherit wxwidgets user git-r3

DESCRIPTION="aMule, the all-platform eMule p2p client"
HOMEPAGE="http://www.amule.org/"
EGIT_REPO_URI=( {https,git}://repo.or.cz/${PN}.git )

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="+daemon -debug -geoip +nls remote -stats +unicode -upnp +X +mmap boost"

COMMON_DEPEND="
	dev-libs/crypto++
	sys-libs/binutils-libs:0=
	sys-libs/zlib
	x11-libs/wxGTK:${WX_GTK_VER}[X?]
	stats? ( media-libs/gd:=[jpeg,png] )
	geoip? ( dev-libs/geoip )
	upnp? ( net-libs/libupnp:* )
	remote? ( media-libs/libpng:0=
	unicode? ( media-libs/gd:= ) )
	boost? ( dev-libs/boost )
	!net-p2p/imule"
DEPEND="${COMMON_DEPEND}"
RDEPEND="${COMMON_DEPEND}"

pkg_setup() {
	if use stats && ! use X; then
		einfo "Note: You would need both the X and stats USE flags"
		einfo "to compile aMule Statistics GUI."
		einfo "I will now compile console versions only."
	fi
}

src_configure() {
	local myconf

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
		--with-denoise-level=0 \
		--with-wx-config="${WX_CONFIG}" \
		--enable-amulecmd \
		$(use_enable debug) \
		$(use_enable daemon amule-daemon) \
		$(use_enable geoip) \
		$(use_enable nls) \
		$(use_enable remote webserver) \
		$(use_enable stats cas) \
		$(use_enable stats alcc) \
		$(use_enable upnp) \
		$(use_enable mmap mmap) \
		$(use_with boost) \
		${myconf}
}

src_install() {
	default

	if use daemon; then
		newconfd "${FILESDIR}"/amuled.confd amuled
		newinitd "${FILESDIR}"/amuled.initd amuled
	fi
	if use remote; then
		newconfd "${FILESDIR}"/amuleweb.confd amuleweb
		newinitd "${FILESDIR}"/amuleweb.initd amuleweb
	fi
}
