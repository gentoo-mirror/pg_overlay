# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PLOCALES="ar ast bg ca cs da de el en_GB es et_EE eu fi fr gl he hr hu it it_CH ja ko_KR lt nl nn pl pt_BR pt_PT ro ru sl sq sv tr uk zh_CN zh_TW"
WX_GTK_VER="3.0-gtk3"

inherit git-r3 l10n wxwidgets

DESCRIPTION="aMule, the all-platform eMule p2p client"
HOMEPAGE="http://www.amule.org/"
EGIT_REPO_URI="git://repo.or.cz/${PN}.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="daemon debug geoip gui +nls stats upnp X +mmap webserver"

COMMON_DEPEND="
	dev-libs/boost:=
	dev-libs/crypto++:=
	sys-libs/binutils-libs:0=
	sys-libs/zlib
	>=x11-libs/wxGTK-3.0.4:${WX_GTK_VER}[X?]
	stats? ( media-libs/gd:=[jpeg,png] )
	geoip? ( dev-libs/geoip )
	upnp? ( net-libs/libupnp:* )
	webserver? ( media-libs/libpng:0= )
	!net-p2p/imule"
DEPEND="${COMMON_DEPEND}"
RDEPEND="${COMMON_DEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-2.3.2-fix-crash-shared-dir-utf8.patch"
	"${FILESDIR}/${PN}-2.3.2-fix-crash-when-shared-files-changed.patch"
)

pkg_setup() {
	if use stats && ! use X; then
		einfo "Note: You would need both the X and stats USE flags"
		einfo "to compile aMule Statistics GUI."
		einfo "I will now compile console versions only."
	fi

	setup-wxwidgets
}

src_prepare() {
	default
	rem_locale() {
		rm "po/${1}.po" || die "removing of ${1}.po failed"
	}
	l10n_find_plocales_changes po "" ".po"
	l10n_for_each_disabled_locale_do rem_locale
	
	for i in $(cat "${FILESDIR}/debian-patchset/series");do eapply "${FILESDIR}/debian-patchset/$i";done
}

src_configure() {
	local myconf

	if use X ; then
		myconf="
			$(use_enable gui amule-gui)
			$(use_enable stats alc)
			$(use_enable stats wxcas)
			--disable-monolithic"
	else
		myconf="
			--disable-monolithic
			--disable-amule-gui
			--disable-alc
			--disable-wxcas"
	fi

	econf \
		--with-denoise-level=0 \
		--with-wx-config="${WX_CONFIG}" \
		--enable-amulecmd \
		--with-boost \
		$(use_enable debug) \
		$(use_enable daemon amule-daemon) \
		$(use_enable geoip) \
		$(use_enable nls) \
		$(use_enable webserver) \
		$(use_enable stats cas) \
		$(use_enable stats alcc) \
		$(use_enable upnp) \
		$(use_enable mmap mmap) \
		${myconf}
}

src_install() {
	default

	if use daemon; then
		newconfd "${FILESDIR}"/amuled.confd amuled
		newinitd "${FILESDIR}"/amuled.initd amuled
	fi
	if use webserver; then
		newconfd "${FILESDIR}"/amuleweb.confd amuleweb
		newinitd "${FILESDIR}"/amuleweb.initd amuleweb
	fi
    if use gui; then
        rm ${D}/usr/bin/amule
    fi
}
