# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools eutils git-r3

DESCRIPTION="Audacious Player - Your music, your way, no exceptions"
HOMEPAGE="http://audacious-media-player.org/"
EGIT_REPO_URI="git://github.com/${PN}-media-player/${PN}.git"
SRC_URI="mirror://gentoo/gentoo_ice-xmms-0.2.tar.bz2"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS=""

IUSE="+chardet nls qt5"
REQUIRED_USE="
	^^ ( qt5 )
"
DOCS="AUTHORS"

RDEPEND=">=app-i18n/libguess-1.2
	>=dev-libs/dbus-glib-0.60
	>=dev-libs/glib-2.28
	>=x11-libs/cairo-1.2.6
	>=x11-libs/pango-1.8.0
	virtual/freedesktop-icon-theme
	qt5? ( dev-qt/qtcore:5
	      dev-qt/qtgui:5
	      dev-qt/qtwidgets:5 )"

DEPEND="${RDEPEND}
	virtual/pkgconfig
	nls? ( dev-util/intltool )"

PDEPEND="~media-plugins/audacious-plugins-${PV}"

src_prepare() {
	if [ "${A}" = "gentoo_ice-xmms-0.2.tar.bz2" ]; then
		unpack ${A}
	fi
	eautoreconf
}

src_configure() {
	# D-Bus is a mandatory dependency, remote control,
	# session management and some plugins depend on this.
	# Building without D-Bus is *unsupported* and a USE-flag
	# will not be added due to the bug reports that will result.
	# Bugs #197894, #199069, #207330, #208606
	econf \
		--enable-dbus \
		$(use_enable nls) \
		$(use_enable qt5 qt) --disable-gtk
}

src_install() {
	default

	# Gentoo_ice skin installation; bug #109772
	insinto /usr/share/audacious/Skins/gentoo_ice
	doins "${S}"/gentoo_ice/*
	docinto gentoo_ice
	dodoc "${S}"/README
}
