# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools toolchain-funcs git-r3

DESCRIPTION="Detect and convert encoding of text files"
HOMEPAGE="https://cihar.com/software/enca/"
EGIT_REPO_URI="https://github.com/nijel/${PN}.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="doc +iconv recode"

BDEPEND="doc? ( dev-util/gtk-doc )"
RDEPEND="
	iconv? ( virtual/libiconv )
	recode? ( app-text/recode:= )
"
DEPEND="
	${RDEPEND}
	sys-devel/gettext
"

pkg_pretend() {
	if tc-is-cross-compiler && use iconv; then
		die "${PN} can't be cross built with iconv USE enabled. See Gentoo bug 593220."
	fi
}

src_prepare() {
	default

	# Disable unconditional documentation build.
	sed -i -e '/SUBDIRS/s/ devel-docs//g' Makefile.am || die
	#eautoreconf
}

src_configure() {
	local myeconfargs=(
		--enable-external
		--disable-static
		$(use_enable doc gtk-doc)
		$(use_with iconv libiconv-prefix "${EPREFIX}/usr")
		$(use_with recode librecode "${EPREFIX}/usr")
	)

	# Workaround automagic virtual/libiconv dependency.
	use iconv || export am_cv_func_iconv=no

	econf "${myeconfargs[@]}"
}

src_compile() {
	# Workaround cross compilation issues. See Gentoo bug 424473.
	tc-is-cross-compiler && tc-env_build emake -e -C tools

	emake
	use doc && emake -C devel-docs docs
}

src_install() {
	emake DESTDIR="${D}" install
	use doc && emake -C devel-docs DESTDIR="${D}" install

	find "${ED}" -name '*.la' -delete || die
}
