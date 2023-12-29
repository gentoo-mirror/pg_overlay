# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="optional"
ECM_TEST="true"
KFMIN=5.246.0
QTMIN=6.6.0
inherit ecm gear.kde.org optfeature

DESCRIPTION="Image viewer by KDE"
HOMEPAGE="https://apps.kde.org/gwenview/ https://userbase.kde.org/Gwenview"

LICENSE="GPL-2+ handbook? ( FDL-1.2 )"
SLOT="6"
KEYWORDS=""
IUSE="activities fits +mpris raw semantic-desktop share X"

# requires running environment
RESTRICT="test"

# slot op: includes qpa/qplatformnativeinterface.h
COMMON_DEPEND="
	dev-libs/wayland
	>=kde-frameworks/kcompletion-${KFMIN}:6
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kconfigwidgets-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kguiaddons-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kiconthemes-${KFMIN}:6
	>=kde-frameworks/kio-${KFMIN}:6
	>=kde-frameworks/kitemmodels-${KFMIN}:6
	>=kde-frameworks/kitemviews-${KFMIN}:6
	>=kde-frameworks/kjobwidgets-${KFMIN}:6
	>=kde-frameworks/knotifications-${KFMIN}:6
	>=kde-frameworks/kparts-${KFMIN}:6
	>=kde-frameworks/kservice-${KFMIN}:6
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:6
	>=kde-frameworks/kxmlgui-${KFMIN}:6
	>=kde-frameworks/solid-${KFMIN}:6
	media-gfx/exiv2:=
	media-libs/kcolorpicker
	>=media-libs/kimageannotator-0.5.0
	media-libs/lcms:2
	media-libs/libjpeg-turbo:=
	media-libs/libpng:0=
	>=media-libs/phonon-4.11.0[qt6(+)]
	media-libs/tiff:=
	activities? ( >=kde-plasma/plasma-activities-${KFMIN}:6 )
	fits? ( sci-libs/cfitsio )
	semantic-desktop? (
		>=kde-frameworks/baloo-${KFMIN}:6
		>=kde-frameworks/kfilemetadata-${KFMIN}:6
	)
	share? ( >=kde-frameworks/purpose-${KFMIN}:6 )
	X? (
		x11-libs/libX11
	)
"
DEPEND="${COMMON_DEPEND}
	dev-libs/wayland-protocols
	>=kde-frameworks/kwindowsystem-${KFMIN}:6
"
RDEPEND="${COMMON_DEPEND}
	>=dev-qt/qtimageformats-${QTMIN}:6
	>=kde-frameworks/kimageformats-${KFMIN}:6
"
BDEPEND="
	dev-util/wayland-scanner
"

src_prepare() {
	ecm_src_prepare
	if ! use mpris; then
		# FIXME: upstream a better solution
		sed -e "/set(HAVE_QTDBUS/s/\${Qt6DBus_FOUND}/0/" -i CMakeLists.txt || die
	fi
}

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package activities KF6Activities)
		$(cmake_use_find_package fits CFitsio)
		$(cmake_use_find_package raw KF6KDcraw)
		-DGWENVIEW_SEMANTICINFO_BACKEND=$(usex semantic-desktop Baloo None)
		$(cmake_use_find_package share KF6Purpose)
		-DWITHOUT_X11=$(usex !X)
		-DBUILD_WITH_QT6=ON
	)
	ecm_src_configure
}

pkg_postinst() {
	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		optfeature "SVG support" "kde-apps/svgpart:${SLOT}"
	fi
	ecm_pkg_postinst
}