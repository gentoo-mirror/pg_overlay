# Copyright 1999-2020 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="OpenPref is open source implementation of European trick-taking game Preferans against two virtual players."
HOMEPAGE="https://sourceforge.net/projects/openpref"

SRC_URI="https://sourceforge.net/projects/${PN}/files/OpenPref-Qt4/${P}/${P}.tar.gz/download -> ${P}.tar.gz"

LICENSE="GPLv3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-qt/qtcore:5
"
DEPEND="${RDEPEND}"

DOCS=(README)

PATCHES=( ${FILESDIR}/${PN}-qt5.patch )

src_prepare() {
	sed -i s/games/bin/g CMakeLists.txt
	cmake_src_prepare
}

src_install() {
	cmake_src_install
	insinto /usr/share/applications
	donins ${FILESDIR}/openpref.desktop
	insinto usr/share/pixmaps
	donins ${FILESDIR}/openpref.xpm
}
