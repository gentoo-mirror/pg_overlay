# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils autotools git-r3

DESCRIPTION="A drop down terminal, similar to the consoles found in first person shooters"
HOMEPAGE="https://github.com/lanoxx/tilda"
EGIT_REPO_URI="https://github.com/lanoxx/${PN}.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="x11-libs/vte:2.91
	>=dev-libs/glib-2.8.4:2
	dev-libs/confuse
	>=x11-libs/gtk+-3.0"
	
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	eautoreconf
}

src_configure() {
	econf \
	--enable-vte-2.91
}

src_install() {
	emake DESTDIR="${D}" install || die
}
