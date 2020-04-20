# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3

DESCRIPTION="Wayland event viewer"
HOMEPAGE="https://git.sr.ht/~sircmpwn/wev"
EGIT_REPO_URI="https://git.sr.ht/~sircmpwn/wev"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	dev-libs/wayland
	x11-libs/libxkbcommon"
RDEPEND="${DEPEND}"
BDEPEND="app-text/scdoc"

src_install() {
	export PREFIX="${EPREFIX}/usr"
	default
}
