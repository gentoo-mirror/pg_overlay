# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-utils

DESCRIPTION="Graphical interface for QEMU and KVM emulators, using Qt5"
HOMEPAGE="https://github.com/F1ash/qt-virt-manager"
SRC_URI="https://github.com/F1ash/${PN}/archive/${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="${RDEPEND}"
RDEPEND="app-emulation/qemu
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtmultimedia:5
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	dev-qt/qtnetwork:5
	=x11-libs/qtermwidget-9999[qt5]
	dev-libs/glib:2
	net-misc/spice-gtk
	net-libs/libvncserver
	app-emulation/libvirt"


#DOCS="AUTHORS CHANGELOG README TODO"

src_configure() {

	local mycmakeargs=(
		"-DBUILD_QT_VERSION=5"
	)

	cmake-utils_src_configure
}
