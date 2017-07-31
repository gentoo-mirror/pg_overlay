# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit meson git-r3

DESCRIPTION="A library for interfacing Music Player Daemon (media-sound/mpd)"
HOMEPAGE="http://www.musicpd.org"
EGIT_REPO_URI="git://git.musicpd.org/master/libmpdclient.git"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE="doc examples static"

RDEPEND=""
DEPEND="doc? ( app-doc/doxygen )"

src_prepare() {
	default
	sed -e "s:@top_srcdir@:.:" -i doc/doxygen.conf.in
}

src_configure() {
	local emesonargs=(
		--buildtype=release
		--strip
		-Ddocumentation="$(usex doc true false)"
		--default-library="$(usex static static shared)"
	)
	meson_src_configure
}

src_install() {
	default
	use examples && dodoc src/example.c
	use doc || rm -rf "${ED}"/usr/share/doc/${PF}/html
	find "${ED}" -name "*.la" -exec rm -rf {} + || die "failed to delete .la files"
}
