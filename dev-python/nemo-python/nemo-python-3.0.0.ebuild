# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

GNOME2_LA_PUNT="yes"
PYTHON_COMPAT=( python2_7 )

inherit autotools eutils gnome2 gnome2-utils python-single-r1

DESCRIPTION="Python bindings for the Nautilus file manager"
HOMEPAGE="https://projects.gnome.org/nautilus-python/"
SRC_URI="https://github.com/linuxmint/nemo-extensions/archive/${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 x86"
IUSE="doc"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

# Depend on pygobject:3 for sanity, and because it's automagic
RDEPEND="
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	>=gnome-extra/nemo-2.8[introspection]
	${PYTHON_DEPS}
"
DEPEND="${RDEPEND}
	>=dev-util/gtk-doc-am-1.9
	virtual/pkgconfig
	doc? (
		app-text/docbook-xml-dtd:4.1.2
		dev-libs/libxslt
		>=dev-util/gtk-doc-1.9 )
"
S=${WORKDIR}/nemo-extensions-${PV}/${PN}

src_prepare() {
	mv configure.in configure.ac

	eautoreconf
	gnome2_src_prepare
}

src_configure() {
	# FIXME: package does not ship pre-built documentation
	# and has broken logic for dealing with gtk-doc
	gnome2_src_configure --disable-static
}

src_install() {
	gnome2_src_install
	# Directory for systemwide extensions
	keepdir /usr/share/nemo/extensions-3.0

	# removing unnecessary .la & .a files
	find "${D}" -name '*.la' -exec rm -f {} + || die "la file removal failed"
	find "${D}" -name '*.a' -exec rm -f {} + || die "a file removal failed"
}
