# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Monkey's Audio Codecs"
HOMEPAGE="https://www.monkeysaudio.com"
SRC_URI="https://monkeysaudio.com/files/MAC_${PV/.}_SDK.zip -> ${P}.zip"

LICENSE="mac"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND=""
DEPEND=""

src_unpack() {
	mkdir ${S}
	cd ${S}
	unpack ${A}
}

src_compile() {
	pushd Source/Projects/NonWindows
	emake prefix=${EPREFIX}/usr libdir=${EPREFIX}/usr/$(get_libdir)
}

src_install() {
	pushd Source/Projects/NonWindows
	emake DESTDIR=${ED} prefix=${EPREFIX}/usr libdir=${EPREFIX}/usr/$(get_libdir) install
}
