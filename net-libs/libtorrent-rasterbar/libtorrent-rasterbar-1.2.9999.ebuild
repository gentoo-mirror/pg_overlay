# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{9,10} )
PYTHON_REQ_USE="threads(+)"
DISTUTILS_OPTIONAL=true
DISTUTILS_IN_SOURCE_BUILD=true

inherit autotools flag-o-matic distutils-r1 git-r3

DESCRIPTION="C++ BitTorrent implementation focusing on efficiency and scalability"
HOMEPAGE="http://libtorrent.org"
EGIT_REPO_URI="https://github.com/arvidn/libtorrent.git"
EGIT_BRANCH="RC_1_2"
EGIT_SUBMODULES=()

LICENSE="BSD"
SLOT="0/10"
KEYWORDS=""
IUSE="debug +dht doc examples libressl python +ssl static-libs test"

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
	# Versions
	#sed -i s/1.2.2/1.1.13/g configure.ac || die
	#sed -i s/1.2.2.0/1.1.13.0/g include/libtorrent/version.hpp || die

	mkdir "${S}"/build-aux/ || die
	touch "${S}"/build-aux/config.rpath || die
	append-cxxflags -std=c++14
	eautoreconf

	default

	# bug 578026
	# prepend -L${S}/... to ensure bindings link against the lib we just built
	sed -i -e "s|^|-L${S}/src/.libs |" bindings/python/link_flags.in || die

	# prepend -I${S}/... to ensure bindings use the right headers
	sed -i -e "s|^|-I${S}/src/include |" bindings/python/compile_flags.in || die

	use python && distutils-r1_src_prepare
}

src_configure() {

	local myeconfargs=(
		$(use_enable debug)
		$(use_enable debug export-all)
		$(use_enable debug logging)
		$(use_enable dht)
		$(use_enable examples)
		$(use_enable ssl encryption)
		$(use_enable static-libs static)
		$(use_enable test tests)
		--with-boost
		--with-libiconv
	)
	econf "${myeconfargs[@]}"

	if use python; then
		python_configure() {
			econf "${myeconfargs[@]}" \
				--enable-python-binding \
				--with-boost-python="boost_${EPYTHON/./}"
				# git rid of c++11
				sed s/-std=c++11//g < bindings/python/compile_cmd > bindings/python/compile_cmd.new || die
				mv -f bindings/python/compile_cmd.new bindings/python/compile_cmd || die
		}
		distutils-r1_src_configure
	fi
}

src_compile() {
	default

	python_compile() {
		cd "${BUILD_DIR}/../bindings/python" || die
		distutils-r1_python_compile
	}
	use python && distutils-r1_src_compile
}

src_install() {
	use doc && HTML_DOCS+=( "${S}"/docs )

	default

	python_install() {
		cd "${BUILD_DIR}/../bindings/python" || die
		distutils-r1_python_install
	}
	use python && distutils-r1_src_install

	find "${D}" -name '*.la' -delete || die
}
