# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools git-r3

EGIT_REPO_URI="https://github.com/Serranya/${PN}.git"
KEYWORDS=""

DESCRIPTION="A plugin that implements the MPRISv2 for DeaDBeeF"
HOMEPAGE="https://github.com/Serranya/${PN}"

LICENSE="GPL-3"
SLOT="0"
IUSE=""

DEPEND="
	media-sound/deadbeef
"
RDEPEND="${DEPEND}"
BDEPEND=""

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf --disable-static
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete
}
