# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

CMAKE_MIN_VERSION=2.8

inherit cmake-utils subversion

DESCRIPTION="A set of extra plugins for Qmmp"
HOMEPAGE="http://qmmp.ylsoftware.com/"

QMMP_DEV_BRANCH="1.2"
ESVN_REPO_URI="svn://svn.code.sf.net/p/qmmp-dev/code/branches/${PN}-${QMMP_DEV_BRANCH}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND=">=media-libs/taglib-1.10
	=media-sound/qmmp-9999
	dev-qt/qtgui:5
	dev-qt/qtx11extras:5
	dev-qt/qtwidgets:5"
DEPEND="${RDEPEND}
	dev-lang/yasm
	dev-qt/linguist-tools:5"

src_prepare() {
	mycmakeargs=(
		-DUSE_GOOM=0
	)
	cmake-utils_src_prepare
}
