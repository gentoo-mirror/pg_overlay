# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PLOCALES="bg cs de el en es fi fr gl_ES he hu id it ja kk ko lt nl pl_PL pt pt_BR ru sk sr_BA sr_RS tr uk_UA zh_CN zh_TW"

inherit cmake optfeature xdg

DESCRIPTION="Qt-based audio player with winamp/xmms skins support"
HOMEPAGE="https://qmmp.ylsoftware.com"
if [[ ${PV} != *9999* ]]; then
	SRC_URI="
		https://qmmp.ylsoftware.com/files/qmmp/$(ver_cut 1-2)/${P}.tar.bz2
		https://downloads.sourceforge.net/project/qmmp-dev/qmmp/$(ver_cut 1-2)/${P}.tar.bz2
	"
	KEYWORDS="~amd64 ~x86"
else
	inherit subversion
	ESVN_REPO_URI="svn://svn.code.sf.net/p/${PN}-dev/code/trunk/${PN}"
fi

LICENSE="CC-BY-SA-4.0 GPL-2+" # default skin & source code
SLOT="0"
# KEYWORDS further up
# NOTE: moving mms to qmmp-plugin-pack soon:
# https://sourceforge.net/p/qmmp-dev/code/12062/
IUSE="aac +alsa archive bs2b cdda cddb curl +dbus doc enca
ffmpeg flac game gnome jack ladspa libxmp +mad midi mms mpg123
mplayer musepack opus pipewire projectm pulseaudio qtmedia
shout sid sndfile soxr +vorbis wavpack
analyzer cover crossfade cue lyrics notifier oss qsui scrobbler stereo tray udisks
"
REQUIRED_USE="
	cddb? ( cdda )
	gnome? ( dbus )
	jack? ( soxr )
	shout? ( soxr vorbis )
"
# qtbase[sql] to help autounmask of sqlite
RDEPEND="
	dev-qt/qtbase:6[dbus?,gui,network,sql,widgets]
	media-libs/taglib:=
		aac? ( media-libs/faad2 )
	alsa? ( media-libs/alsa-lib )
	archive? ( app-arch/libarchive )
	bs2b? ( media-libs/libbs2b )
	cdda? (
		dev-libs/libcdio:=
		dev-libs/libcdio-paranoia:=
	)
	cddb? ( media-libs/libcddb )
	curl? ( net-misc/curl )
	enca? ( app-i18n/enca )
	ffmpeg? ( media-video/ffmpeg:= )
	flac? ( media-libs/flac:= )
	game? ( media-libs/game-music-emu )
	jack? (	virtual/jack )
	ladspa? ( media-plugins/cmt-plugins )
	libxmp? ( media-libs/libxmp )
	mad? ( media-libs/libmad )
	midi? ( media-sound/wildmidi )
	mms? ( media-libs/libmms )
	mpg123? ( media-sound/mpg123-base )
	mplayer? ( media-video/mplayer )
	musepack? ( >=media-sound/musepack-tools-444 )
	opus? ( media-libs/opusfile )
	pipewire? ( media-video/pipewire:= )
	projectm? (
		dev-qt/qtbase:6[-gles2-only,opengl]
		media-libs/libglvnd
		media-libs/libprojectm:=
	)
	pulseaudio? ( media-libs/libpulse )
	qtmedia? ( dev-qt/qtmultimedia:6 )
	shout? ( media-libs/libshout )
	sid? ( >=media-libs/libsidplayfp-1.1.0:= )
	sndfile? ( media-libs/libsndfile )
	soxr? ( media-libs/soxr )
	vorbis? (
		media-libs/libogg
		media-libs/libvorbis
	)
	wavpack? ( media-sound/wavpack )
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	dev-qt/qttools:6[linguist]
	doc? ( app-text/doxygen )
"
DOCS=( AUTHORS ChangeLog README )

