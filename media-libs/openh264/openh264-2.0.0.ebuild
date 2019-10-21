# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib-minimal

DESCRIPTION="OpenH264 is a codec library which supports H.264 encoding and decoding. It is suitable for use in real time applications such as WebRTC."
HOMEPAGE="http://www.openh264.org/"
SRC_URI="https://github.com/cisco/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ppc ppc64 sparc x86"
IUSE="utils"

RESTRICT="bindist"

RDEPEND="!<www-client/firefox-${MOZVER}"
DEPEND="
	abi_x86_32? ( dev-lang/nasm )
	abi_x86_64? ( dev-lang/nasm )"

DOCS=( LICENSE CONTRIBUTORS README.md )

src_prepare() {
	default
	eapply "${FILESDIR}"/${PN}-1.7.0-pkgconfig-pathfix.patch
	multilib_copy_sources
}

emakecmd() {
	CC="$(tc-getCC)" CXX="$(tc-getCXX)" LD="$(tc-getLD)" \
	emake V=Yes CFLAGS_M32="" CFLAGS_M64="" CFLAGS_OPT="" \
		PREFIX="${EPREFIX}/usr" \
		LIBDIR_NAME="$(get_libdir)" \
		SHAREDLIB_DIR="${EPREFIX}/usr/$(get_libdir)" \
		INCLUDES_DIR="${EPREFIX}/usr/include/${PN}" \
		$@
}

multilib_src_compile() {
	local mybits="ENABLE64BIT=No"
	case "${ABI}" in
		s390x|alpha|*64) mybits="ENABLE64BIT=Yes";;
	esac

	emakecmd ${mybits} ${tgt}
}

multilib_src_install() {
	emakecmd DESTDIR="${D}" install-shared

	if use utils ; then
		newbin h264enc openh264enc
		newbin h264dec openh264dec
	fi
}

pkg_postinst() {
	if use utils; then
		elog "Utilities h264enc and h264dec are installed as openh264enc and openh264dec"
		elog "to avoid file collisions with media-video/h264enc"
		elog ""
	fi
}
