# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
GST_ORG_MODULE=gst-plugins-good

PV="${PV%_*}"
P="${PN}-${PV}"

inherit gstreamer-meson poly-c_ebuilds

DESCRIPTION="FLAC encoder/decoder/tagger plugin for GStreamer"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"

RDEPEND=">=media-libs/flac-1.4.1-r5:=[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${GST_ORG_MODULE}-${PV}"
