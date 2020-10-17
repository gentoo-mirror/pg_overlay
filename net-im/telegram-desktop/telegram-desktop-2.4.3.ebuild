# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )

inherit cmake desktop flag-o-matic python-any-r1 xdg-utils toolchain-funcs

MY_P="tdesktop-${PV}-full"

DESCRIPTION="Official desktop client for Telegram"
HOMEPAGE="https://desktop.telegram.org"
SRC_URI="https://github.com/telegramdesktop/tdesktop/releases/download/v${PV}/${MY_P}.tar.gz
		https://github.com/perfect7gentleman/binaries/raw/main/tg_owt-master.zip"

LICENSE="GPL-3-with-openssl-exception"
SLOT="0"
KEYWORDS="~amd64 ~ppc64"
IUSE="+alsa +dbus enchant +gtk +hunspell libressl pulseaudio +spell +X wayland"

RDEPEND="
	!net-im/telegram-desktop-bin
	app-arch/lz4:=
	app-arch/xz-utils
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )
	dev-libs/xxhash
	dev-qt/qtcore:5
	dev-qt/qtgui:5[dbus?,jpeg,png,wayland?,X(-)?]
	dev-qt/qtimageformats:5
	dev-qt/qtnetwork:5
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5[png,X(-)?]
	media-fonts/open-sans
	media-libs/fontconfig:=
	~media-libs/libtgvoip-2.4.4_p20200704[alsa?,pulseaudio?]
	media-libs/openal[alsa?,pulseaudio?]
	media-libs/opus:=
	media-video/ffmpeg:=[alsa?,opus,pulseaudio?]
	sys-libs/zlib[minizip]
	virtual/libiconv
	x11-libs/libxcb:=
	dbus? (
		dev-qt/qtdbus:5
		dev-libs/libdbusmenu-qt[qt5(+)]
	)
	enchant? ( app-text/enchant:= )
	gtk? (
		dev-libs/glib:2
		x11-libs/gdk-pixbuf:2[jpeg,X?]
		x11-libs/gtk+:3[X?,wayland?]
		x11-libs/libX11
	)
	hunspell? ( >=app-text/hunspell-1.7:= )
	pulseaudio? ( media-sound/pulseaudio )
"

DEPEND="
	${PYTHON_DEPS}
	${RDEPEND}
	dev-cpp/range-v3
	=dev-cpp/ms-gsl-3*
"

BDEPEND="
	>=dev-util/cmake-3.16
	virtual/pkgconfig
"

REQUIRED_USE="
	|| ( alsa pulseaudio )
	spell? (
		^^ ( enchant hunspell )
	)
"

S="${WORKDIR}/${MY_P}"

pkg_pretend() {
	if has ccache ${FEATURES}; then
		ewarn
		ewarn "ccache does not work with ${PN} out of the box"
		ewarn "due to usage of precompiled headers"
		ewarn "check bug https://bugs.gentoo.org/715114 for more info"
		ewarn
	fi
}

twg_prepare(){
	S=${WORKDIR}/Libraries/tg_owt
	eapply "${FILESDIR}/0001-use-bundled-ranged-exptected-gsl.patch"
	mkdir Libraries
	cp -r "${WORKDIR}"/tg_owt-master Libraries/tg_owt
	mkdir "${WORKDIR}"/Libraries
	mv "${WORKDIR}"/tg_owt-master "${WORKDIR}"/Libraries/tg_owt
	pushd "${WORKDIR}"/Libraries
	eapply "${FILESDIR}/0002-tg_owt-fix-name-confliction.patch"
	popd
	pushd ${WORKDIR}/Libraries/tg_owt
	BUILD_DIR="${WORKDIR}/Libraries/tg_owt" cmake_src_prepare
}

