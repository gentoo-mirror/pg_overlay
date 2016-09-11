# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils games

DESCRIPTION="A puzzle game inspired by Albert Einstein"
HOMEPAGE="https://freecode.com/projects/einsteinpuzzle"
SRC_URI="mirror://gentoo/${P}-src.tar.gz
	mirror://gentoo/${PN}.png"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="media-libs/libsdl[sound,video]
	media-libs/sdl-mixer
	media-libs/sdl-ttf"
RDEPEND="${DEPEND}"

src_prepare() {
	#epatch "${FILESDIR}"/${P}*.patch
	#epatch "${FILESDIR}"/*.diff
 	patch -p0 <  "${FILESDIR}"/01_sdl.diff
    patch -p0 <  "${FILESDIR}"/02_prefix.diff
    patch -p0 <  "${FILESDIR}"/03_fonts.diff
    patch -p0 <  "${FILESDIR}"/04_fame.diff
    patch -p0 <  "${FILESDIR}"/05_icon.diff
    patch -p0 <  "${FILESDIR}"/06_srand.diff
    patch -p0 <  "${FILESDIR}"/07_long.diff
    patch -p0 <  "${FILESDIR}"/08_gcc43.diff
    patch -p0 <  "${FILESDIR}"/09_colors.diff
    patch -p0 <  "${FILESDIR}"/10_gcc43.diff
	
	sed -i \
		-e "/PREFIX/s:/usr/local:${GAMES_PREFIX}:" \
		-e "s:\$(PREFIX)/share/einstein:${GAMES_DATADIR}/${PN}:" \
		-e "s:\$(PREFIX)/bin:${GAMES_BINDIR}:" \
		-e "s/\(OPTIMIZE=[^#]*\)/\0 ${CXXFLAGS}/" Makefile \
		|| die
	sed -i \
		-e "s:PREFIX L\"/share/einstein:L\"${GAMES_DATADIR}/${PN}:" main.cpp \
		|| die
}

src_install() {
	dogamesbin "${PN}"
	insinto "${GAMES_DATADIR}/${PN}/res"
	doins einstein.res
	doicon "${DISTDIR}"/${PN}.png
	make_desktop_entry ${PN} "Einstein Puzzle"
	prepgamesdirs
}
