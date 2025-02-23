# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg

DESCRIPTION="Terminal-based Telegram / WhatsApp client for Linux and macOS"
HOMEPAGE="https://github.com/d99kris/nchat"
SRC_URI="https://github.com/d99kris/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

LANGUAGES="bn cs de es fr hu it ka nl pl pt_BR ru si tr uk"
for lang in ${LANGUAGES}; do
	IUSE+=" +l10n_${lang/_/-}"
done

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
	local mycmakeargs=(
		-DCMAKE_BUILD_TYPE=Release \
		-DCMAKE_CXX_FLAGS="$CXXFLAGS" \
		-DCMAKE_C_FLAGS="$CFLAGS" \
		-DHAS_WHATSAPP=ON -DHAS_TELEGRAM=ON -DHAS_COREDUMP=OFF -DCMAKE_BUILD_TYPE=Release -DHAS_STATICGOLIB=OF
	)
	cmake_src_configure
}
