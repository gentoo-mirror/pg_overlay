# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake
DESCRIPTION="WHATWG-compliant and fast URL parser written in modern C++"
HOMEPAGE="https://github.com/ada-url/ada"
SRC_URI="https://github.com/ada-url/ada/archive/refs/tags/v2.9.0.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0 MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~loong ~ppc64 ~riscv"

# src_prepare() {
# 	sed -r \
# 		-e "/^set\(CMAKE_INSTALL_DOCDIR/s@doc/[\$]\{PROJECT_NAME\}[\$]\{LIBIIO_VERSION_MAJOR\}-doc@doc/${PF:-9999}@g" \
# 		-i "${S}/CMakeLists.txt"
# 	use examples && (
# 		sed -r \
# 			-e '/#include <cdk\/cdk.h>/s@cdk/@@' \
# 			-i "${S}/examples/iio-monitor.c"
# 		sed -r \
# 			-e '/^iio-monitor:/{N;s@(-lncurses)([^[:alnum:]]?)@\1w -ltinfow\2@;s@(-lcdk)([^[:alnum:]]?)@\1w\2@}' \
# 			-i "${S}/examples/Makefile"
# 	)
# 	cmake_src_prepare
# #	multilib_copy_sources
# }
#
# #multilib_src_configure() {
src_configure() {
	local mycmakeargs=(
		-DADA_BENCHMARKS=OFF
		-DADA_COVERAGE=OFF
		-DADA_DEVELOPMENT_CHECKS=OFF
		-DADA_LOGGING=OFF
		-DADA_SANITIZE=OFF
		-DADA_SANITIZE_BOUNDS_STRICT=OFF
		-DADA_SANITIZE_UNDEFINED=OFF
		-DADA_TESTING=OFF
		-DADA_TOOLS=OFF
		-DBUILD_TESTING=OFF
	)
	cmake_src_configure
}

# #multilib_src_compile() {
# src_compile() {
# 	cmake_src_compile
# 	use examples && {
# 		emake -C examples
# 	}
# }
#
# #multilib_src_install() {
# src_install() {
# 	cmake_src_install
#
# 	use doc && {
# 		HTML_DOCS=( "${BUILD_DIR}/html/" )
# 	}
#
# 	use examples && (
# 		dobin examples/{iio-monitor,{dummy,ad93{6,7}1}-iiostream}
# 	)
# }
