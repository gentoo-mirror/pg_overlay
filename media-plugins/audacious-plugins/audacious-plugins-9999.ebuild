# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PLOCALES="ar be bg ca cmn cs da de el en_GB es es_AR es_MX et fi fr gl hu id_ID it ja ko lt lv ml_IN ms nl pl pt_BR pt_PT ru si sk sl sq sr sr_RS sv ta tr uk zh_CN zh_TW"

MY_P="${P/_/-}"

inherit meson git-r3 plocale
EGIT_REPO_URI="https://github.com/audacious-media-player/audacious-plugins.git"

DESCRIPTION="Lightweight and versatile audio player"
HOMEPAGE="https://audacious-media-player.org/"

LICENSE="GPL-2"
SLOT="0"
IUSE="aac +alsa ampache bs2b cdda cue ffmpeg flac fluidsynth gme http jack
	lame libnotify libsamplerate lirc mms modplug mp3 nls opengl pulseaudio
	scrobbler sdl sid sndfile soxr speedpitch streamtuner vorbis wavpack"
REQUIRED_USE="ampache? ( http ) streamtuner? ( http )"

BDEPEND="
	dev-util/gdbus-codegen
	virtual/pkgconfig
	nls? ( dev-util/intltool )
"
DEPEND="
	app-arch/unzip
	dev-libs/dbus-glib
	dev-libs/glib
	dev-libs/libxml2:2
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtmultimedia:5
	dev-qt/qtwidgets:5
	~media-sound/audacious-${PV}
	aac? ( >=media-libs/faad2-2.7 )
	alsa? ( >=media-libs/alsa-lib-1.0.16 )
	ampache? ( =media-libs/ampache_browser-1* )
	bs2b? ( media-libs/libbs2b )
	cdda? (
		dev-libs/libcdio:=
		dev-libs/libcdio-paranoia:=
		>=media-libs/libcddb-1.2.1
	)
	cue? ( media-libs/libcue:= )
	ffmpeg? ( >=media-video/ffmpeg-0.7.3 )
	flac? (
		>=media-libs/flac-1.2.1-r1
		>=media-libs/libvorbis-1.0
	)
	fluidsynth? ( media-sound/fluidsynth:= )
	http? ( >=net-libs/neon-0.26.4 )
	jack? (
		>=media-libs/bio2jack-0.4
		virtual/jack
	)
	lame? ( media-sound/lame )
	libnotify? ( x11-libs/libnotify )
	libsamplerate? ( media-libs/libsamplerate:= )
	lirc? ( app-misc/lirc )
	mms? ( >=media-libs/libmms-0.3 )
	modplug? ( media-libs/libmodplug )
	mp3? ( >=media-sound/mpg123-1.12.1 )
	opengl? ( dev-qt/qtopengl:5 )
	pulseaudio? ( >=media-sound/pulseaudio-0.9.3 )
	scrobbler? ( net-misc/curl )
	sdl? ( media-libs/libsdl2[sound] )
	sid? ( >=media-libs/libsidplayfp-1.0.0 )
	sndfile? ( >=media-libs/libsndfile-1.0.17-r1 )
	soxr? ( media-libs/soxr )
	speedpitch? ( media-libs/libsamplerate:= )
	streamtuner? ( dev-qt/qtnetwork:5 )
	vorbis? (
		>=media-libs/libogg-1.1.3
		>=media-libs/libvorbis-1.2.0
	)
	wavpack? ( >=media-sound/wavpack-4.50.1-r1 )
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	use mp3 || ewarn "MP3 support is optional, you may want to enable the mp3 USE-flag"
}

src_prepare() {
	default
	if ! use nls; then
		sed -e "/SUBDIRS/s/ po//" -i Makefile || die # bug #512698
	fi

	rm_loc() {
		rm -vf "po/${1}.po" || die
		sed -i s/${1}.po// po/Makefile || die
	}
	plocale_find_changes po "" ".po"
	plocale_for_each_disabled_locale rm_loc

}

src_configure() {
	local emesonargs=(
		-Dmpris2=true
		-Dqt6=true
		-Dqtaudio=true
		-Dsongchange=true
		-Dadplug=false # not packaged
		-Dgtk=false
		-Dopenmpt=false # not packaged
		-Doss4=false
		-Dcoreaudio=false
		-Dsndio=false
		$(meson_use aac)
		$(meson_use alsa)
		$(meson_use ampache)
		$(meson_use bs2b)
		$(meson_use cdda cdaudio)
		$(meson_use cue)
		$(meson_use flac)
		$(meson_use flac filewriter)
		$(meson_use fluidsynth amidiplug)
		$(meson_use gme console)
		$(meson_use http neon)
		$(meson_use jack)
		$(meson_use lame filewriter_mp3)
		$(meson_use libnotify notify)
		$(meson_use libsamplerate resample)
		$(meson_use lirc)
		$(meson_use mms)
		$(meson_use modplug)
		$(meson_use mp3 mpg123)
		$(meson_use nls)
		$(meson_use opengl qtglspectrum)
		$(meson_use pulseaudio pulse)
		$(meson_use scrobbler scrobbler2)
		$(meson_use sdl sdlout)
		$(meson_use sid)
		$(meson_use sndfile)
		$(meson_use soxr)
		$(meson_use speedpitch)
		$(meson_use streamtuner)
		$(meson_use vorbis)
		$(meson_use wavpack)
		$(meson_use ffmpeg ffaudio)
	)

	meson_src_configure
}

src_install() {
	meson_src_install
}
