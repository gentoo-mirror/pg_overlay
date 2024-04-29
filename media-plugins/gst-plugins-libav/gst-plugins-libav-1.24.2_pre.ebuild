# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PV="${PV%_*}"
P="${PN}-${PV}"

inherit gstreamer-meson poly-c_ebuilds

REAL_PN="gst-libav"
REAL_PV="$(ver_cut 1-3)"
REAL_P="${REAL_PN}-${REAL_PV}"

DESCRIPTION="FFmpeg based gstreamer plugin"
HOMEPAGE="https://gstreamer.freedesktop.org/modules/gst-libav.html"
SRC_URI="https://gstreamer.freedesktop.org/src/${REAL_PN}/${REAL_P}.tar.xz"
S="${WORKDIR}/${REAL_P}"

LICENSE="LGPL-2+"
SLOT="1.0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~mips ~ppc ~ppc64 ~riscv ~x86"

RDEPEND="
	>=dev-libs/glib-2.40.0:2[${MULTILIB_USEDEP}]
	>=media-libs/gstreamer-${PV}_pre:1.0[${MULTILIB_USEDEP}]
	>=media-libs/gst-plugins-base-${PV}_pre:1.0[${MULTILIB_USEDEP}]
	>=media-video/ffmpeg-4:0=[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}"
BDEPEND=""
