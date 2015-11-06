# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils autotools gnome2-utils

DESCRIPTION="su GUI"
HOMEPAGE="http://keithhedger.hostingsiteforfree.com/pages/${PN}/${PN}.html"

SRC_URI="https://yadi.sk/d/BhrkTxp_kDwwx -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="qt5 ktsuss-link"

RDEPEND="
	qt5? ( dev-qt/qtwidgets:5 )
	!qt5? ( x11-libs/gtk+:3 )
	dev-libs/glib:2
	sys-devel/automake
	sys-devel/autoconf"

DEPEND="${RDEPEND}"

S="${WORKDIR}/GtkSu-${PV}"

src_configure() {
	touch NEWS README AUTHORS
	sed -i 's/sudo /true /g' GtkSu/MakeSuWrap/Makefile.am
	econf \
		$(use_enable qt5) \
		$(use_enable ktsuss-link)
	sed -i 's/makeXauthFile();$/true;/g;s/\(setenv("LANG".*$\)/\1\nsetenv("XAUTHORITY",userXAuth,1);/g' GtkSu/MakeSuWrap/suwrap.cpp
    eautoreconf
}

pkg_preinst() {
	ls -lR /var/tmp/portage/x11-misc/gtksu-0.1.5/image
	fperms 6755 /usr/bin/gtksuwrap
}
