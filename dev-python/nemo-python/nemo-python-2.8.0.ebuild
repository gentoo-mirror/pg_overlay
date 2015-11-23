# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"
PYTHON_COMPAT=( python2_7 )

inherit autotools autotools-utils eutils gnome2 python-single-r1 gnome2-utils

DESCRIPTION="Python bindings for the Nautilus file manager"
HOMEPAGE="https://projects.gnome.org/nautilus-python/"
SRC_URI="https://github.com/linuxmint/nemo-extensions/archive/${PV/0}x.tar.gz"

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
S=${WORKDIR}/nemo-extensions-2.8.x/nemo-python

src_prepare() {
	# Python2 Fix
	find -type f | xargs sed -i 's@^#!.*python$@#!/usr/bin/python2@'

	# Fix path for nemo-python
	sed -i 's|libdirsuffix="/i386-linux-gnu/"|libdirsuffix=""|' m4/python.m4
	eautoreconf
}

src_configure() {
	# FIXME: package does not ship pre-built documentation
	# and has broken logic for dealing with gtk-doc
	gnome2_src_configure
}

src_install() {
	gnome2_src_install
	# Directory for systemwide extensions
	keepdir /usr/share/nemo/extensions-3.0
}
