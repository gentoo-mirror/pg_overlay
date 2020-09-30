# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PLOCALES="be bg bn ca cs da de el en_GB es et eu fa fi fr gl he hr hu id it ja kk km lg lt nl pl pt pt_BR ro ru si_LK sk sl sr sr@latin sv te tr ug uk vi zh_CN zh_TW"

inherit autotools xdg l10n git-r3

DESCRIPTION="DeaDBeeF is a modular audio player similar to foobar2000"
HOMEPAGE="https://deadbeef.sourceforge.io/"
EGIT_REPO_URI="https://github.com/DeadBeeF-Player/${PN}.git"
EGIT_BRANCH="master"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="aac alsa cdda converter cover dts ffmpeg flac +hotkeys mp3 musepack nls notify nullout opus oss pulseaudio shellexec +supereq threads vorbis mac wavpack zip"

REQUIRED_USE="
	|| ( alsa oss pulseaudio nullout )
"

DEPEND="
	x11-libs/gtk+:3
	net-misc/curl:0=
	dev-libs/jansson
	aac? ( media-libs/faad2 )
	alsa? ( media-libs/alsa-lib )
	cdda? (
		dev-libs/libcdio:0=
		media-libs/libcddb
		dev-libs/libcdio-paranoia:0=
	)
	cover? ( media-libs/imlib2[jpeg,png] )
	dts? ( media-libs/libdca )
	ffmpeg? ( media-video/ffmpeg )
	flac? (
		media-libs/flac
		media-libs/libogg
	)
	mp3? ( media-sound/mpg123 )
	musepack? ( media-sound/musepack-tools )
	nls? ( virtual/libintl )
	notify? ( sys-apps/dbus )
	opus? ( media-libs/opusfile	)
	pulseaudio? ( media-sound/pulseaudio )
	vorbis? ( media-libs/libvorbis )
	mac? ( dev-lang/yasm )
	wavpack? ( media-sound/wavpack )
	zip? ( dev-libs/libzip )
"

RDEPEND="${DEPEND}"
BDEPEND="
	dev-util/intltool
	sys-devel/gettext
"

src_prepare() {
	if [[ $(l10n_get_locales disabled) =~ "ru" ]] ; then
		eapply "${FILESDIR}/${P}-remove-ru-help-translation.patch"
		rm -v "${S}/translation/help.ru.txt" || die
	fi

	remove_locale() {
		sed -e "/${1}/d" \
			-i "${S}/po/LINGUAS" || die
	}
	l10n_for_each_disabled_locale_do remove_locale

	default

	drop_from_linguas() {
		sed "/${1}/d" -i "${S}/po/LINGUAS" || die
	}

	drop_and_stub() {
		rm -rf "${1}"
		mkdir "${1}"
		cat > "${1}/Makefile.in" <<-EOF
			all: nothing
			install: nothing
			nothing:
		EOF
	}

	l10n_for_each_disabled_locale_do drop_from_linguas || die

	eautopoint --force
	eautoreconf

	# Get rid of bundled gettext.
	drop_and_stub "${S}/intl"

	# Plugins that are undesired for whatever reason, candidates for unbundling and such.
	for i in adplug alac dumb ffap mms gme lfs mono2stereo psf sc60 shn sid soundtouch wma; do
		drop_and_stub "${S}/plugins/${i}"
	done

	rm -rf "${S}/plugins/rg_scanner/ebur128"
}

src_configure () {
	local myconf=(
		"--disable-static"
		"--disable-staticlink"
		"--disable-portable"
		"--disable-rpath"

		"--disable-libmad"
		"--disable-gtk2"
		"--disable-adplug"
		"--disable-coreaudio"
		"--disable-dumb"
		"--disable-alac"
		"$(use_enable mac ffap)"
		"--disable-gme"
		"--disable-lfm"
		"--disable-mms"
		"--disable-mono2stereo"
		"--disable-psf"
		"--disable-rgscanner"
		"--disable-sc68"
		"--disable-shn"
		"--disable-sid"
		"--disable-sndfile"
		"--disable-soundtouch"
		"--disable-src"
		"--disable-tta"
		"$(use_enable zip vfs-zip)"
		"--disable-vtx"
		"$(use_enable wavpack)"
		"--disable-wildmidi"
		"--disable-wma"

		"$(use_enable alsa)"
		"$(use_enable oss)"
		"$(use_enable pulseaudio pulse)"
		"$(use_enable mp3)"
		"$(use_enable mp3 libmpg123)"
		"$(use_enable nls)"
		"$(use_enable vorbis)"
		"$(use_enable threads)"
		"$(use_enable flac)"
		"$(use_enable supereq)"
		"$(use_enable cdda)"
		"$(use_enable cdda cdda-paranoia)"
		"$(use_enable aac)"
		"$(use_enable cover artwork)"
		"$(use_enable cover artwork-imlib2)"
		"$(use_enable cover artwork-network)"
		"$(use_enable dts dca)"
		"$(use_enable ffmpeg)"
		"$(use_enable converter)"
		"$(use_enable musepack)"
		"$(use_enable notify)"
		"$(use_enable nullout)"
		"$(use_enable opus)"
		"$(use_enable pulseaudio pulse)"
		"$(use_enable shellexec)"
		"$(use_enable shellexec shellexecui)"

		"--enable-gtk3"
		"--enable-vfs-curl"
		"--enable-shared"
		"--enable-m3u"
		"--enable-pltbrowser"
	)

	econf "${myconf[@]}"
}

src_install() {
	default

	find "${ED}" -name '*.la' -delete || die
}
