# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit mercurial meson

DESCRIPTION="Toolkit for creating text-mode graphical user interfaces"
HOMEPAGE="https://pidgin.im/"
SRC_URI=""
EHG_REPO_URI="https://bitbucket.org/pidgin/libgnt"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="doc +introspection"

RDEPEND="
	>=dev-libs/glib-2.44.0:2
	>=dev-libs/libxml2-2.6.18:2
	sys-libs/ncurses:0=[unicode]
"

DEPEND="${RDEPEND}"

BDEPEND="
	virtual/pkgconfig
	doc? ( dev-util/gtk-doc )
"

DOCS=( COPYRIGHT README.md ChangeLog )

src_unpack() {
	mercurial_src_unpack
}

src_configure() {
	local emesonargs=(
		$(meson_use doc)
		$(meson_use introspection)
	)
	meson_src_configure
}

src_compile() {
	meson_src_compile
}

src_install() {
	meson_src_install
}
