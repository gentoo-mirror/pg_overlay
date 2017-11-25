# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

# Generate with
# sed 's/^"checksum \([[:graph:]]\+\) \([[:graph:]]\+\) (.*$/\1-\2/' Cargo.lock
CRATES="
advapi32-sys-0.2.0
aho-corasick-0.5.3
aho-corasick-0.6.3
ansi_term-0.9.0
ar-0.3.0
atty-0.2.2
backtrace-0.3.3
backtrace-sys-0.1.14
bitflags-0.7.0
bitflags-0.8.2
bitflags-0.9.1
bitflags-1.0.0
bufstream-0.1.3
cc-1.0.0
cfg-if-0.1.2
clap-2.26.2
cmake-0.1.26
commoncrypto-0.2.0
commoncrypto-sys-0.2.0
conv-0.3.3
core-foundation-0.4.4
core-foundation-sys-0.4.4
crossbeam-0.2.10
crossbeam-0.3.0
crypto-hash-0.3.0
cssparser-0.13.7
cssparser-macros-0.3.0
curl-0.4.8
curl-sys-0.3.15
custom_derive-0.1.7
dbghelp-sys-0.2.0
debug_unreachable-0.1.1
derive-new-0.3.0
diff-0.1.10
docopt-0.8.1
dtoa-0.4.2
enum_primitive-0.1.1
env_logger-0.3.5
env_logger-0.4.3
error-chain-0.11.0
filetime-0.1.12
flate2-0.2.20
fnv-1.0.5
foreign-types-0.2.0
fs2-0.4.2
futf-0.1.3
futures-0.1.16
getopts-0.2.15
git2-0.6.8
git2-curl-0.7.0
glob-0.2.11
globset-0.2.0
hamcrest-0.1.1
handlebars-0.29.1
hex-0.2.0
home-0.3.0
html-diff-0.0.4
html5ever-0.18.0
idna-0.1.4
ignore-0.2.2
itoa-0.3.4
jobserver-0.1.6
jsonrpc-core-7.1.1
kernel32-sys-0.2.2
kuchiki-0.5.1
languageserver-types-0.12.0
lazy_static-0.2.8
libc-0.2.31
libgit2-sys-0.6.15
libssh2-sys-0.2.6
libz-sys-1.0.17
log-0.3.8
lzma-sys-0.1.9
mac-0.1.1
magenta-0.1.1
magenta-sys-0.1.1
markup5ever-0.3.2
matches-0.1.6
mdbook-0.0.26
memchr-0.1.11
memchr-1.0.1
miniz-sys-0.1.10
miow-0.2.1
net2-0.2.31
num-0.1.40
num-bigint-0.1.40
num-complex-0.1.40
num-integer-0.1.35
num-iter-0.1.34
num-rational-0.1.39
num-traits-0.1.40
num_cpus-1.6.2
open-1.2.1
openssl-0.9.21
openssl-probe-0.1.1
openssl-sys-0.9.21
owning_ref-0.3.3
percent-encoding-1.0.0
pest-0.3.3
phf-0.7.21
phf_codegen-0.7.21
phf_generator-0.7.21
phf_shared-0.7.21
pkg-config-0.3.9
precomputed-hash-0.1.0
procedural-masquerade-0.1.2
psapi-sys-0.1.0
pulldown-cmark-0.0.14
pulldown-cmark-0.1.0
quick-error-1.2.1
quote-0.2.3
quote-0.3.15
racer-2.0.10
rand-0.3.16
redox_syscall-0.1.31
regex-0.1.80
regex-0.2.2
regex-syntax-0.3.9
regex-syntax-0.4.1
rls-analysis-0.6.8
rls-data-0.10.0
rls-rustc-0.1.1
rls-span-0.4.0
rls-vfs-0.4.4
rustc-demangle-0.1.5
rustc-serialize-0.3.24
same-file-0.1.3
scoped-tls-0.1.0
scopeguard-0.1.2
selectors-0.18.0
semver-0.8.0
semver-parser-0.7.0
serde-1.0.15
serde_derive-1.0.15
serde_derive_internals-0.16.0
serde_ignored-0.0.4
serde_json-1.0.3
shell-escape-0.1.3
siphasher-0.2.2
smallvec-0.3.3
socket2-0.2.3
stable_deref_trait-1.0.0
string_cache-0.6.2
string_cache_codegen-0.4.0
string_cache_shared-0.3.0
strings-0.1.0
strsim-0.6.0
syn-0.11.11
syn-0.8.7
synom-0.11.3
syntex_errors-0.52.0
syntex_pos-0.52.0
syntex_syntax-0.52.0
tar-0.4.13
tempdir-0.3.5
tendril-0.3.1
term-0.4.6
term_size-0.3.0
termcolor-0.3.3
textwrap-0.8.0
thread-id-2.0.0
thread_local-0.2.7
thread_local-0.3.4
toml-0.2.1
toml-0.4.5
typed-arena-1.3.0
unicode-bidi-0.3.4
unicode-normalization-0.1.5
unicode-segmentation-1.2.0
unicode-width-0.1.4
unicode-xid-0.0.3
unicode-xid-0.0.4
unreachable-0.1.1
unreachable-1.0.0
url-1.5.1
url_serde-0.2.0
userenv-sys-0.2.0
utf-8-0.7.1
utf8-ranges-0.1.3
utf8-ranges-1.0.0
vcpkg-0.2.2
vec_map-0.8.0
void-1.0.2
walkdir-1.0.7
winapi-0.2.8
winapi-build-0.1.1
wincolor-0.1.4
ws2_32-sys-0.2.1
xattr-0.1.11
xz2-0.1.3
yaml-rust-0.3.5
"

