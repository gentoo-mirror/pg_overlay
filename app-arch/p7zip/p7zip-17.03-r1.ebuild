# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils toolchain-funcs

DESCRIPTION="Port of 7-Zip archiver for Unix"
HOMEPAGE="http://p7zip.sourceforge.net/"
SRC_URI="https://github.com/jinfeihan57/${PN}/archive/v${PV}/${P}.tar.gz"

LICENSE="LGPL-2.1 rar? ( unRAR )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris"
IUSE="doc +pch rar static"

RDEPEND=""
DEPEND="${RDEPEND}"

DOCS=( ChangeLog README TODO )

src_prepare() {
	default
}

src_compile() {
	emake CC=$(tc-getCC) CXX=$(tc-getCXX) all3
}

src_test() {
	emake test test_7z test_7zr
}

src_install() {
	# this wrappers can not be symlinks, p7zip should be called with full path
	make_wrapper 7zr "/usr/$(get_libdir)/${PN}/7zr"
	make_wrapper 7za "/usr/$(get_libdir)/${PN}/7za"
	make_wrapper 7z "/usr/$(get_libdir)/${PN}/7z"

	dobin contrib/gzip-like_CLI_wrapper_for_7z/p7zip
	doman contrib/gzip-like_CLI_wrapper_for_7z/man1/p7zip.1

	exeinto /usr/$(get_libdir)/${PN}
	doexe bin/7z bin/7za bin/7zr bin/7zCon.sfx
	doexe bin/*$(get_modname)
	if use rar; then
		exeinto /usr/$(get_libdir)/${PN}/Codecs/
		doexe bin/Codecs/*$(get_modname)
	fi

	doman man1/7z.1 man1/7za.1 man1/7zr.1

	if use doc; then
		dodoc DOC/*.txt
		docinto html
		dodoc -r DOC/MANUAL/*
	fi
}
