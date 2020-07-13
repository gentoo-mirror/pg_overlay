# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )

inherit cmake-utils python-single-r1

DESCRIPTION="GObject based library that implements a reusable plugin system"
HOMEPAGE="https://bitbucket.org/gplugin/main"
SRC_URI="https://bitbucket.org/gplugin/main/downloads/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="gtk introspection lua nls perl python test"

REQUIRED_USE="
	lua? ( introspection )
	perl? ( introspection )
	python? ( introspection )"

RDEPEND="
	>=dev-libs/glib-2.34
	gtk? ( x11-libs/gtk+:3 )
	introspection? ( dev-libs/gobject-introspection )
	lua? (
		|| (
			>=dev-lang/lua-5.1:=
			>=dev-lang/luajit-2
		)
		dev-lua/lgi
	)
	nls? ( sys-devel/gettext )
	perl? ( dev-lang/perl )
	python? ( dev-python/pygobject:3[${PYTHON_USEDEP}] )"

DEPEND="
	${RDEPEND}
	nls? ( sys-devel/gettext )"

pkg_setup() {
	if use python; then
		python-single-r1_pkg_setup
	fi
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_build gtk GTK3)
		$(cmake-utils_use_build introspection GIR)
		$(cmake-utils_use_build lua LUA)
		$(cmake-utils_use_build python PYTHON)
		$(cmake-utils_use nls NLS)
		$(cmake-utils_use test TESTING_ENABLED)
		-DCMAKE_C_FLAGS="${CFLAGS}"
	)

	cmake-utils_src_configure
}
