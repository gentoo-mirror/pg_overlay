# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit autotools autotools-utils eutils

DESCRIPTION="Provides context menu for Nemo"
HOMEPAGE="https://github.com/linuxmint/nemo-extensions/tree/master/nemo-fileroller"
SRC_URI="http://packages.linuxmint.com/pool/main/n/${PN}/${PN}_${PV}+rosa.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~x86"

RDEPEND="
	app-arch/file-roller
	>=gnome-extra/nemo-2.8
"
DEPEND=">=gnome-extra/nemo-2.8
	>=dev-libs/glib-2.36:2
	sys-devel/gettext
	>=app-arch/libarchive-3:=
	>=dev-libs/json-glib-0.14
	dev-util/itstool
	virtual/pkgconfig
	>=x11-libs/gtk+-3.13.2:3
"
S=${S}+rosa

src_prepare() {
	eautoreconf
}

src_configure() {
	econf \
		--disable-silent-rules \
		--enable-shared \
		--disable-static \
		--disable-debug
}

src_compile() {
	emake
}

src_install() {
	emake DESTDIR="${D}" install
	find "${D}" -name '*.la' -exec rm -f {} + || die "la file removal failed"
}
