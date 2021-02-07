# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake git-r3

DESCRIPTION="Easy-to-use event device library in C++"

HOMEPAGE="https://github.com/YukiWorkshop/libevdevPlus"
EGIT_REPO_URI="https://github.com/YukiWorkshop/${PN}.git"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"

#S=${WORKDIR}/libevdevPlus-${PV}
