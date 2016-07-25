# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit gnome2-utils

DESCRIPTION="Nemo-Terminal Extension"
HOMEPAGE="https://github.com/linuxmint/nemo-extensions"
SRC_URI="https://github.com/linuxmint/nemo-extensions/archive/${PV}.tar.gz"

LICENSE="GPL"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
         >=gnome-extra/nemo-3.0
         >=dev-python/nemo-python-3.0
         x11-libs/vte:2.90"
DEPEND=""

S=${WORKDIR}/nemo-extensions-${PV}/${PN}

src_install() {

	insinto /usr/share/glib-2.0/schemas
	doins src/org.nemo.extensions.${PN}.gschema.xml

	exeinto /usr/share/nemo-python/extensions
	doexe src/nemo_terminal.py

	insinto /usr/share/${PN}
	doins pixmap/logo_120x120.png

	gnome2_schemas_update
}
