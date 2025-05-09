# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit multilib-build poly-c_ebuilds

DESCRIPTION="Meta ebuild to pull in gst plugins for apps"
HOMEPAGE="https://gstreamer.freedesktop.org/"

LICENSE="metapackage"
SLOT="1.0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="aac a52 alsa cdda dts dv dvb dvd ffmpeg flac http jack lame libass libvisual mp3 modplug mpeg ogg opus oss pulseaudio taglib theora v4l vaapi vcd vorbis vpx wavpack X x264"
REQUIRED_USE="opus? ( ogg ) theora? ( ogg ) vorbis? ( ogg )"

RDEPEND="
	>=media-libs/gstreamer-${PV}_pre:1.0[${MULTILIB_USEDEP}]
	>=media-libs/gst-plugins-base-${PV}_pre:1.0[alsa?,ogg?,theora?,vorbis?,X?,${MULTILIB_USEDEP}]
	>=media-libs/gst-plugins-good-${PV}_pre:1.0[${MULTILIB_USEDEP}]
	a52? ( >=media-plugins/gst-plugins-a52dec-${PV}_pre:1.0[${MULTILIB_USEDEP}] )
	aac? ( >=media-plugins/gst-plugins-faad-${PV}_pre:1.0[${MULTILIB_USEDEP}] )
	cdda? ( || (
		>=media-plugins/gst-plugins-cdparanoia-${PV}_pre:1.0[${MULTILIB_USEDEP}]
		>=media-plugins/gst-plugins-cdio-${PV}_pre:1.0[${MULTILIB_USEDEP}] ) )
	dts? ( >=media-plugins/gst-plugins-dts-${PV}_pre:1.0[${MULTILIB_USEDEP}] )
	dv? ( >=media-plugins/gst-plugins-dv-${PV}_pre:1.0[${MULTILIB_USEDEP}] )
	dvb? (
		>=media-plugins/gst-plugins-dvb-${PV}_pre:1.0[${MULTILIB_USEDEP}]
		>=media-libs/gst-plugins-bad-${PV}_pre:1.0[${MULTILIB_USEDEP}] )
	dvd? (
		>=media-libs/gst-plugins-ugly-${PV}_pre:1.0[${MULTILIB_USEDEP}]
		>=media-plugins/gst-plugins-a52dec-${PV}_pre:1.0[${MULTILIB_USEDEP}]
		>=media-plugins/gst-plugins-dvdread-${PV}_pre:1.0[${MULTILIB_USEDEP}]
		>=media-plugins/gst-plugins-mpeg2dec-${PV}_pre:1.0[${MULTILIB_USEDEP}]
		>=media-plugins/gst-plugins-resindvd-${PV}_pre:1.0[${MULTILIB_USEDEP}] )
	ffmpeg? ( >=media-plugins/gst-plugins-libav-${PV}_pre:1.0[${MULTILIB_USEDEP}] )
	flac? ( >=media-plugins/gst-plugins-flac-${PV}_pre:1.0[${MULTILIB_USEDEP}] )
	http? ( >=media-plugins/gst-plugins-soup-${PV}_pre:1.0[${MULTILIB_USEDEP}] )
	jack? ( >=media-plugins/gst-plugins-jack-${PV}_pre:1.0[${MULTILIB_USEDEP}] )
	lame? ( >=media-plugins/gst-plugins-lame-${PV}_pre:1.0[${MULTILIB_USEDEP}] )
	libass? ( >=media-plugins/gst-plugins-assrender-${PV}_pre:1.0[${MULTILIB_USEDEP}] )
	libvisual? ( >=media-plugins/gst-plugins-libvisual-${PV}_pre:1.0[${MULTILIB_USEDEP}] )
	modplug? ( >=media-plugins/gst-plugins-modplug-${PV}_pre:1.0[${MULTILIB_USEDEP}] )
	mp3? (
		>=media-libs/gst-plugins-ugly-${PV}_pre:1.0[${MULTILIB_USEDEP}]
		>=media-plugins/gst-plugins-mpg123-${PV}_pre:1.0[${MULTILIB_USEDEP}] )
	mpeg? ( >=media-plugins/gst-plugins-mpeg2dec-${PV}_pre:1.0[${MULTILIB_USEDEP}] )
	opus? ( >=media-plugins/gst-plugins-opus-${PV}_pre:1.0[${MULTILIB_USEDEP}] )
	oss? ( >=media-plugins/gst-plugins-oss-${PV}_pre:1.0[${MULTILIB_USEDEP}] )
	pulseaudio? ( >=media-plugins/gst-plugins-pulse-${PV}_pre:1.0[${MULTILIB_USEDEP}] )
	taglib? ( >=media-plugins/gst-plugins-taglib-${PV}_pre:1.0[${MULTILIB_USEDEP}] )
	v4l? ( >=media-plugins/gst-plugins-v4l2-${PV}_pre:1.0[${MULTILIB_USEDEP}] )
	vaapi? ( >=media-libs/gst-plugins-bad-${PV}_pre:1.0[vaapi,${MULTILIB_USEDEP}] )
	vcd? (
		>=media-plugins/gst-plugins-mplex-${PV}_pre:1.0[${MULTILIB_USEDEP}]
		>=media-plugins/gst-plugins-mpeg2dec-${PV}_pre:1.0[${MULTILIB_USEDEP}] )
	vpx? ( >=media-plugins/gst-plugins-vpx-${PV}_pre:1.0[${MULTILIB_USEDEP}] )
	wavpack? ( >=media-plugins/gst-plugins-wavpack-${PV}_pre:1.0[${MULTILIB_USEDEP}] )
	x264? ( >=media-plugins/gst-plugins-x264-${PV}_pre:1.0[${MULTILIB_USEDEP}] )
"

# Usage note:
# The idea is that apps depend on this for optional gstreamer plugins.  Then,
# when USE flags change, no app gets rebuilt, and all apps that can make use of
# the new plugin automatically do.

# When adding deps here, make sure the keywords on the gst-plugin are valid.
