# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_ECLASS=cmake
PYTHON_COMPAT=( python3_{9..11} )
inherit cmake linux-info llvm llvm.org python-any-r1

DESCRIPTION="Polyhedral optimizations for LLVM"
HOMEPAGE="https://llvm.org/"

LICENSE="Apache-2.0-with-LLVM-exceptions UoI-NCSA"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="~sys-devel/llvm-${PV}"
DEPEND="${RDEPEND}"
BDEPEND="
	test? (
		>=dev-util/cmake-3.16
		$(python_gen_any_dep "~dev-python/lit-${PV}[\${PYTHON_USEDEP}]")
	)"

LLVM_COMPONENTS=( polly llvm cmake )
LLVM_TEST_COMPONENTS=( llvm/utils/{lit,unittest} )
llvm.org_set_globals

PATCHES=( "${FILESDIR}/polly.patch" )

python_check_deps() {
	has_version -b "dev-python/lit[${PYTHON_USEDEP}]"
}

pkg_setup() {
	LLVM_MAX_SLOT=${PV%%.*} llvm_pkg_setup
	use test && python-any-r1_pkg_setup
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=OFF
		#-DLLVM_LIBDIR_SUFFIX=${libdir#lib}
		-DLLVM_LINK_LLVM_DYLIB=ON
		-DLLVM_POLLY_LINK_INTO_TOOLS=ON
		-DLLVM_INCLUDE_TESTS=$(usex test)
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr/lib/llvm/${LLVM_MAJOR}"
		-DPOLLY_INSTALL_PACKAGE_DIR="${EPREFIX}/usr/lib/llvm/${LLVM_MAJOR}/${PN}"
	)
	use test && mycmakeargs+=(
		-DLLVM_BUILD_TESTS=ON
		-DLLVM_MAIN_SRC_DIR="${WORKDIR}/llvm"
		-DLLVM_EXTERNAL_LIT="${EPREFIX}/usr/bin/lit"
		-DLLVM_LIT_ARGS="$(get_lit_flags)"
		-DPython3_EXECUTABLE="${PYTHON}"
	)

	cmake_src_configure
}

src_install() {
	default
	cmake_src_install
	#mv "${D}/polly" "${D}/usr/lib/llvm/${LLVM_MAJOR}/$(get_libdir)/cmake"
}

src_test() {
	local -x LIT_PRESERVES_TMP=1
	cmake_build check-polly
}
