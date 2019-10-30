# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PLOCALES="de es fr hu pl ru uk zh"

inherit cmake-utils git-r3 l10n xdg

DESCRIPTION="Qt-based video player, which can play all formats and stream"
HOMEPAGE="https://github.com/zaps166/QMPlay2"
EGIT_REPO_URI="https://github.com/zaps166/${PN}.git"
KEYWORDS=""

LICENSE="LGPL"
SLOT="0"
IUSE="alsa +audiofilters cdio cuvid extensions +ffmpeg gme inputs +jemalloc lastfm +libass modplug mpris notify +opengl portaudio pulseaudio sid +taglib +vaapi vdpau +videofilters visualizations +xv"
REQUIRED_USE="lastfm? ( extensions )
		mpris? ( extensions )"

RDEPEND="
	>=dev-qt/qtdbus-5.9.1:5
	>=dev-qt/qtsvg-5.9.1:5
	>=media-video/ffmpeg-3.1.0:=
	gme? ( media-libs/game-music-emu )
	cdio? ( dev-libs/libcdio[cddb] )
	jemalloc? ( dev-libs/jemalloc )
	libass? ( media-libs/libass )
	portaudio? ( media-libs/portaudio )
	pulseaudio? ( media-sound/pulseaudio )
	sid? ( media-libs/libsidplayfp )
	taglib? ( >=media-libs/taglib-1.9.1 )
	vaapi? ( x11-libs/libva[opengl,X] )
	vdpau? ( x11-libs/libvdpau )
	xv? ( x11-libs/libXv )
"
DEPEND="${RDEPEND}
	dev-qt/linguist-tools:5
"

CMAKE_MIN_VERSION="3.1"
DOCS=( AUTHORS ChangeLog README.md )

src_prepare() {
	l10n_find_plocales_changes "${S}/lang" "" '.ts'

	# Delete Ubuntu Unity shortcut group
	sed -i -e '/X-Ayatana-Desktop-Shortcuts/,$d' \
		src/gui/Unix/QMPlay2.desktop || die

	cmake-utils_src_prepare
}


src_configure() {
	local mycmakeargs=(
		-DUSE_FFMPEG=ON
		-DUSE_FFMPEG_AVDEVICE=ON
		-DUSE_LINK_TIME_OPTIMIZATION=ON 
		-DUSE_CMD=OFF
		-DUSE_PORTAUDIO=OFF
		-DLANGUAGES="$(l10n_get_locales)"
		-DUSE_ALSA=$(usex alsa)
		-DUSE_AUDIOFILTERS=$(usex audiofilters)
		-DUSE_AUDIOCD=$(usex cdio)
		-DUSE_CHIPTUNE_GME=$(usex gme)
		-DUSE_CHIPTUNE_SID=$(usex sid)
		-DUSE_CUVID=$(usex cuvid)
		-DUSE_INPUTS=$(usex inputs)
		-DUSE_JEMALLOC=$(usex jemalloc)
		-DUSE_LIBASS=$(usex libass)
		-DUSE_MODPLUG=$(usex modplug)
		-DUSE_NOTIFY=$(usex notify)
		-DUSE_FREEDESKTOP_NOTIFICATIONS=$(usex notify)
		-DUSE_OPENGL2=$(usex opengl)
		-DUSE_PULSEAUDIO=$(usex pulseaudio)
		-DUSE_TAGLIB=$(usex taglib)
		-DUSE_FFMPEG_VAAPI=$(usex vaapi)
		-DUSE_FFMPEG_VDPAU=$(usex vdpau)
		-DUSE_VIDEOFILTERS=$(usex videofilters)
		-DUSE_VISUALIZATIONS=$(usex visualizations)
		-DUSE_XVIDEO=$(usex xv)
	)

	if use extensions; then
		mycmakeargs+=( -DUSE_EXTENSIONS=ON )
		mycmakeargs+=( -DUSE_LASTFM=$(usex lastfm) )
		mycmakeargs+=( -DUSE_MPRIS2=$(usex mpris) )
	else
		mycmakeargs+=( -DUSE_EXTENSIONS=OFF -DUSE_MPRIS2=OFF -DUSE_LASTFM=OFF -DUSE_TEKSTOWO=OFF -DUSE_DATMUSIC=OFF -DUSE_ANIMEODCINKI=OFF -DUSE_WBIJAM=OFF )
	fi

	cmake-utils_src_configure
}
