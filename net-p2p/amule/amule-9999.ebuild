# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PLOCALES="ar ast bg ca cs da de el en_GB es et_EE eu fi fr gl he hr hu it it_CH ja ko_KR lt nl nn pl pt_BR pt_PT ro ru sl sq sv tr uk zh_CN zh_TW"

WX_GTK_VER="3.0"

inherit git-r3 l10n wxwidgets

DESCRIPTION="aMule, the all-platform eMule p2p client"
HOMEPAGE="http://www.amule.org/"
EGIT_REPO_URI="git://repo.or.cz/${PN}.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="+daemon debug geoip gtk3 +nls remote stats +unicode -upnp +X +mmap +boost"
REQUIRED_USE="gtk3? ( X )"

COMMON_DEPEND="
	dev-libs/crypto++
	sys-libs/binutils-libs:0=
	sys-libs/zlib
	stats? ( media-libs/gd:=[jpeg,png] )
	geoip? ( dev-libs/geoip )
	gtk3? ( x11-libs/wxGTK:${WX_GTK_VER}-gtk3[X?] )
	!gtk3? ( x11-libs/wxGTK:${WX_GTK_VER}[X?] )
	upnp? ( net-libs/libupnp:* )
	remote? ( media-libs/libpng:0=
	unicode? ( media-libs/gd:= ) )
	boost? ( dev-libs/boost:= )
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

src_prepare() {
	rem_locale() {
		rm "po/${1}.po" || die "removing of ${1}.po failed"
	}
	l10n_find_plocales_changes po "" ".po"
	l10n_for_each_disabled_locale_do rem_locale
	
	eapply "${FILESDIR}/switch_tabs_on_search_tabs.patch"
	for i in $(cat "${FILESDIR}/debian-patchset/series");do eapply "${FILESDIR}/debian-patchset/$i";done
	default
}

src_configure() {
	local myconf

	if use gtk3 ; then
		WX_GTK_VER="${WX_GTK_VER}-gtk3"
		myconf="${myconf}
			--with-toolkit=gtk3"
	fi

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
