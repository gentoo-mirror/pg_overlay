# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

#CMAKE_MAKEFILE_GENERATOR=emake
inherit git-r3

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
	export GOFLAGS="-buildvcs=false"
	local mycmakeargs=(
		-DCMAKE_BUILD_TYPE=Release \
		-DCMAKE_CXX_FLAGS="$CXXFLAGS" \
		-DCMAKE_C_FLAGS="$CFLAGS" \
		-S "${WORKDIR}"/${P} -DHAS_WHATSAPP=ON -DHAS_TELEGRAM=ON -DHAS_COREDUMP=OFF -DCMAKE_BUILD_TYPE=Release -DHAS_STATICGOLIB=OFF -Wno-dev -DTD_ENABLE_LTO=ON -G "Unix Makefiles" -B "${WORKDIR}"/${P}_build
	)
	GOFLAGS="-buildvcs=false" cmake "${mycmakeargs[@]}"
}
src_compile() {
	export GOFLAGS="-buildvcs=false"
	cd "${WORKDIR}"/${P}_build
	echo $(pwd)
	GOFLAGS="-buildvcs=false" make -j25
}
