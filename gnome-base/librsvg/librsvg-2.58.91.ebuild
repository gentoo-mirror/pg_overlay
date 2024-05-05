# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{10..12} )

CRATES="
adler@1.0.2
ahash@0.8.11
aho-corasick@1.1.3
android-tzdata@0.1.1
android_system_properties@0.1.5
anes@0.1.6
anstream@0.6.13
anstyle@1.0.6
anstyle-parse@0.2.3
anstyle-query@1.0.2
anstyle-wincon@3.0.2
anyhow@1.0.82
approx@0.5.1
assert_cmd@2.0.13
autocfg@1.2.0
av-data@0.4.2
bit-set@0.5.3
bit-vec@0.6.3
bitflags@1.3.2
bitflags@2.5.0
bitreader@0.3.8
block@0.1.6
bstr@1.9.1
bumpalo@3.16.0
byte-slice-cast@1.2.2
bytemuck@1.15.0
byteorder@1.5.0
bytes@1.6.0
cairo-rs@0.19.4
cairo-sys-rs@0.19.2
cast@0.3.0
cc@1.0.95
cfg-expr@0.15.8
cfg-if@1.0.0
chrono@0.4.38
ciborium@0.2.2
ciborium-io@0.2.2
ciborium-ll@0.2.2
clap@4.4.18
clap_builder@4.4.18
clap_complete@4.4.10
clap_derive@4.4.7
clap_lex@0.6.0
color_quant@1.1.0
colorchoice@1.0.0
const-cstr@0.3.0
core-foundation-sys@0.8.6
crc32fast@1.4.0
criterion@0.5.1
criterion-plot@0.5.0
crossbeam-deque@0.8.5
crossbeam-epoch@0.9.18
crossbeam-utils@0.8.19
crunchy@0.2.2
cssparser@0.31.2
cssparser-macros@0.6.1
data-url@0.3.1
dav1d@0.10.3
dav1d-sys@0.8.2
dcv-color-primitives@0.6.1
deranged@0.3.11
derive_more@0.99.17
difflib@0.4.0
dlib@0.5.2
doc-comment@0.3.3
dtoa@1.0.9
dtoa-short@0.3.4
either@1.11.0
encoding_rs@0.8.34
equivalent@1.0.1
errno@0.3.8
fallible_collections@0.4.9
fastrand@2.0.2
fdeflate@0.3.4
flate2@1.0.29
float-cmp@0.9.0
fnv@1.0.7
form_urlencoded@1.2.1
futf@0.1.5
futures-channel@0.3.30
futures-core@0.3.30
futures-executor@0.3.30
futures-io@0.3.30
futures-macro@0.3.30
futures-task@0.3.30
futures-util@0.3.30
fxhash@0.2.1
gdk-pixbuf@0.19.2
gdk-pixbuf-sys@0.19.0
getrandom@0.2.14
gif@0.13.1
gio@0.19.4
gio-sys@0.19.0
glib@0.19.4
glib-macros@0.19.4
glib-sys@0.19.0
gobject-sys@0.19.0
half@2.4.1
hashbrown@0.13.2
hashbrown@0.14.3
heck@0.4.1
heck@0.5.0
hermit-abi@0.3.9
iana-time-zone@0.1.60
iana-time-zone-haiku@0.1.2
idna@0.5.0
image@0.24.9
indexmap@2.2.6
is-terminal@0.4.12
itertools@0.10.5
itertools@0.12.1
itoa@1.0.11
jpeg-decoder@0.3.1
js-sys@0.3.69
language-tags@0.3.2
lazy_static@1.4.0
libc@0.2.153
libloading@0.8.3
libm@0.2.8
librsvg@2.59.0-beta.1
linked-hash-map@0.5.6
linux-raw-sys@0.4.13
locale_config@0.3.0
lock_api@0.4.12
log@0.4.21
lopdf@0.32.0
mac@0.1.1
malloc_buf@0.0.6
markup5ever@0.11.0
matches@0.1.10
matrixmultiply@0.3.8
md5@0.7.0
memchr@2.7.2
minimal-lexical@0.2.1
miniz_oxide@0.7.2
mp4parse@0.17.0
nalgebra@0.32.5
nalgebra-macros@0.2.1
new_debug_unreachable@1.0.6
nom@7.1.3
normalize-line-endings@0.3.0
num-bigint@0.4.4
num-complex@0.4.5
num-conv@0.1.0
num-derive@0.4.2
num-integer@0.1.46
num-rational@0.4.1
num-traits@0.2.18
objc@0.2.7
objc-foundation@0.1.1
objc_id@0.1.1
once_cell@1.19.0
oorandom@11.1.3
pango@0.19.3
pango-sys@0.19.0
pangocairo@0.19.2
pangocairo-sys@0.19.0
parking_lot@0.12.2
parking_lot_core@0.9.10
paste@1.0.14
percent-encoding@2.3.1
phf@0.10.1
phf@0.11.2
phf_codegen@0.10.0
phf_generator@0.10.0
phf_generator@0.11.2
phf_macros@0.11.2
phf_shared@0.10.0
phf_shared@0.11.2
pin-project-lite@0.2.14
pin-utils@0.1.0
pkg-config@0.3.30
plotters@0.3.5
plotters-backend@0.3.5
plotters-svg@0.3.5
png@0.17.13
powerfmt@0.2.0
ppv-lite86@0.2.17
precomputed-hash@0.1.1
predicates@3.1.0
predicates-core@1.0.6
predicates-tree@1.0.9
proc-macro-crate@3.1.0
proc-macro2@1.0.81
proptest@1.4.0
quick-error@1.2.3
quick-error@2.0.1
quote@1.0.36
rand@0.8.5
rand_chacha@0.3.1
rand_core@0.6.4
rand_xorshift@0.3.0
rawpointer@0.2.1
rayon@1.10.0
rayon-core@1.12.1
rctree@0.6.0
redox_syscall@0.5.1
regex@1.10.4
regex-automata@0.4.6
regex-syntax@0.8.3
rgb@0.8.37
rustix@0.38.34
rusty-fork@0.3.0
ryu@1.0.17
safe_arch@0.7.1
same-file@1.0.6
scopeguard@1.2.0
selectors@0.25.0
serde@1.0.198
serde_derive@1.0.198
serde_json@1.0.116
serde_spanned@0.6.5
servo_arc@0.3.0
simba@0.8.1
simd-adler32@0.3.7
siphasher@0.3.11
slab@0.4.9
smallvec@1.13.2
stable_deref_trait@1.2.0
static_assertions@1.1.0
string_cache@0.8.7
string_cache_codegen@0.5.2
strsim@0.10.0
syn@1.0.109
syn@2.0.60
system-deps@6.2.2
target-lexicon@0.12.14
tempfile@3.10.1
tendril@0.4.3
termtree@0.4.1
thiserror@1.0.59
thiserror-impl@1.0.59
time@0.3.36
time-core@0.1.2
time-macros@0.2.18
tinytemplate@1.2.1
tinyvec@1.6.0
tinyvec_macros@0.1.1
toml@0.8.12
toml_datetime@0.6.5
toml_edit@0.21.1
toml_edit@0.22.12
typenum@1.17.0
unarray@0.1.4
unicode-bidi@0.3.15
unicode-ident@1.0.12
unicode-normalization@0.1.23
url@2.5.0
utf-8@0.7.6
utf8parse@0.2.1
version-compare@0.2.0
version_check@0.9.4
wait-timeout@0.2.0
walkdir@2.5.0
wasi@0.11.0+wasi-snapshot-preview1
wasm-bindgen@0.2.92
wasm-bindgen-backend@0.2.92
wasm-bindgen-macro@0.2.92
wasm-bindgen-macro-support@0.2.92
wasm-bindgen-shared@0.2.92
web-sys@0.3.69
weezl@0.1.8
wide@0.7.16
winapi@0.3.9
winapi-i686-pc-windows-gnu@0.4.0
winapi-util@0.1.8
winapi-x86_64-pc-windows-gnu@0.4.0
windows-core@0.52.0
windows-sys@0.52.0
windows-targets@0.52.5
windows_aarch64_gnullvm@0.52.5
windows_aarch64_msvc@0.52.5
windows_i686_gnu@0.52.5
windows_i686_gnullvm@0.52.5
windows_i686_msvc@0.52.5
windows_x86_64_gnu@0.52.5
windows_x86_64_gnullvm@0.52.5
windows_x86_64_msvc@0.52.5
winnow@0.5.40
winnow@0.6.7
xml5ever@0.17.0
yeslogic-fontconfig-sys@4.0.1
zerocopy@0.7.32
zerocopy-derive@0.7.32
"

