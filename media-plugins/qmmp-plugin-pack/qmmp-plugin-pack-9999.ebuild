# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

CMAKE_MIN_VERSION=2.8

inherit cmake-utils
[ "$PV" == "9999" ] && inherit subversion

DESCRIPTION="A set of extra plugins for Qmmp"
HOMEPAGE="http://qmmp.ylsoftware.com/"

if [ "$PV" != "9999" ]; then
	SRC_URI="http://qmmp.ylsoftware.com/files/plugins/${P}.tar.bz2"
	KEYWORDS="~amd64 ~x86"
else
	QMMP_DEV_BRANCH="1.1"
	SRC_URI=""
	ESVN_REPO_URI="svn://svn.code.sf.net/p/qmmp-dev/code/branches/${PN}-${QMMP_DEV_BRANCH}"
	KEYWORDS=""
fi

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="media-libs/taglib
	>=media-sound/qmmp-1.0.0
	dev-qt/qtgui:5
	dev-qt/qtx11extras:5
	dev-qt/qtwidgets:5"
DEPEND="${RDEPEND}
	dev-lang/yasm
	dev-qt/linguist-tools:5"

PATCHES=( "${FILESDIR}"/${P}-fix-build.patch )
