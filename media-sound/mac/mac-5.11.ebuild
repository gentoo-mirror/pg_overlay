# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Monkey's Audio Codecs"
HOMEPAGE="https://www.monkeysaudio.com"
SRC_URI="http://monkeysaudio.com/files/MAC_SDK_511.zip -> ${P}.zip"

LICENSE="mac"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND=""
DEPEND="
	sys-apps/sed
"

#S=${WORKDIR}/MAC_SDK_511

DOCS=( AUTHORS ChangeLog NEWS TODO README src/History.txt src/Credits.txt ChangeLog.shntool )

RESTRICT="mirror"

src_unpack() {
	mkdir ${S}
	cd ${S}
	unpack ${A}
}

src_prepare() {
	default
	cp Source/Projects/NonWindows/Makefile .
	sed -i s:/usr/local:/usr:g Makefile
	 sed -i s:$(prefix)/lib:$(prefix)/lib64:g Makefile
	 }

src_compile() {
	emake
}

src_install() {
    emake DESTDIR="${D}" PREFIX=/usr install
}