inherit cargo gnome2 meson-multilib python-any-r1 rust-toolchain vala

DESCRIPTION="Scalable Vector Graphics (SVG) rendering library"
HOMEPAGE="https://wiki.gnome.org/Projects/LibRsvg https://gitlab.gnome.org/GNOME/librsvg"
SRC_URI+=" ${CARGO_CRATE_URIS}"

LICENSE="LGPL-2.1+"
# Dependent crate licenses
LICENSE+="
	Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD ISC MIT MPL-2.0
	Unicode-DFS-2016
"

SLOT="2"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"

IUSE="gtk-doc +introspection +vala"
REQUIRED_USE="
	gtk-doc? ( introspection )
	vala? ( introspection )
"

RDEPEND="
	>=x11-libs/cairo-1.17.0[glib,svg(+),${MULTILIB_USEDEP}]
	>=media-libs/freetype-2.9:2[${MULTILIB_USEDEP}]
	>=x11-libs/gdk-pixbuf-2.20:2[introspection?,${MULTILIB_USEDEP}]
	>=dev-libs/glib-2.50.0:2[${MULTILIB_USEDEP}]
	>=media-libs/harfbuzz-2.0.0:=[${MULTILIB_USEDEP}]
	>=dev-libs/libxml2-2.9.1-r4:2[${MULTILIB_USEDEP}]
	>=x11-libs/pango-1.50.0[${MULTILIB_USEDEP}]

	introspection? ( >=dev-libs/gobject-introspection-0.10.8:= )
