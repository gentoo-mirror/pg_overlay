# Copyright 1999-2024 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
#

inherit gnome.org poly-c_ebuilds

GNOME_ORG_PV="${MY_PV}"
SRC_URI="mirror://gnome/sources/${GNOME_ORG_MODULE}/${GNOME_ORG_RELEASE}/${GNOME_ORG_MODULE}-${GNOME_ORG_PV}.tar.${GNOME_TARBALL_SUFFIX}"
S="${WORKDIR}/${GNOME_ORG_MODULE}-${GNOME_ORG_PV}"
