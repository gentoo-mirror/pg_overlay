# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6
inherit cmake-utils git-r3

MY_PN=${PN}-linux
DESCRIPTION="Reliable MTP client with minimalistic UI"
HOMEPAGE="https://whoozle.github.io/android-file-transfer-linux/"
EGIT_REPO_URI="git://github.com/whoozle/${PN}-linux.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="fuse +qt5"
REQUIRED_USE="qt5"

RDEPEND="fuse? ( sys-fs/fuse )
	qt5? ( dev-qt/qtwidgets:5 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_configure() {
	local mycmakeargs=(
		-DBUILD_FUSE=$(usex fuse)
		-DBUILD_QT_UI=$(usex qt5)
		-DUSB_BACKEND_LIBUSB=OFF
	)
	cmake-utils_src_configure
}