inherit bash-completion-r1 cargo versionator

BOOTSTRAP_VERSION="0.$(($(get_version_component_range 2) - 1)).0"

DESCRIPTION="The Rust's package manager"
HOMEPAGE="http://crates.io"
SRC_URI="https://github.com/rust-lang/cargo/archive/${PV}.tar.gz -> ${P}.tar.gz
	$(cargo_crate_uris ${CRATES})
	x86?   (
		https://static.rust-lang.org/dist/cargo-${BOOTSTRAP_VERSION}-i686-unknown-linux-gnu.tar.gz
	)
	amd64? (
		https://static.rust-lang.org/dist/cargo-${BOOTSTRAP_VERSION}-x86_64-unknown-linux-gnu.tar.gz
	)"

RESTRICT="mirror"
LICENSE="|| ( MIT Apache-2.0 )"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"

IUSE="doc libressl"

if [[ ${ARCH} = "amd64" ]]; then
	TRIPLE="x86_64-unknown-linux-gnu"
else
	TRIPLE="i686-unknown-linux-gnu"
fi

COMMON_DEPEND="sys-libs/zlib
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )
	net-libs/libssh2
	net-libs/http-parser"
RDEPEND="${COMMON_DEPEND}
	!dev-util/cargo-bin
	net-misc/curl[ssl]"
DEPEND="${COMMON_DEPEND}
	>=virtual/rust-1.19.0
	dev-util/cmake
	sys-apps/coreutils
	sys-apps/diffutils
	sys-apps/findutils
	sys-apps/sed"

PATCHES=( "${FILESDIR}/${P}-libressl-2.6.2.patch" )

src_configure() {
	# Do nothing
	echo "Configuring cargo..."
}

src_compile() {
	export CARGO_HOME="${ECARGO_HOME}"
	local cargo="${WORKDIR}/cargo-${BOOTSTRAP_VERSION}-${TRIPLE}/cargo/bin/cargo"
	${cargo}  build  --release || die "Failed to build cargo"

	# Building HTML documentation
	use doc && ${cargo} doc
}

src_install() {
	dobin target/release/cargo

	# Install HTML documentation
	use doc && HTML_DOCS=("target/doc")
	einstalldocs

	newbashcomp src/etc/cargo.bashcomp.sh cargo
	insinto /usr/share/zsh/site-functions
	doins src/etc/_cargo
	doman src/etc/man/*
}
