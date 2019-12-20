# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

MY_PN=monkeys-audio
MY_PV=$(ver_cut 1-2)-u$(ver_cut 3)-b$(ver_cut 4)-s$(ver_cut 5)
MY_P=${MY_PN}_${MY_PV}

DESCRIPTION="Monkey's Audio Codecs"
HOMEPAGE="https://www.monkeysaudio.com"
SRC_URI="http://monkeysaudio.com/files/MAC_SDK_511.zip -> ${P}.zip"

LICENSE="mac"
SLOT="0"
KEYWORDS="alpha amd64 ppc ppc64 sparc x86"
IUSE="cpu_flags_x86_mmx static-libs"

RDEPEND=""
DEPEND="
	sys-apps/sed
	cpu_flags_x86_mmx? ( dev-lang/yasm )
"

#S=${WORKDIR}/MAC_SDK_511

DOCS=( AUTHORS ChangeLog NEWS TODO README src/History.txt src/Credits.txt ChangeLog.shntool )

RESTRICT="mirror"

src_unpack() {
	unpack ${A} ${P}
}

src_prepare() {
	default
	cp Source/Projects/NonWindows/Makefile .
}

src_compile() {
	emake
}

src_install() {
    emake DESTDIR="${D}" PREFIX=/usr install
}
