# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic meson multilib-minimal pax-utils

DESCRIPTION="The Oil Runtime Compiler, a just-in-time compiler for array operations"
HOMEPAGE="https://gstreamer.freedesktop.org/"
SRC_URI="https://gstreamer.freedesktop.org/src/${PN}/${P}.tar.xz"

LICENSE="BSD BSD-2"
SLOT="0"
KEYWORDS="amd64 arm ~arm64 ~hppa ppc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="examples pax_kernel static-libs"

RDEPEND=""
DEPEND="${RDEPEND}
	app-arch/xz-utils
	>=dev-util/gtk-doc-am-1.12
"

DOCS=( README RELEASE )

multilib_src_configure() {
	# any optimisation on PPC/Darwin yields in a complaint from the assembler
	# Parameter error: r0 not allowed for parameter %lu (code as 0 not r0)
	# the same for Intel/Darwin, although the error message there is different
	# but along the same lines
	[[ ${CHOST} == *-darwin* ]] && filter-flags -O*

	# FIXME: handle backends per arch? What about cross-compiling for the other arches?
	local emesonargs=(
		-Dorc-backend=all
		-Dgtk_doc="$(multilib_native_usex gtk-doc true false)"
		-Dtests="$(multilib_native_usex test true false)"
		-Dorc-test="$(multilib_native_usex test true false)"
		-Dbenchmarks="$(multilib_native_usex test true false)"
		-Dexapmles="$(multilib_native_usex test true false)"
		-Dtools="$(multilib_native_usex test true false)"
		)
	meson_src_configure
}

muiltilib_src_compile() {
	meson_src_compile
}

multilib_src_install() {
	meson_src_install
	prune_libtool_files --all

	if use pax_kernel; then
		pax-mark m "${ED}"usr/bin/orc-bugreport
		pax-mark m "${ED}"usr/bin/orcc
		pax-mark m "${ED}"usr/$(get_libdir)/liborc*.so*
	fi
}

pkg_postinst() {
	if use pax_kernel; then
		ewarn "Please run \"revdep-pax\" after installation".
		ewarn "It's provided by sys-apps/elfix."
	fi
}
