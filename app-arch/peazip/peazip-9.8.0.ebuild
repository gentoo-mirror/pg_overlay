# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xdg

DESCRIPTION="PeaZip is a free file archiver utility and rar extractor"
HOMEPAGE="https://peazip.github.io"
SRC_URI="https://github.com/${PN}/PeaZip/releases/download/${PV}/${P}.src.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RESTRICT="mirror"

DEPEND=">=dev-lang/lazarus-3.0
		app-text/xmlstarlet"
RDEPEND="
	${DEPEND}
	sys-apps/dbus
	dev-libs/glib
	sys-libs/ncurses
	dev-qt/qtbase:6
	dev-libs/qt6pas
"
S="${WORKDIR}/${P}.src"

PATCHES=( "${FILESDIR}"/${PN}-build.patch )

HOME="${PORTAGE_BUILDDIR}/homedir"
export HOME
src_prepare() {
	sed -E -e 's&IFDEF LCLQT5&IF DEFINED(LCLQT5) OR DEFINED(LCLQT6)&' -i "dev/peach.pas"

	# modify compiler options
	xmlstarlet edit --inplace --delete '//Other' "dev/metadarkstyle/metadarkstyle.lpk"
	sed -E 's&(</CompilerOptions>)&<Other><CustomOptions Value='\''-O3 -Sa -CX -XX -k"--sort-common --as-needed -z relro -z now"'\''/></Other>\n\1&' -i "dev/metadarkstyle/metadarkstyle.lpk"

	xmlstarlet edit --inplace --delete '//Other' "dev/project_pea.lpi"
	sed -E 's&(</CompilerOptions>)&<Other><CustomOptions Value='\''-O3 -Sa -CX -XX -k"--sort-common --as-needed -z relro -z now"'\''/></Other>\n\1&' -i "dev/project_pea.lpi"

	xmlstarlet edit --inplace --delete '//Other' "dev/project_peach.lpi"
	sed -E 's&(</CompilerOptions>)&<Other><CustomOptions Value='\''-O3 -Sa -CX -XX -k"--sort-common --as-needed -z relro -z now"'\''/></Other>\n\1&' -i "dev/project_peach.lpi"
}

src_compile() {
	# Set temporary HOME for lazarus primary config directory
	export lazbuild="$(which lazbuild) --lazarusdir=/usr/share/lazarus --build-all --cpu=native --os-linux --primary-config-path=build --widgetser=qt6"

	lazbuild dev/metadarkstyle/metadarkstyle.lpk
	lazbuild dev/project_pea.lpi
	lazbuild dev/project_peach.lpi
}

src_install() {
	default
}

pkg_postinst() {
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
}
