# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit kde5

DESCRIPTION="Collection of minimalistic Plasmoids which look like Awesome WM widgets (ex-PyTextMonitor)"
HOMEPAGE="https://arcanis.me/projects/awesome-widgets"

if [[ ${KDE_BUILD_TYPE} = live ]] ; then
	EGIT_REPO_URI="git://github.com/arcan1s/awesome-widgets.git"
else
	SRC_URI="https://github.com/arcan1s/awesome-widgets/archive/V.${PV}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="GPL-2+"
KEYWORDS=""
IUSE=""

DEPEND="
	$(add_frameworks_dep plasma)
	$(add_qt_dep qtdeclarative)
"
RDEPEND="${DEPEND}"

DOCS=( README.md )
S=${S}/sources
