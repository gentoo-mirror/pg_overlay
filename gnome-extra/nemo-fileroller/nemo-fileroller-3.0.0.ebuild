# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"

inherit autotools eutils gnome2 gnome2-utils

DESCRIPTION="Provides context menu for Nemo"
HOMEPAGE="https://github.com/linuxmint/nemo-extensions/tree/master/nemo-fileroller"
SRC_URI="https://github.com/linuxmint/nemo-extensions/archive/${PV}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~x86"

RDEPEND="
	app-arch/file-roller
	>=gnome-extra/nemo-3.0
"
DEPEND=">=gnome-extra/nemo-3.0
	>=dev-libs/glib-2.36:2
	sys-devel/gettext
	>=app-arch/libarchive-3:=
	>=dev-libs/json-glib-0.14
	dev-util/itstool
	virtual/pkgconfig
	>=x11-libs/gtk+-3.13.2:3
"
S=${WORKDIR}/nemo-extensions-${PV}/${PN}

src_prepare() {
	eautoreconf
	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure --disable-debug --disable-static --disable-schemas-compile
}


src_install() {
	gnome2_src_install

	find "${D}" -name '*.la' -exec rm -f {} + || die "la file removal failed"
	find "${D}" -name '*.a' -exec rm -f {} + || die "a file removal failed"
}
