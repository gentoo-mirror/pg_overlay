# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit linux-info udev vcs-snapshot

EXTRA_PV=00.99

DESCRIPTION="Samsung Unified Linux Driver for printers and MFDs"
HOMEPAGE="http://www.samsung.com"
SRC_URI="http://downloadcenter.samsung.com/content/DR/201512/20151211135958538/ULD_v${PV}_${EXTRA_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Samsung-EULA"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE="cups network scanner"

RDEPEND="
	cups? (
		net-print/cups
		!net-print/splix
	)
	scanner? (
		media-gfx/sane-backends
		dev-libs/libxml2:2
		virtual/libusb:0
	)
	network? ( virtual/libusb:0 )
"

REQUIRED_USE="
	network? ( cups )
	|| ( cups scanner )
"

RESTRICT="mirror strip"

pkg_pretend() {
	if use scanner && ! has_version ${CATEGORY}/${PN}[scanner]; then
		if ! linux_config_exists || linux_chkconfig_present USB_PRINTER; then
			ewarn "Samsung USB MFDs are normally managed via libusb."
			ewarn "In this case, you need to either disable the USB_PRINTER"
			ewarn "support in your kernel, or blacklist the 'usblp' module."
		fi
	fi
}

src_install() {
	local MY_ARCH="x86_64"
	pushd uld
	./install.sh
}

pkg_postinst() {
	if use scanner && ! has_version ${CATEGORY}/${PN}[scanner]; then
		elog "You need to manually add 'smfp' backend to /etc/sane.d/dll.conf:"
		elog "# echo smfp >> /etc/sane.d/dll.conf"
	fi
	if use network && ! has_version ${CATEGORY}/${PN}[network]; then
		elog "If you are behind a firewall, you need to allow SNMP UDP packets"
		elog "with source port 161 and destination port 22161."
	fi
}