src_prepare() {
	cmake_src_prepare
	if use doc; then
		doxygen -u doc/Doxyfile.cmake.in 2>/dev/null || die
	fi

	#sed -i \
	#	-e '/^Exec=qmmp %F/s@=@=env QT_QPA_PLATFORM=xcb @' \
	#	src/app/qmmp.desktop || die

	rm_locale() {
		rm -fv src/app/desktop-translations/*${1}.desktop.in || die "removing of qmmp_${1}.desktop.in failed"
		rm -fv src/app/translations/${PN}_${1}.ts || die "removing of ${1}.ts failed"
		sed -i "/${PN}_${1}.qm/d" src/app/translations/${PN}_locales.qrc || die "removing of ${1}.ts failed"

		rm -fv src/${PN}ui/translations/lib${PN}ui_${1}.ts || die "removing of ${1}.ts failed"
		sed -i "/lib${PN}ui_${1}.qm/d" src/${PN}ui/translations/lib${PN}ui_locales.qrc || die "removing of ${1}.ts failed"

		rm -fv src/${PN}ui/txt/*${1}.txt || die "removing of ${1}.txt failed"
		sed -i "/${1}.txt/d" src/${PN}ui/txt/txt.qrc || die "removing of ${1}.txt failed"
	}
	plocale_get_locales src/${PN}ui/translations "lib${PN}ui_" ".ts"
	plocale_for_each_disabled_locale rm_locale

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		# our defaults
		-DUSE_CONVERTER=ON # because taglib
		-DUSE_RGSCAN=ON # because taglib
		-DUSE_LIBRARY=ON # because qtbase[sqlite]

		# depless non-default options
		-DUSE_OSS=ON

		# turn off windows specific stuff
		-DUSE_DSOUND=OFF
		-DUSE_TASKBAR=OFF
		-DUSE_RDETECT=OFF
		-DUSE_WASAPI=OFF
		-DUSE_WAVEOUT=OFF
		# set USE flags
		-DUSE_AAC="$(usex aac)"
		-DUSE_ALSA="$(usex alsa)"
		-DUSE_ANALYZER="$(usex analyzer)"
		-DUSE_ARCHIVE="$(usex archive)"
		-DUSE_BS2B="$(usex bs2b)"
		-DUSE_CDA="$(usex cdda)"
		-DUSE_LIBCDDB="$(usex cddb)"
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
		-DUSE_JACK="$(usex jack)"
		-DUSE_LADSPA="$(usex ladspa)"
		-DUSE_LYRICS="$(usex lyrics)"
		-DUSE_MAD="$(usex mad)"
		-DUSE_MIDI="$(usex midi)"
		-DUSE_MMS="$(usex mms)"
		-DUSE_MPG123="$(usex mpg123)"
		-DUSE_MPLAYER="$(usex mplayer)"
		-DUSE_MPC="$(usex musepack)"
		-DUSE_NOTIFIER="$(usex notifier)"
		-DUSE_OPUS="$(usex opus)"
		-DUSE_OSS="$(usex oss)"
		-DUSE_PIPEWIRE="$(usex pipewire)"
		-DUSE_PROJECTM="$(usex projectm)"
		-DUSE_PULSE="$(usex pulseaudio)"
		-DUSE_QSUI="$(usex qsui)"
		-DUSE_QTMULTIMEDIA="$(usex qtmedia)"
		-DUSE_SCROBBLER="$(usex scrobbler)"
		-DUSE_SHOUT="$(usex shout)"
		-DUSE_SID="$(usex sid)"
		-DUSE_SKINNED=OFF
		-DUSE_SNDFILE="$(usex sndfile)"
		-DUSE_SOXR="$(usex soxr)"
		-DUSE_STEREO="$(usex stereo)"
		-DUSE_STATICON="$(usex tray)"
		-DUSE_UDISKS="$(usex udisks)"
		-DUSE_VORBIS="$(usex vorbis)"
		-DUSE_WAVPACK="$(usex wavpack)"
		-DUSE_XMP="$(usex libxmp)"
		-DUSE_NULL=OFF
		-DUSE_RGSCAN=OFF
		-DUSE_SB=OFF
		-DCMAKE_BUILD_TYPE=Release
		-DQMMP_DEFAULT_OUTPUT=pipewire
		# custom option
		-DUSE_XCB=OFF
	)
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
	use doc && {
		cmake_build docs
		HTML_DOCS=( "${BUILD_DIR}"/doc/html/. )
	}
}

pkg_postinst() {
	xdg_pkg_postinst

	use dbus && optfeature "removable device detection" sys-fs/udisks
}
