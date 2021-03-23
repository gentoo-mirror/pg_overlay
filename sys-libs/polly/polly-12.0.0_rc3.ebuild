# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_ECLASS=cmake
PYTHON_COMPAT=( python3_{6..9} )
inherit cmake linux-info llvm llvm.org python-any-r1

DESCRIPTION="Polyhedral optimizations for LLVM"
HOMEPAGE="https://llvm.org/"

LICENSE="Apache-2.0-with-LLVM-exceptions UoI-NCSA"
SLOT="$(ver_cut 1)"
KEYWORDS=""
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="~sys-devel/llvm-${PV}"
DEPEND="${RDEPEND}"
BDEPEND="
	test? (
		>=dev-util/cmake-3.16
		$(python_gen_any_dep "~dev-python/lit-${PV}[\${PYTHON_USEDEP}]")
	)"

LLVM_COMPONENTS=( polly llvm clang )
LLVM_TEST_COMPONENTS=( llvm/utils/{lit,unittest} )
llvm.org_set_globals

python_check_deps() {
	has_version -b "dev-python/lit[${PYTHON_USEDEP}]"
}

pkg_setup() {
	LLVM_MAX_SLOT=${PV%%.*} llvm_pkg_setup
	use test && python-any-r1_pkg_setup
}

src_unpack() {
	llvm.org_src_unpack

	# Directory ${WORKDIR}/llvm does not exist with USE="-test",
	# but LLVM_MAIN_SRC_DIR="${WORKDIR}/llvm" is set below,
	# and ${LLVM_MAIN_SRC_DIR}/../libunwind/include is used by build system
	# (lld/MachO/CMakeLists.txt) and is expected to be resolvable
	# to existent directory ${WORKDIR}/libunwind/include.
	mkdir -p "${WORKDIR}/llvm" || die
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=ON
		-DLLVM_POLLY_LINK_INTO_TOOLS=ON
		#-DLLVM_MAIN_SRC_DIR="${WORKDIR}/llvm"
		-DLLVM_INCLUDE_TESTS=$(usex test)
		#-DCMAKE_PREFIX_PATH="${EPREFIX}/usr/lib/llvm/${SLOT}/$(get_libdir)/cmake/llvm"
		#-DLLVM_CMAKE_PATH="${EPREFIX}/usr/lib/llvm/${SLOT}/$(get_libdir)/cmake/llvm"
		#-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr/lib/llvm/${SLOT}"
	)
	use test && mycmakeargs+=(
		-DLLVM_BUILD_TESTS=ON
		-DLLVM_EXTERNAL_LIT="${EPREFIX}/usr/bin/lit"
		-DLLVM_LIT_ARGS="$(get_lit_flags)"
		-DPython3_EXECUTABLE="${PYTHON}"
	)

	cmake_src_configure
}

src_test() {
	local -x LIT_PRESERVES_TMP=1
	cmake_build check-polly
}
