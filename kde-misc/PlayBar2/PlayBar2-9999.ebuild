# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit kde5

DESCRIPTION="MPRIS2 client, written in QML for Plasma 5 and GNU/Linux"
HOMEPAGE="https://github.com/audoban/PlayBar2"

if [[ ${KDE_BUILD_TYPE} = live ]] ; then
	EGIT_REPO_URI="git://github.com/audoban/${PN}.git"
else
	SRC_URI="https://github.com/audoban/PlayBar2/archive/v${PV}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="GPL-2"
KEYWORDS=""
IUSE=""

DEPEND="
	$(add_frameworks_dep plasma)"
RDEPEND="${DEPEND}
			$(add_plasma_dep plasma-workspace)"

DOCS=( README.md )
