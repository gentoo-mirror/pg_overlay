# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit cmake-utils git-r3

DESCRIPTION="Reliable MTP client with minimalistic UI"
HOMEPAGE="https://whoozle.github.io/android-file-transfer-linux/"
EGIT_REPO_URI="https://github.com/whoozle/${PN}.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="fuse"

RDEPEND="
	dev-qt/qtwidgets:5
	sys-libs/readline
	fuse? ( sys-fs/fuse )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_configure() {
	local mycmakeargs=(
		-DBUILD_FUSE=$(usex fuse)
		-DBUILD_QT_UI=ON
		-DUSB_BACKEND_LIBUSB=OFF
	)
	cmake-utils_src_configure
}
