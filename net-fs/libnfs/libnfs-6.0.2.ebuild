# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://github.com/sahlberg/${PN}.git"
	inherit git-r3
else
	SRC_URI="https://github.com/sahlberg/${PN}/archive/${P}.tar.gz"
	KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 x86"
	S="${WORKDIR}"/${PN}-${P}
fi

DESCRIPTION="Client library for accessing NFS shares over a network"
HOMEPAGE="https://github.com/sahlberg/libnfs"

LICENSE="LGPL-2.1 GPL-3"
SLOT="0/16" # sub-slot matches SONAME major
IUSE="examples static-libs utils"

# net-libs/rpcsvc-proto for rpcgen called in build system
BDEPEND="
	net-libs/rpcsvc-proto
	virtual/pkgconfig
"

PATCHES=( ${FILESDIR}/0d4b18109630751a0e646376c3565f0befeed0fa.patch
			${FILESDIR}/d205297a10bf8d7f8846bf42f0ed618543a561a9.patch
		)

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--disable-werror
		--without-libkrb5
		$(use_enable static-libs static)
		$(use_enable utils)
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default

	if use examples; then
		# --enable-examples configure switch just compiles them
		# better install sources instead
		exeinto /usr/share/doc/${PF}/examples/
		for program in $(grep PROGRAMS examples/Makefile.am | cut -d= -f2); do
			doexe examples/${program}.c
		done
	fi

	find "${ED}" -name "*.la" -delete || die
}
