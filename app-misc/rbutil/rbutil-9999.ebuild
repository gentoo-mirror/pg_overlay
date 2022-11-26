# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PLOCALES="cs de fi fr gr he it ja nl pl pt pt_BR ru tr zh_CN zh_TW"

inherit cmake desktop git-r3 plocale xdg

DESCRIPTION="Rockbox open source firmware manager for music players"
HOMEPAGE="https://www.rockbox.org/wiki/RockboxUtility"
EGIT_REPO_URI="git://git.rockbox.org/rockbox.git"
LICENSE="GPL-2"
SLOT="0"
#KEYWORDS="~amd64"
IUSE="debug"

RDEPEND="
	app-arch/bzip2:=
	>=dev-libs/quazip-1.2:=[qt5(+)]
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	virtual/libusb:1
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-qt/linguist-tools:5
	virtual/pkgconfig
"

S="${WORKDIR}/${P}"
CMAKE_USE_DIR="${S}/utils"

PATCHES=(
	#"${FILESDIR}"/${PN}-1.5.1-system-quazip.patch
	"${FILESDIR}"/${PN}-1.5.1-cmake.patch
	"${FILESDIR}"/${PN}-1.5.1-headers.patch
)

src_prepare() {
	rm_locale() {
		rm -v "${CMAKE_USE_DIR}/${PN}qt/lang/${PN}_${1}.ts" || die "removing of ${1}.ts failed"
		sed -i "/lang\/${PN}_${1}.ts/d" ${CMAKE_USE_DIR}/${PN}qt/CMakeLists.txt || die "removing of ${1}.ts failed"
		sed -i "/${PN}_${1}.qm/d" ${CMAKE_USE_DIR}/${PN}qt/lang/${PN}qt-lang.qrc || die "removing of ${1}.ts failed"
	}
	plocale_for_each_disabled_locale rm_locale

	cmake_src_prepare
	rm -rv utils/rbutilqt/{quazip,zlib}/ || die
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=OFF
		-DCCACHE_PROGRAM=OFF
		-DUSE_SYSTEM_QUAZIP=ON
	)
	cmake_src_configure
}

src_install() {
	dobin "${BUILD_DIR}"/{ipodpatcher,sansapatcher,rbutilqt/RockboxUtility}
	newicon -s scalable docs/logo/rockbox-clef.svg rockbox.svg
	make_desktop_entry RockboxUtility "Rockbox Utility" rockbox
	dodoc utils/rbutilqt/changelog.txt
}
