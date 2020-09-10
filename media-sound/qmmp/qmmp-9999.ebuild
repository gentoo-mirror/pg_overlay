# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PLOCALES="bg cs de el en es fi fr gl_ES he hu id it ja kk lt nl pl_PL pt pt_BR ru sk sr_BA sr_RS tr uk_UA zh_CN zh_TW"

inherit cmake xdg l10n
[[ ${PV} = 9999 ]] && inherit subversion

DESCRIPTION="Qt5-based audio player with winamp/xmms skins support"
HOMEPAGE="http://qmmp.ylsoftware.com"
if [[ ${PV} != 9999 ]]; then
	SRC_URI="http://qmmp.ylsoftware.com/files/${P}.tar.bz2
		mirror://sourceforge/${PN}-dev/files/${P}.tar.bz2"
	KEYWORDS="~amd64 ~x86"
else
	ESVN_REPO_URI="svn://svn.code.sf.net/p/${PN}-dev/code/trunk/${PN}"
fi

LICENSE="GPL-2"
SLOT="0"
# KEYWORDS further up
IUSE="aac +alsa analyzer archive bs2b cdda cover crossfade cue curl +dbus enca ffmpeg flac game
gnome jack ladspa lyrics +mad midi mms modplug mplayer musepack notifier opus oss projectm
pulseaudio qsui qtmedia scrobbler shout sid sndfile soxr stereo tray udisks +vorbis wavpack"

REQUIRED_USE="
	gnome? ( dbus )
	shout? ( soxr vorbis )
	udisks? ( dbus )
"

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtsql:5
	dev-qt/qtwidgets:5
	dev-qt/qtx11extras:5
	media-libs/taglib
	x11-libs/libX11
	aac? ( media-libs/faad2 )
	alsa? ( media-libs/alsa-lib )
	archive? ( app-arch/libarchive )
	bs2b? ( media-libs/libbs2b )
	cdda? (
		dev-libs/libcdio:=
		dev-libs/libcdio-paranoia
	)
	curl? ( net-misc/curl )
	dbus? ( dev-qt/qtdbus:5 )
	enca? ( app-i18n/enca )
	ffmpeg? ( media-video/ffmpeg:= )
	flac? ( media-libs/flac )
	game? ( media-libs/game-music-emu )
	jack? (
		media-libs/libsamplerate
		virtual/jack
	)
	ladspa? ( media-plugins/cmt-plugins )
	mad? ( || (
		media-libs/libmad
		media-sound/mpg123
	) )
	midi? ( media-sound/wildmidi )
	mms? ( media-libs/libmms )
	modplug? ( >=media-libs/libmodplug-0.8.4 )
	mplayer? ( media-video/mplayer )
	musepack? ( >=media-sound/musepack-tools-444 )
	opus? ( media-libs/opusfile )
	projectm? (
		dev-qt/qtgui:5[-gles2-only]
		dev-qt/qtopengl:5
		media-libs/libprojectm:=
	)
	pulseaudio? ( >=media-sound/pulseaudio-0.9.9 )
	qtmedia? ( dev-qt/qtmultimedia:5 )
	scrobbler? ( net-misc/curl )
	shout? ( media-libs/libshout )
	sid? ( >=media-libs/libsidplayfp-1.1.0 )
	sndfile? ( media-libs/libsndfile )
	soxr? ( media-libs/soxr )
	udisks? ( sys-fs/udisks:2 )
	vorbis? (
		media-libs/libogg
		media-libs/libvorbis
	)
	wavpack? ( media-sound/wavpack )
"
DEPEND="${RDEPEND}
	dev-qt/linguist-tools:5
"

DOCS=( AUTHORS ChangeLog README )

