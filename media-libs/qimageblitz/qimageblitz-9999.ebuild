# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-utils subversion

DESCRIPTION="Graphical effect and filter library by KDE"
HOMEPAGE="https://websvn.kde.org/trunk/kdesupport/qimageblitz/"
ESVN_REPO_URI="svn://anonsvn.kde.org/home/kde/trunk/kdesupport/qimageblitz"

LICENSE="GPL-2 LGPL-2"
KEYWORDS="~amd64 ~arm ~hppa ~ppc ~ppc64 ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~x86-macos ~x86-solaris"
SLOT="0"
IUSE="cpu_flags_x86_3dnow altivec debug cpu_flags_x86_mmx cpu_flags_x86_sse cpu_flags_x86_sse2"

DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
"
RDEPEND="${DEPEND}"

src_prepare() {
	cmake-utils_src_prepare

	# bug 581824: use system find module for Qt4
	rm -f cmake/modules/FindQt4.cmake || die
}

src_configure() {
	local mycmakeargs=(
		-DHAVE_ALTIVEC=$(usex altivec)
		-DHAVE_3DNOW=$(usex cpu_flags_x86_3dnow)
		-DHAVE_MMX=$(usex cpu_flags_x86_mmx)
		-DHAVE_SSE=$(usex cpu_flags_x86_sse)
		-DHAVE_SSE2=$(usex cpu_flags_x86_sse2)
		-DQT4_BUILD=OFF
	)

	cmake-utils_src_configure
}
