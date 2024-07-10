# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PLOCALES="ar_SA ay_BO be_BY bg_BG crowdin cs_CZ de_CH de_DE el_GR eo_UY es_AR es_BO es_ES fa_IR fi_FI fr_FR hi_IN ie_001 it_IT ja_JP jbo_EN ko_KR lt_LT mk_MK nl_NL pl_PL pt_BR pt_PT qt_extra_es qt_extra_it qt_extra_lt qtwebengine_zh_CN qu_PE ru_RU sk_SK sq_AL sr_SP sv_SE tg_TJ tk_TM tr_TR uk_UA vi_VN zh_CN zh_TW"

inherit cmake desktop git-r3 plocale

DESCRIPTION="Feature-rich dictionary lookup program"
HOMEPAGE="http://goldendict.org/"
EGIT_REPO_URI="https://github.com/xiaoyifang/${PN}-ng.git"
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
	dev-qt/kdsingleapplication[qt6]
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
