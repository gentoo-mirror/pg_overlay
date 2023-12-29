# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

QTMIN=6.5.0
inherit ecm gear.kde.org

DESCRIPTION="Digital camera raw image library wrapper"

LICENSE="GPL-2+"
SLOT="6"
KEYWORDS=""
IUSE=""

DEPEND="
	>=dev-qt/qtbase-${QTMIN}:6
	>=media-libs/libraw-0.16:=
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		-DBUILD_WITH_QT6=ON
	)

	ecm_src_configure
}