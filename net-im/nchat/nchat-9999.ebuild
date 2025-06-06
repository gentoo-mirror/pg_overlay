# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake git-r3

DESCRIPTION="Terminal-based Telegram / WhatsApp client for Linux and macOS"
HOMEPAGE="https://github.com/d99kris/nchat"
EGIT_REPO_URI="https://github.com/d99kris/${PN}.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-libs/openssl
	dev-db/sqlite
	sys-libs/ncurses
	sys-libs/readline
"
DEPEND="${RDEPEND}
		dev-util/gperf
		sys-apps/file
		sys-apps/help2man
		sys-libs/zlib"

BDEPEND="dev-build/cmake
		dev-lang/go"

src_configure() {
	go-env_set_compile_environment
	local -x GOFLAGS="-p=$(makeopts_jobs) -v -x -buildvcs=false"
	export GOFLAGS="-p=$(makeopts_jobs) -v -x -buildvcs=false"
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=OFF
		-DCMAKE_BUILD_TYPE=None \
		-DCMAKE_CXX_FLAGS="$CXXFLAGS" \
		-DCMAKE_C_FLAGS="$CFLAGS" \
		-DHAS_COREDUMP=OFF \
		-DHAS_STATICGOLIB=OFF
		-DHAS_TELEGRAM=ON \
		-DHAS_WHATSAPP=ON \
		-DTD_ENABLE_LTO=ON \
		-Wno-dev
	)
	cmake_src_configure
}
src_compile() {
	go-env_set_compile_environment
	local -x GOFLAGS="-p=$(makeopts_jobs) -v -x -buildvcs=false"
	export GOFLAGS="-p=$(makeopts_jobs) -v -x -buildvcs=false"
	cmake_src_compile
}
