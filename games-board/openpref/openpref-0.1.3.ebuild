# Copyright 1999-2020 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="OpenPref is open source implementation of European trick-taking game Preferans against two virtual players."
HOMEPAGE="https://sourceforge.net/projects/openpref"

SRC_URI="https://sourceforge.net/projects/${PN}/files/OpenPref-Qt4/${P}/${P}.tar.gz/download"

LICENSE="GPLv3"
SLOT="0"
IUSE=""
REQUIRED_USE=""

RDEPEND="
	dev-qt/qtcore:5
"
DEPEND="${RDEPEND}"

DOCS=(README)

PATCHES=( ${FILESDIR}/${PN}-qt5.patch )
