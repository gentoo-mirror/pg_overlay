# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit kde5

DESCRIPTION="Official GTK+ port of KDE's Breeze widget style"
HOMEPAGE="https://projects.kde.org/projects/kde/workspace/breeze-gtk"
LICENSE="LGPL-2.1+"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

src_prepare() {

	git apply -p1 < "${FILESDIR}"/0003-Update-for-GTK-3.20.patch

	eapply "${FILESDIR}"/0004-Properly-install-GTK-theme-depending-on-version.patch

	eapply "${FILESDIR}"/0005-Also-install-the-assets-folder.patch

	default
}