twg_configure() {
	twg_prepare
	S=${WORKDIR}/Libraries/tg_owt
	pushd ${WORKDIR}/Libraries/tg_owt
	local mycmakeargs=(
		-G Ninja \
		-DCMAKE_BUILD_TYPE=Release \
		-DTG_OWT_SPECIAL_TARGET=linux \
		-DTG_OWT_LIBJPEG_INCLUDE_PATH=${EPREFIX}/usr/include \
		-DTG_OWT_OPENSSL_INCLUDE_PATH=${EPREFIX}/usr/include/openssl \
		-DTG_OWT_OPUS_INCLUDE_PATH=${EPREFIX}/usr/include/opus \
		-DTG_OWT_FFMPEG_INCLUDE_PATH=${EPREFIX}/usr/include/ffmpeg \
		-DTDESKTOP_API_ID="611335" \
		-DTDESKTOP_API_HASH="d524b414d21f4d37f08684c1df41ac9c"
	)
	BUILD_DIR="${WORKDIR}/Libraries/tg_owt" cmake_src_configure
}

twg_compile() {
	twg_configure
	S=${WORKDIR}/Libraries/tg_owt
	pushd ${WORKDIR}/Libraries/tg_owt
	BUILD_DIR="${WORKDIR}/Libraries/tg_owt" cmake_src_compile
	mkdir -p out/Gentoo
	cp libtg_owt.a out/Gentoo
	unset S
	S="${WORKDIR}/${MY_P}"
	popd
}	

src_prepare() {
	twg_compile
	einfo +++++++
	einfo $S
	einfo +++++++
}

S="${WORKDIR}/${MY_P}"
src_configure() {
	S="${WORKDIR}/${MY_P}"
	local mycxxflags=(
		-Wno-deprecated-declarations
		-Wno-error=deprecated-declarations
		-Wno-switch
	)

	append-cxxflags "${mycxxflags[@]}"

	#######

	######

	# TODO: unbundle header-only libs, ofc telegram uses git versions...
	# it fals with tl-expected-1.0.0, so we use bundled for now to avoid git rev snapshots
	# EXPECTED VARIANT
	# gtk is really needed for image copy-paste due to https://bugreports.qt.io/browse/QTBUG-56595
	local mycmakeargs=(
		-DDESKTOP_APP_DISABLE_CRASH_REPORTS=ON
		-DDESKTOP_APP_USE_GLIBC_WRAPS=OFF
		-DDESKTOP_APP_USE_PACKAGED=ON
		-DTDESKTOP_DISABLE_GTK_INTEGRATION="$(usex gtk OFF ON)"
		-DTDESKTOP_LAUNCHER_BASENAME="${PN}"
		-DDESKTOP_APP_DISABLE_DBUS_INTEGRATION="$(usex dbus OFF ON)"
		-DDESKTOP_APP_DISABLE_SPELLCHECK="$(usex spell OFF ON)" # enables hunspell (recommended)
		-DDESKTOP_APP_USE_ENCHANT="$(usex enchant ON OFF)" # enables enchant and disables hunspell
	)

	if [[ -n ${MY_TDESKTOP_API_ID} && -n ${MY_TDESKTOP_API_HASH} ]]; then
		einfo "Found custom API credentials"
		mycmakeargs+=(
			-DTDESKTOP_API_ID="${MY_TDESKTOP_API_ID}"
			-DTDESKTOP_API_HASH="${MY_TDESKTOP_API_HASH}"
		)
	else
		# https://github.com/telegramdesktop/tdesktop/blob/dev/snap/snapcraft.yaml
		# Building with snapcraft API credentials by default
		# Custom API credentials can be obtained here:
		# https://github.com/telegramdesktop/tdesktop/blob/dev/docs/api_credentials.md
		# After getting credentials you can export variables:
		#  export MY_TDESKTOP_API_ID="17349""
		#  export MY_TDESKTOP_API_HASH="344583e45741c457fe1862106095a5eb"
		# and restart the build"
		# you can set above variables (without export) in /etc/portage/env/net-im/telegram-desktop
		# portage will use custom variable every build automatically
		mycmakeargs+=(
			-DTDESKTOP_API_ID="611335"
			-DTDESKTOP_API_HASH="d524b414d21f4d37f08684c1df41ac9c"
		)
	fi

	cmake_src_configure
	einfo +++++++
	einfo $S
	einfo +++++++
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
	xdg_mimeinfo_database_update
	use gtk || einfo "enable \'gtk\' useflag if you have image copy-paste problems"
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
	xdg_mimeinfo_database_update
}
