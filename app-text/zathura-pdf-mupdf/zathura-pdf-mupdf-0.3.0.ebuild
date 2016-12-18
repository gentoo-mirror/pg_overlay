# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils toolchain-funcs

DESCRIPTION="PDF plug-in for zathura"
HOMEPAGE="http://pwmt.org/projects/zathura/"
SRC_URI="http://pwmt.org/projects/zathura/plugins/download/${P}.tar.gz"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="!app-text/zathura-pdf-poppler
	>=app-text/mupdf-1.7a:=
	>=app-text/zathura-0.3.1
	media-libs/jbig2dec:=
	media-libs/openjpeg:2=
	virtual/jpeg:0
	x11-libs/cairo:="
DEPEND="${RDEPEND}
	virtual/pkgconfig"

pkg_setup() {
	myzathuraconf=(
		CC="$(tc-getCC)"
		LD="$(tc-getLD)"
		VERBOSE=1
		DESTDIR="${D}"
		MUPDF_LIB="$($(tc-getPKG_CONFIG) --libs mupdf)"
		OPENSSL_INC="$($(tc-getPKG_CONFIG) --cflags mupdf)"
		OPENSSL_LIB=''
	)
}

src_prepare() {
	eapply \
		"${FILESDIR}"/01-mupdf-1.10.patch \
		"${FILESDIR}"/03-mupdf-1.10.patch \
		"${FILESDIR}"/04-mupdf-1.10.patch \
		"${FILESDIR}"/05-mupdf-1.10.patch \
		"${FILESDIR}"/06-mupdf-1.10.patch
	default
}

src_compile() {
	emake "${myzathuraconf[@]}"
}

src_install() {
	emake "${myzathuraconf[@]}" install
	dodoc AUTHORS
}
