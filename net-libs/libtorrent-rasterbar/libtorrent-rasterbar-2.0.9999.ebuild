# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..12} )
inherit cmake git-r3 python-single-r1

DESCRIPTION="C++ BitTorrent implementation focusing on efficiency and scalability"
HOMEPAGE="https://libtorrent.org/ https://github.com/arvidn/libtorrent"
EGIT_REPO_URI="https://github.com/arvidn/libtorrent.git"
EGIT_BRANCH="RC_2_0"
#EGIT_SUBMODULES=()

LICENSE="BSD"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS=""
IUSE="+dht debug examples gnutls python ssl test"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"
RESTRICT="!test? ( test )"

DEPEND="
	dev-libs/boost:=
	ssl? (
		gnutls? ( net-libs/gnutls:= )
		!gnutls? ( dev-libs/openssl:= )
	)
"
RDEPEND="
	${DEPEND}
	python? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep '
			dev-libs/boost[python,${PYTHON_USEDEP}]
		')
	)
"
BDEPEND="
	dev-util/patchelf
	python? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep '
			dev-python/setuptools[${PYTHON_USEDEP}]
		')
	)
	test? (
		${PYTHON_DEPS}
	)
"

pkg_setup() {
	# python required for tests due to webserver.py
	if use python || use test; then
		python-single-r1_pkg_setup
	fi
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_BUILD_TYPE=Release
		-DCMAKE_CXX_STANDARD=17
		-DBUILD_SHARED_LIBS=ON
		-Dbuild_examples=$(usex examples)
		-Ddht=$(usex dht ON OFF)
		-Dencryption=$(usex ssl ON OFF)
		-Dgnutls=$(usex gnutls ON OFF)
		-Dlogging=$(usex debug ON OFF)
		-Dpython-bindings=$(usex python ON OFF)
		-Dbuild_tests=$(usex test ON OFF)
		-Ddeprecated-functions=OFF
		-Di2p=ON
		-Dstreaming=OFF
	)

	# We need to drop the . from the Python version to satisfy Boost's
	# FindBoost.cmake module, bug #793038.
	use python && mycmakeargs+=( -Dboost-python-module-name="${EPYTHON/./}" )

	cmake_src_configure
}

src_test() {
	CMAKE_SKIP_TESTS=(
		# Needs running UPnP server
		"test_upnp"
		# Fragile to parallelization
		# https://bugs.gentoo.org/854603#c1
		"test_utp"
		# Flaky test, fails randomly
		"test_remove_torrent"
	)

	LD_LIBRARY_PATH="${BUILD_DIR}:${LD_LIBRARY_PATH}" cmake_src_test
}

src_install() {
	cmake_src_install
	einstalldocs

	if use examples; then
		pushd "${BUILD_DIR}"/examples >/dev/null || die
		for binary in {client_test,connection_tester,custom_storage,dump_bdecode,dump_torrent,make_torrent,simple_client,stats_counters,upnp_test}; do
			patchelf --remove-rpath ${binary} || die
			dobin ${binary}
		done
		popd >/dev/null || die
	fi
}
