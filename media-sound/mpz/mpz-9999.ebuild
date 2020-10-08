# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3 l10n qmake-utils

DESCRIPTION="Music player for the large local collections"
HOMEPAGE="https://olegantonyan.github.io/mpz/"
EGIT_REPO_URI="https://github.com/olegantonyan/${PN}.git"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtmultimedia:5
	dev-qt/qtx11extras:5
"

DEPEND="${RDEPEND}"
