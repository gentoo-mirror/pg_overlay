# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit eutils bash-completion-r1 python-r1

DESCRIPTION="Nemo-Compare Extension"
HOMEPAGE="https://github.com/linuxmint/nemo-extensions"
SRC_URI="http://packages.linuxmint.com/pool/main/n/${PN}/${PN}_2.8.0+rosa.tar.gz -> ${P}.tar.gz"

LICENSE="GPL"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+meld diffuse"
RDEPEND=">=gnome-extra/nemo-2.8
		>=dev-python/nemo-python-2.8
		dev-python/pyxdg
		meld? ( dev-util/meld )
		diffuse? ( dev-util/diffuse )"
DEPEND=""

S=${S}+rosa

src_install() {
	find -type f | xargs sed -i 's@^#!.*python$@#!/usr/bin/python2@'
	 
	insinto /usr/share/applications/
	doins data/${PN}-preferences.desktop
	
	insinto /usr/share/${PN}/
	doins data/${PN}-notification
	doins src/*
	
	insinto /usr/share/python/runtime.d/
	doins ${FILESDIR}/${PN}.rtupdate
	
	fperms +x /usr/share/${PN}/${PN}-preferences.py
	
	dosym /usr/share/${PN}/${PN}-preferences.py /usr/bin/${PN}-preferences
			
	dosym /usr/share/${PN}/${PN}.py /usr/share/nemo-python/extensions/${PN}.py
}
