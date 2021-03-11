# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson git-r3

DESCRIPTION="A library for interfacing Music Player Daemon (media-sound/mpd)"
HOMEPAGE="https://www.musicpd.org"
EGIT_REPO_URI="https://github.com/MusicPlayerDaemon/${PN}.git"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE="doc examples test"
RESTRICT="!test? ( test )"

BDEPEND="doc? ( app-doc/doxygen )"
DEPEND="test? ( dev-libs/check )"

src_prepare() {
	default

	sed -e "s:@top_srcdir@:.:" -i doc/doxygen.conf.in || die

	# meson doesn't support setting docdir
	sed -e "/^docdir =/s/meson.project_name()/'${PF}'/" \
		-e "/^install_data(/s/'COPYING', //" \
		-i meson.build || die
}

src_configure() {
	local emesonargs=(
		-Ddocumentation="$(usex doc true false)"
		--default-library=shared
		-Dtest=$(usex test true false)
	)
	meson_src_configure
}

src_install() {
	meson_src_install
	use examples && dodoc src/example.c
}
