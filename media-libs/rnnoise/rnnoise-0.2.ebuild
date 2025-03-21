# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Recurrent neural network for audio noise reduction"
HOMEPAGE="https://jmvalin.ca/demo/rnnoise/ https://gitlab.xiph.org/xiph/rnnoise"

#COMMIT="1cbdbcf1283499bbb2230a6b0f126eb9b236defd"
SRC_URI="https://gitlab.xiph.org/xiph/${PN}/-/archive/v${PV}/${PN}-v${PV}.tar.bz2"
SRC_URI+=" https://media.xiph.org/${PN}/models/${PN}_data-f56003f.tar.gz"
S="${WORKDIR}/${PN}-v${PV}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE="doc examples"
# NOTE: Documentation currently empty (version 0.4.1_p20210122)

BDEPEND="
	doc? (
		app-text/doxygen
		media-gfx/graphviz
	)
"

PATCHES=(
	#"${FILESDIR}"/${PN}-0.4.1_p20210122-configure-clang16.patch
)

src_unpack() {
	default
	unpack ${PN}_data-f56003f.tar.gz
	mv "${WORKDIR}/src/*" "${S}/src"
}

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_enable doc)
		$(use_enable examples)
		--enable-x86-rtcd
	)
	econf "${myeconfargs[@]}"
}

src_compile() {
	emake
}
src_install() {
	default
	rm "${ED}/usr/share/doc/${PF}/COPYING" || die
	find "${ED}" -name '*.la' -delete || die
	use examples && dobin examples/.libs/rnnoise_demo
}
