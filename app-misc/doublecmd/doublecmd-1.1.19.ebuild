# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xdg

DESCRIPTION="Cross Platform file manager."
HOMEPAGE="https://doublecmd.sourceforge.io/"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/v${PV}/${P}-src.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RESTRICT="mirror"

DEPEND=">=dev-lang/lazarus-3.0"
RDEPEND="
	${DEPEND}
	sys-apps/dbus
	dev-libs/glib
	sys-libs/ncurses
	dev-qt/qtbase:6
	dev-libs/libqt6pas
"


PATCHES=( "${FILESDIR}"/${PN}-build.patch )

HOME="${PORTAGE_BUILDDIR}/homedir"
export HOME
src_compile(){
	# Set temporary HOME for lazarus primary config directory
	bash build.sh release qt6 || die

}

src_install(){
	./install/linux/install.sh --install-prefix="${D}" 
}

pkg_postinst() {
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
}
