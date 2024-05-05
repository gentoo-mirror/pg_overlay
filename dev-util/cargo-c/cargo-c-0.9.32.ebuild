# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Only bother defining this if the github tarball doesn't work!
# Otherwise just comment it out and things should Just Work (TM).
#MY_P="${P}+cargo-{CARGO_V}"

CRATES="
"

inherit cargo

DESCRIPTION="Helper program to build and install c-like libraries"
HOMEPAGE="https://github.com/lu-zero/cargo-c"
if [[ -z ${MY_P} ]] ; then
	SRC_URI="https://github.com/lu-zero/cargo-c/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
else
	S="${WORKDIR}/${MY_P}"
fi

SRC_URI+=" ${CARGO_CRATE_URIS}"

LICENSE="MIT"
# Dependent crate licenses
LICENSE+=" Apache-2.0 BSD ISC MIT MPL-2.0 MPL-2.0 Unicode-DFS-2016"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

RDEPEND=">=dev-libs/libgit2-1.7:=
	dev-libs/openssl:=
	net-libs/libssh2:=
	net-misc/curl[ssl]
	sys-libs/zlib"
DEPEND="${RDEPEND}"
BDEPEND=">=virtual/rust-1.75.0"

QA_FLAGS_IGNORED="usr/bin/cargo-capi usr/bin/cargo-cbuild usr/bin/cargo-ctest usr/bin/cargo-cinstall"

src_unpack() {
	cargo_src_unpack

	if [[ -n ${MY_P} ]] ; then
		tar -xf "${DISTDIR}"/"${MY_P}.crate" -C "${WORKDIR}" || die
	fi

	# libgit2-sys unnecessarily(?) requests <libgit2-1.8.0, bump to 2 for now
	sed -e '/range_version/s/1\.8\.0/2/' \
		-i "${ECARGO_VENDOR}"/libgit2-sys-0.16.2+1.7.2/build.rs || die
}

src_configure() {
	# Some crates will auto-build and statically link C libraries(!)
	# Tracker bug #709568
	export LIBSSH2_SYS_USE_PKG_CONFIG=1
	export LIBGIT2_NO_VENDOR=1
	export PKG_CONFIG_ALLOW_CROSS=1
}
