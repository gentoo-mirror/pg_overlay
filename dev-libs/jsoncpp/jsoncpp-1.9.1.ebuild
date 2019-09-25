# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_7 )

inherit meson python-any-r1

DESCRIPTION="C++ JSON reader and writer"
HOMEPAGE="https://github.com/open-source-parsers/jsoncpp"
SRC_URI="https://github.com/open-source-parsers/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="|| ( public-domain MIT )"
SLOT="0/21"
#KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-fbsd"
IUSE="doc test"

DEPEND="
	doc? (
		app-doc/doxygen
		${PYTHON_DEPS}
	)
	test? (
		${PYTHON_DEPS}
	)"
RDEPEND=""

RESTRICT="!test? ( test )"

pkg_setup() {
	if use doc || use test; then
		python-any-r1_pkg_setup
	fi
}

src_prepare() {
	sed -E "s|(version : )'1.9.0'|\1'${PVR}'|" -i meson.build
	default
}


src_configure() {
	local emesonargs=(
		--buildtype release
		-Dbuildtype=release
		-Ddefault_library=shared
	)
	meson_src_configure
}

src_compile() {
	meson_src_compile

	if use doc; then
		"${EPYTHON}" doxybuild.py --doxygen="${EPREFIX}"/usr/bin/doxygen || die
		HTML_DOCS=( dist/doxygen/jsoncpp*/. )
	fi
}

src_test() {
	meson_src_test jsoncpp_check
}
