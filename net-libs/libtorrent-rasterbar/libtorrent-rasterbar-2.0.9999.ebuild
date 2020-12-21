# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
PYTHON_REQ_USE="threads(+)"
DISTUTILS_OPTIONAL=true
DISTUTILS_IN_SOURCE_BUILD=true

inherit cmake distutils-r1 git-r3

DESCRIPTION="C++ BitTorrent implementation focusing on efficiency and scalability"
HOMEPAGE="http://libtorrent.org"
EGIT_REPO_URI="https://github.com/arvidn/libtorrent.git"
EGIT_BRANCH="RC_2_0"
EGIT_SUBMODULES=()

LICENSE="BSD"
SLOT="0/10"
#KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~sparc ~x86"
IUSE="debug doc examples libressl python +ssl test"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/boost:=[threads]
	virtual/libiconv
	examples? ( !net-p2p/mldonkey )
	python? (
		${PYTHON_DEPS}
		dev-libs/boost:=[python,${PYTHON_USEDEP}]
	)
	ssl? (
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl:= )
	)
"
DEPEND="${RDEPEND}
	sys-devel/libtool
"

src_prepare() {
	default

	# bug 578026
	# prepend -L${S}/... to ensure bindings link against the lib we just built
	#sed -i -e "s|^|-L${S}/src/.libs |" bindings/python/link_flags.in || die

	# prepend -I${S}/... to ensure bindings use the right headers
	#sed -i -e "s|^|-I${S}/src/include |" bindings/python/compile_flags.in || die

	use python && distutils-r1_src_prepare
}

src_configure() {

	local mycmakeargs=(
		-DCMAKE_BUILD_TYPE=Release \
		-DCMAKE_CXX_STANDARD=14 \
		-GNinja \
		-Dbuild_examples=${usex examples} \
		-Dbuild_tests=${usex test} \
		-Dbuild_tools=ON \
		-Dpython-bindings=${usex python} \
		-Dpython-egg-info=${usex python} \
		-Dpython-install-system-dir=${usex python} \
	)

	cmake_src_configure
}

src_compile() {
	default
	cmake_src_compile
}

src_install() {
	use doc && HTML_DOCS+=( "${S}"/docs )

	default

	cmake_src_install

	find "${D}" -name '*.la' -delete || die
}
