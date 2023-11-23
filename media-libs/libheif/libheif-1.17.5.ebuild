# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/strukturag/libheif.git"
	inherit git-r3
else
	SRC_URI="https://github.com/strukturag/libheif/releases/download/v${PV}/${P}.tar.gz"
	KEYWORDS="~amd64 ~arm arm64 ~loong ~ppc64 ~riscv ~x86"
fi

DESCRIPTION="ISO/IEC 23008-12:2017 HEIF file format decoder and encoder"
HOMEPAGE="https://github.com/strukturag/libheif"

LICENSE="GPL-3"
SLOT="0/1.12"
IUSE="+aom gdk-pixbuf go rav1e test +threads x265"
REQUIRED_USE="test? ( go )"
RESTRICT="!test? ( test )"

# Bug 865351: tests requires <dev-cpp/catch-3
BDEPEND="
	test? (
		<dev-cpp/catch-3
		dev-lang/go
	)
"
DEPEND="
	media-libs/dav1d:=
	media-libs/libde265:=
	media-libs/libpng:0=
	sys-libs/zlib:=
	media-libs/libjpeg-turbo:0=
	aom? ( >=media-libs/libaom-2.0.0:= )
	gdk-pixbuf? ( x11-libs/gdk-pixbuf )
	go? ( dev-lang/go )
	rav1e? ( media-video/rav1e:= )
	x265? ( media-libs/x265:= )"
RDEPEND="${DEPEND}"

src_prepare() {
	default

	if use test ; then
		# bug 865351
		rm tests/catch.hpp || die
		ln -s "${ESYSROOT}"/usr/include/catch2/catch.hpp tests/catch.hpp || die
	fi

	cmake_src_prepare
}

src_configure() {
	export GO111MODULE=auto
	local mycmakeargs=(
		--preset=release-noplugins
		#-DENABLE_PLUGIN_LOADING=OFF
		-DWITH_LIBDE265=ON
		-DWITH_AOM_DECODER=$(usex aom)
		-DWITH_GDK_PIXBUF=$(usex gdk-pixbuf)
		-DWITH_RAV1E=$(usex rav1e)
		-DENABLE_MULTITHREADING_SUPPORT=$(usex threads)
		-DENABLE_PARALLEL_TILE_DECODING=$(usex threads)
		-DWITH_REDUCED_VISIBILITY=$(usex threads)
		-DBUILD_TESTING=$(usex test)
		-DWITH_X265=$(usex x265)
	)
	cmake_src_configure
}