"
DEPEND="${RDEPEND}"
BDEPEND="
	>=virtual/rust-1.70.0[${MULTILIB_USEDEP}]
	x11-libs/gdk-pixbuf
	${PYTHON_DEPS}
	$(python_gen_any_dep 'dev-python/docutils[${PYTHON_USEDEP}]')
	gtk-doc? ( dev-util/gi-docgen )
	virtual/pkgconfig
	vala? ( $(vala_depend) )
	dev-libs/gobject-introspection-common
	dev-libs/vala-common
"
# dev-libs/gobject-introspection-common, dev-libs/vala-common needed by eautoreconf

QA_FLAGS_IGNORED="
	usr/bin/rsvg-convert
	usr/lib.*/librsvg.*
"

src_prepare() {
	use vala && vala_setup
	meson_src_prepare
}

multilib_src_configure() {
	local emesonargs=(
		$(meson_native_use_feature gtk-doc)
		$(meson_native_use_feature introspection)
		$(meson_native_use_feature vala)
		-Dpixbuf=enabled
		-Dpixbuf-loader=enabled
	)
	meson_src_configure
}

multilib_src_install_all() {
	find "${ED}" -name '*.la' -delete || die

	if use gtk-doc; then
		mkdir -p "${ED}"/usr/share/gtk-doc/html/ || die
		mv "${ED}"/usr/share/doc/Rsvg-2.0 "${ED}"/usr/share/gtk-doc/html/ || die
	fi
}

pkg_postinst() {
	multilib_foreach_abi gnome2_pkg_postinst
}

pkg_postrm() {
	multilib_foreach_abi gnome2_pkg_postrm
}
