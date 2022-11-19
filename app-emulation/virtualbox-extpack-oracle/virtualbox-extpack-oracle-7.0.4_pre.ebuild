# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit poly-c_ebuilds

REAL_PV="$(ver_cut 1-3)"
REAL_PN="Oracle_VM_VirtualBox_Extension_Pack"
REAL_P="${REAL_PN}-${REAL_PV}"

DESCRIPTION="PUEL extensions for VirtualBox"
HOMEPAGE="https://www.virtualbox.org/"
SRC_URI="https://download.virtualbox.org/virtualbox/${REAL_PV}/${REAL_P}.vbox-extpack -> ${REAL_P}.tar.gz"

LICENSE="PUEL"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64"
RESTRICT="bindist mirror strip"

RDEPEND="=app-emulation/virtualbox-${REAL_PV}*"

S="${WORKDIR}"

QA_PREBUILT="usr/lib*/virtualbox/ExtensionPacks/${REAL_PN}/*"

src_install() {
	insinto /usr/$(get_libdir)/virtualbox/ExtensionPacks/${REAL_PN}
	doins -r linux.${ARCH}
	doins ExtPack* PXE-Intel.rom
}
