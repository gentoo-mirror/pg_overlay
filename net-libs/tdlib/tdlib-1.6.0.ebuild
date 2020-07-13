# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Cross-platform library for building Telegram clients"
HOMEPAGE="https://core.telegram.org/tdlib https://github.com/tdlib/td"

if [[ ${PV} == 9999 ]]
then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/${PN}/td.git"
	EGIT_SUBMODULES=()
	KEYWORDS=""
else
	SRC_URI="https://github.com/${PN}/td/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
	S=${WORKDIR}/td-${PV}
fi

LICENSE="Boost-1.0"
SLOT="0"
IUSE="doc java test"

BDEPEND="
	dev-util/gperf
	doc? ( app-doc/doxygen )
	java? ( virtual/jdk )
"
RDEPEND="
	dev-libs/openssl
	sys-libs/zlib
"
DEPEND="${RDEPEND}"

src_prepare() {
	sed 's/tdnet/tdcore tdnet/' -i benchmark/CMakeLists.txt
	sed '/target_link_libraries(tdjson_private/s/tdutils/tdutils tdcore/' -i CMakeLists.txt

	if use test
	then
		sed -i -e '/run_all_tests/! {/all_tests/d}' \
			test/CMakeLists.txt || die
	else
		sed -i \
			-e '/enable_testing/d' \
			-e '/add_subdirectory.*test/d' \
			CMakeLists.txt || die
	fi

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DTD_ENABLE_DOTNET=OFF
		-DTD_ENABLE_JNI=$(usex java)
		-DTD_ENABLE_LTO=ON
	)

	cmake_src_configure
}

src_compile() {
	cmake_src_compile

	if use doc
	then
		doxygen Doxyfile || die
	fi
}

src_install() {
	cmake_src_install

	use doc && local HTML_DOCS=( docs/html/. )
	einstalldocs
}
