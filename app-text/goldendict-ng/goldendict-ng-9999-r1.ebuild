# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PLOCALES="ar ay be bg crowdin cs de de_CH el eo es es_AR es_BO fa fi fr hi hu ie it ja jbo kab ko lt mk nl pl pt pt_BR qu ru sk sq sr sv tg tk tr uk vi zh_CN zh_TW"

inherit cmake desktop git-r3 plocale

DESCRIPTION="The Next Generation GoldenDict. Feature-rich dictionary lookup program"
HOMEPAGE="https://xiaoyifang.github.io/goldendict-ng"
EGIT_REPO_URI="https://github.com/xiaoyifang/${PN}.git"
EGIT_BRANCH="staged"
EGIT_SUBMODULES=()

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="ffmpeg "

RDEPEND="
	app-arch/bzip2
	app-i18n/opencc
	app-text/hunspell
	dev-libs/eb
	dev-libs/lzo
	dev-libs/xapian
	dev-qt/qtbase:6[X,gui,network,sql,widgets,xml]
	dev-qt/qtmultimedia:6
	dev-qt/qtspeech:6
	dev-qt/qtsvg:6
	dev-qt/qtwebengine:6
	media-libs/libvorbis
	media-libs/tiff:0
	sys-libs/zlib
	ffmpeg? (
		media-video/ffmpeg:0=
	)
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-libs/kdsingleapplication
	dev-qt/qt5compat:6
	dev-qt/qttools:6[assistant,linguist]
	virtual/pkgconfig
"

src_prepare() {
	# add trailing semicolon
	#sed -i -e '/^Categories/s/$/;/' redist/org.xiaoyifang.GoldenDict_NG.desktop || die

	local loc_dir="${S}/locale"
	plocale_find_changes "${loc_dir}" "" ".ts"
	rm_loc() {
		rm -vf "locale/${1}.ts"
	}
	plocale_for_each_disabled_locale rm_loc

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_BUILD_TYPE=Release
		-DWITH_FFMPEG_PLAYER=ON
		-DWITH_EPWING_SUPPORT=OFF
		-DWITH_ZIM=OFF
		-DUSE_SYSTEM_FMT=ON
		-DUSE_SYSTEM_TOML=OFF
	)
	cmake_src_configure
}

install_locale() {
	insinto /usr/share/apps/${PN}/locale
	doins "${S}"/.qm/${1}.qm
	eend $? || die "failed to install $1 locale"
}


pkg_postinst() {
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
}
