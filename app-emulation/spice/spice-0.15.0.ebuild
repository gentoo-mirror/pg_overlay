# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{9..11} )
inherit meson python-any-r1 readme.gentoo-r1 xdg-utils

DESCRIPTION="SPICE server"
HOMEPAGE="https://www.spice-space.org/"
SRC_URI="https://www.spice-space.org/download/releases/spice-server/${P}.tar.bz2"
SRC_URI+=" https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/${P}-pthread-c5fe3df1.patch.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64"
IUSE="gstreamer lz4 opus sasl smartcard static-libs test"

RESTRICT="!test? ( test )"

# the libspice-server only uses the headers of libcacard
RDEPEND="
	dev-lang/orc[static-libs(+)?]
	>=dev-libs/glib-2.22:2[static-libs(+)?]
	opus? ( media-libs/opus[static-libs(+)?] )
	sys-libs/zlib[static-libs(+)?]
	virtual/jpeg:0=[static-libs(+)?]
	>=x11-libs/pixman-0.17.7[static-libs(+)?]
	dev-libs/openssl:0=[static-libs(+)?]
	lz4? ( app-arch/lz4:0=[static-libs(+)?] )
	smartcard? ( >=app-emulation/libcacard-2.5.1 )
	sasl? ( dev-libs/cyrus-sasl[static-libs(+)?] )
	gstreamer? (
		media-libs/gstreamer:1.0
		media-libs/gst-plugins-base:1.0
	)"
DEPEND="${RDEPEND}
	>=app-emulation/spice-protocol-0.14.3
	smartcard? ( app-emulation/qemu[smartcard] )
	test? ( net-libs/glib-networking )"
BDEPEND="${PYTHON_DEPS}
	virtual/pkgconfig
	$(python_gen_any_dep '
		>=dev-python/pyparsing-1.5.6-r2[${PYTHON_USEDEP}]
		dev-python/six[${PYTHON_USEDEP}]
	')"

DOCS=(
	AUTHORS
	CHANGELOG.md
	README
)

PATCHES=(
	"${WORKDIR}"/${P}-pthread-c5fe3df1.patch
)

python_check_deps() {
	has_version -b ">=dev-python/pyparsing-1.5.6-r2[${PYTHON_USEDEP}]"
	has_version -b "dev-python/six[${PYTHON_USEDEP}]"
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && python-any-r1_pkg_setup
}

src_prepare() {
	default
	sed -i '/doxygen/d' meson.build
}

src_configure() {
	# Prevent sandbox violations, bug #586560
	# https://bugzilla.gnome.org/show_bug.cgi?id=744134
	# https://bugzilla.gnome.org/show_bug.cgi?id=744135
	use gstreamer && addpredict /dev

	xdg_environment_reset

	local emesonargs=(
		-Ddefault_library=$(usex static-libs both shared)
		-Dgstreamer=$(usex gstreamer 1.0 no)
		$(meson_use lz4)
		$(meson_use sasl)
		$(meson_feature opus)
		$(meson_feature smartcard)
		$(meson_use test tests)
		-Dmanual=false
		-Dtests=false
	)
	meson_src_configure
}

src_compile() {
	# Prevent sandbox violations, bug #586560
	# https://bugzilla.gnome.org/show_bug.cgi?id=744134
	# https://bugzilla.gnome.org/show_bug.cgi?id=744135
	use gstreamer && addpredict /dev

	meson_src_compile
}

src_install() {
	meson_src_install
	einstalldocs
	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
}
