# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils bash-completion-r1

DESCRIPTION="Nemo-Compare Extension"
HOMEPAGE="https://github.com/linuxmint/nemo-extensions"
SRC_URI="https://github.com/linuxmint/nemo-extensions/archive/${PV}.tar.gz"

LICENSE="GPL"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+meld diffuse"
RDEPEND=">=gnome-extra/nemo-3.0
		>=dev-python/nemo-python-3.0
		dev-python/pyxdg
		meld? ( dev-util/meld )
		diffuse? ( dev-util/diffuse )"
DEPEND=""

S=${WORKDIR}/nemo-extensions-${PV}/${PN}

src_install() {
	insinto /usr/share/applications/
	doins data/${PN}-preferences.desktop

	insinto /usr/share/${PN}/
	doins data/${PN}-notification
	doins src/*

	dosym /usr/share/${PN}/${PN}-preferences.py /usr/bin/${PN}-preferences

	dosym /usr/share/${PN}/${PN}.py /usr/share/nemo-python/extensions/${PN}.py
}