src_prepare() {
	if has_version dev-libs/libcdio-paranoia; then
		sed -i \
			-e 's:cdio/cdda.h:cdio/paranoia/cdda.h:' \
			src/plugins/Input/cdaudio/decoder_cdaudio.cpp || die
	fi

	rm_locale() {
		rm -fv src/app/desktop-translations/*${1}.desktop.in || die "removing of qmmp_${1}.desktop.in failed"
		rm -fv src/app/translations/${PN}_${1}.ts || die "removing of ${1}.ts failed"
		sed -i "/${PN}_${1}.qm/d" src/app/translations/${PN}_locales.qrc || die "removing of ${1}.ts failed"

		rm -fv src/${PN}ui/translations/lib${PN}ui_${1}.ts || die "removing of ${1}.ts failed"
		sed -i "/lib${PN}ui_${1}.qm/d" src/${PN}ui/translations/lib${PN}ui_locales.qrc || die "removing of ${1}.ts failed"

		rm -fv src/${PN}ui/txt/*${1}.txt || die "removing of ${1}.txt failed"
		sed -i "/${1}.txt/d" src/${PN}ui/txt/txt.qrc || die "removing of ${1}.txt failed"
	}
	l10n_find_plocales_changes src/${PN}ui/translations "lib${PN}ui_" ".ts"
	l10n_for_each_disabled_locale_do rm_locale

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DUSE_AAC="$(usex aac)"
		-DUSE_ALSA="$(usex alsa)"
		-DUSE_ANALYZER="$(usex analyzer)"
		-DUSE_ARCHIVE="$(usex archive)"
		-DUSE_BS2B="$(usex bs2b)"
		-DUSE_CDA="$(usex cdda)"
		-DUSE_COVER="$(usex cover)"
		-DUSE_CROSSFADE="$(usex crossfade)"
		-DUSE_CUE="$(usex cue)"
		-DUSE_CURL="$(usex curl)"
		-DUSE_KDENOTIFY="$(usex dbus)"
		-DUSE_MPRIS="$(usex dbus)"
		-DUSE_ENCA="$(usex enca)"
		-DUSE_FFMPEG="$(usex ffmpeg)"
		-DUSE_FILEWRITER="$(usex vorbis)"
		-DUSE_FLAC="$(usex flac)"
		-DUSE_GME="$(usex game)"
		-DUSE_GNOMEHOTKEY="$(usex gnome)"
		-DUSE_HAL=OFF
		-DUSE_JACK="$(usex jack)"
		-DUSE_LADSPA="$(usex ladspa)"
		-DUSE_LYRICS="$(usex lyrics)"
		-DUSE_MAD="$(usex mad)"
		-DUSE_MIDI="$(usex midi)"
		-DUSE_MMS="$(usex mms)"
		-DUSE_MODPLUG="$(usex modplug)"
		-DUSE_MPLAYER="$(usex mplayer)"
		-DUSE_MPC="$(usex musepack)"
		-DUSE_NOTIFIER="$(usex notifier)"
		-DUSE_OPUS="$(usex opus)"
		-DUSE_OSS="$(usex oss)"
		-DUSE_PROJECTM="$(usex projectm)"
		-DUSE_PULSE="$(usex pulseaudio)"
		-DUSE_QSUI="$(usex qsui)"
		-DUSE_QTMULTIMEDIA="$(usex qtmedia)"
		-DUSE_SCROBBLER="$(usex scrobbler)"
		-DUSE_SHOUT="$(usex shout)"
		-DUSE_SID="$(usex sid)"
		-DUSE_SNDFILE="$(usex sndfile)"
		-DUSE_SOXR="$(usex soxr)"
		-DUSE_STEREO="$(usex stereo)"
		-DUSE_STATICON="$(usex tray)"
		-DUSE_UDISKS2="$(usex udisks)"
		-DUSE_VORBIS="$(usex vorbis)"
		-DUSE_WAVPACK="$(usex wavpack)"
		-DUSE_NULL=OFF
		-DUSE_RGSCAN=OFF
		-DUSE_SB=OFF
	)

	cmake_src_configure
}
