# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Cross-platform library for building Telegram clients"
HOMEPAGE="https://github.com/tdlib/td"

TDLIB_COMMIT="34c390f9afe074071e01c623e42adfbd17e350ab"
SRC_URI="https://github.com/tdlib/td/archive/${TDLIB_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/td-${TDLIB_COMMIT}"

LICENSE="Boost-1.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv"
IUSE="cli doc debug java lto low-ram test"

BDEPEND="
	dev-util/gperf
	doc? ( app-text/doxygen )
	java? ( virtual/jdk:= )
	low-ram? ( dev-lang/php[cli] )
"
RDEPEND="
	dev-libs/openssl:0=
	sys-libs/zlib
"

# According to documentation, LTO breaks build of java bindings. But actually it builds fine for me.
REQUIRED_USE="?? ( lto java )"

DOCS=( README.md )

RESTRICT="!test? ( test )"

src_prepare() {
	if use test; then
		sed -i -e '/run_all_tests/! {/all_tests/d}' \
			test/CMakeLists.txt || die
	else
		sed -i \
			-e '/enable_testing/d' \
			-e '/add_subdirectory.*test/d' \
			CMakeLists.txt || die
	fi
	# user reported that for now, tests segfaults on glibc and musl

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_BUILD_TYPE=$(usex debug Debug Release)
		-DCMAKE_INSTALL_PREFIX=/usr
		-DTD_ENABLE_JNI=$(usex java ON OFF)
		-DTD_ENABLE_LTO=$(usex lto ON OFF)

		# According to TDLib build instructions, DOTNET=ON is only needed
		# for using tdlib from C# under Windows through C++/CLI
		-DTD_ENABLE_DOTNET=OFF

		# -DTD_EXPERIMENTAL_WATCH_OS=$(usex watch-os ON OFF) # Requires "Foundation" library. TBD.
		# -DEMSCRIPTEN=$(usex javascript ON OFF) # Somehow makes GCC to stop seeing pthreads.h
		-DTDACTOR_ENABLE_INSTALL=OFF
		-DTDE2E_ENABLE_INSTALL=ON
		-DTDNET_ENABLE_INSTALL=OFF
	)
	cmake_src_configure

	if use low-ram; then
		cmake --build "${BUILD_DIR}" --target prepare_cross_compiling || die
		php SplitSource.php || die
	fi
}

src_compile() {
	cmake_src_compile

	if use doc; then
		doxygen Doxyfile || die "Could not build docs with doxygen"
	fi
}

src_install() {
	use low-ram && php SplitSource.php --undo

	cmake_src_install

	# TODO: USE=java installs crap into /usr/bin:
	# /usr/bin/td/generate/scheme/td_api.tlo
	# /usr/bin/td/generate/scheme/td_api.tl
	# /usr/bin/td/generate/TlDocumentationGenerator.php
	# /usr/bin/td/generate/JavadocTlDocumentationGenerator.php
	# Need to fix this

	use cli && dobin "${BUILD_DIR}"/tg_cli

	use doc && local HTML_DOCS=( docs/html/. )
	einstalldocs

	# kludge for telegram-desktop
	insinto /usr/include/td/e2e
	doins tde2e/td/e2e/*.h
}
