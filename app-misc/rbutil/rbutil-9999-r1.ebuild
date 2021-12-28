# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PLOCALES="cs de fi fr gr he it ja nl pl pt pt_BR ru tr zh_CN zh_TW"

inherit cmake desktop git-r3 plocale xdg

DESCRIPTION="Rockbox open source firmware manager for music players"
HOMEPAGE="https://www.rockbox.org/wiki/RockboxUtility"
EGIT_REPO_URI="git://git.rockbox.org/rockbox.git"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="debug"

RDEPEND="
	dev-libs/crypto++:=
	dev-libs/quazip
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
	virtual/libusb:1
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-qt/linguist-tools:5
	virtual/pkgconfig
"

S="${WORKDIR}/${P}/utils/${PN}qt"
QTDIR="utils/${PN}qt"

PATCHES=(
	"${FILESDIR}"/${P}-fix-versionstring.patch # bug 734178
	"${FILESDIR}"/${P}-quazip1.patch
)

src_prepare() {
	plocale_find_changes "${S}/lang" "${PN}_" ".ts"
	rm_locale() {
		rm -v "lang/${PN}_${1}.ts" || die "removing of ${1}.ts failed"
		sed -i "/lang\/${PN}_${1}.ts/d" CMakeLists.txt || die "removing of ${1}.ts failed"
		sed -i "/${PN}_${1}.qm/d" lang/${PN}qt-lang.qrc || die "removing of ${1}.ts failed"
	}
	plocale_for_each_disabled_locale rm_locale

	if has_version "<dev-libs/quazip-1.0"; then
		sed -e "/^PKGCONFIG/s/quazip1-qt5/quazip/" -i ${QTDIR}/${PN}qt.pro # || die
	fi

	rm -rv {quazip,zlib}/ || die

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DQT_VERSION_MAJOR=5
	)
	cmake_src_configure
}

src_compile() {
	cmake_src_compile

	#emake -C "${QTDIR}"
}

src_install() {
	dobin RockboxUtility
	make_desktop_entry RockboxUtility "Rockbox Utility" rockbox Utility
	dodoc changelog.txt
}
