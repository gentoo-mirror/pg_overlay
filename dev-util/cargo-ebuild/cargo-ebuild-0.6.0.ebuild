# Copyright 2017-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	aho-corasick@1.0.3
	ansi_term@0.12.1
	anyhow@1.0.72
	atty@0.2.14
	autocfg@1.1.0
	bitflags@1.3.2
	block-buffer@0.10.4
	bstr@1.6.0
	camino@1.1.6
	cargo-lock@8.0.3
	cargo-platform@0.1.3
	cargo_metadata@0.15.4
	cc@1.0.82
	cfg-if@1.0.0
	clap@2.34.0
	cpufeatures@0.2.9
	crates-index@0.19.13
	crossbeam-channel@0.5.8
	crossbeam-deque@0.8.3
	crossbeam-epoch@0.9.15
	crossbeam-utils@0.8.16
	crypto-common@0.1.6
	cvss@2.0.0
	deranged@0.3.7
	digest@0.10.7
	either@1.9.0
	equivalent@1.0.1
	fnv@1.0.7
	form_urlencoded@1.2.0
	fs-err@2.9.0
	generic-array@0.14.7
	git2@0.16.1
	globset@0.4.13
	globwalk@0.8.1
	hashbrown@0.14.0
	heck@0.3.3
	hermit-abi@0.1.19
	hermit-abi@0.3.2
	hex@0.4.3
	home@0.5.5
	humantime@2.1.0
	humantime-serde@1.1.1
	idna@0.4.0
	ignore@0.4.20
	indexmap@2.0.0
	itertools@0.10.5
	itoa@1.0.9
	jobserver@0.1.26
	lazy_static@1.4.0
	libc@0.2.147
	libgit2-sys@0.14.2+1.5.1
	libssh2-sys@0.2.23
	libz-sys@1.1.12
	log@0.4.19
	memchr@2.5.0
	memoffset@0.9.0
	num_cpus@1.16.0
	once_cell@1.18.0
	openssl-probe@0.1.5
	openssl-sys@0.9.91
	percent-encoding@2.3.0
	pest@2.7.2
	pest_derive@2.7.2
	pest_generator@2.7.2
	pest_meta@2.7.2
	phf@0.11.2
	phf_generator@0.11.2
	phf_macros@0.11.2
	phf_shared@0.11.2
	pkg-config@0.3.27
	platforms@3.0.2
	proc-macro-error@1.0.4
	proc-macro-error-attr@1.0.4
	proc-macro2@1.0.66
	quote@1.0.32
	rand@0.8.5
	rand_core@0.6.4
	rayon@1.7.0
	rayon-core@1.11.0
	regex@1.9.3
	regex-automata@0.3.6
	regex-syntax@0.7.4
	rustc-hash@1.1.0
	rustsec@0.26.5
	ryu@1.0.15
	same-file@1.0.6
	scopeguard@1.2.0
	semver@1.0.18
	serde@1.0.183
	serde_derive@1.0.183
	serde_json@1.0.104
	serde_spanned@0.6.3
	sha2@0.10.7
	siphasher@0.3.10
	smol_str@0.2.0
	strsim@0.8.0
	structopt@0.3.26
	structopt-derive@0.4.18
	syn@1.0.109
	syn@2.0.28
	tera@1.19.0
	textwrap@0.11.0
	thiserror@1.0.44
	thiserror-impl@1.0.44
	thread_local@1.1.4
	time@0.3.25
	time-core@0.1.1
	tinyvec@1.6.0
	tinyvec_macros@0.1.1
	toml@0.5.11
	toml@0.7.6
	toml_datetime@0.6.3
	toml_edit@0.19.14
	typenum@1.16.0
	ucd-trie@0.1.6
	unic-char-property@0.9.0
	unic-char-range@0.9.0
	unic-common@0.9.0
	unic-segment@0.9.0
	unic-ucd-segment@0.9.0
	unic-ucd-version@0.9.0
	unicode-bidi@0.3.13
	unicode-ident@1.0.11
	unicode-normalization@0.1.22
	unicode-segmentation@1.10.1
	unicode-width@0.1.10
	url@2.4.0
	vcpkg@0.2.15
	vec_map@0.8.2
	version_check@0.9.4
	walkdir@2.3.3
	winapi@0.3.9
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-util@0.1.5
	winapi-x86_64-pc-windows-gnu@0.4.0
	windows-sys@0.48.0
	windows-targets@0.48.1
	windows_aarch64_gnullvm@0.48.0
	windows_aarch64_msvc@0.48.0
	windows_i686_gnu@0.48.0
	windows_i686_msvc@0.48.0
	windows_x86_64_gnu@0.48.0
	windows_x86_64_gnullvm@0.48.0
	windows_x86_64_msvc@0.48.0
	winnow@0.5.4
"

inherit cargo

DESCRIPTION="Generates an ebuild for a package using the in-tree eclasses."
# Double check the homepage as the cargo_metadata crate
# does not provide this value so instead repository is used
HOMEPAGE="https://github.com/gentoo/cargo-ebuild"
SRC_URI="https://gitweb.gentoo.org/proj/${PN}.git/snapshot/${PN}-0.5.4.tar.bz2
	${CARGO_CRATE_URIS}"

# License set may be more restrictive as OR is not respected
# use cargo-license for a more accurate license picture
LICENSE="Apache-2.0 Boost-1.0 MIT Unicode-DFS-2016 Unlicense ZLIB"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

# rust does not use *FLAGS from make.conf, silence portage warning
# update with proper path to binaries this crate installs, omit leading /
QA_FLAGS_IGNORED="usr/bin/${PN}"

PATCHES=(
	"${FILESDIR}/36.patch"
)

S=${WORKDIR}/${PN}-0.5.4

src_configure() {
	export LIBGIT2_SYS_USE_PKG_CONFIG=1 LIBSSH2_SYS_USE_PKG_CONFIG=1 PKG_CONFIG_ALLOW_CROSS=1
	cargo_src_configure
}

src_install() {
	cargo_src_install
	einstalldocs
}