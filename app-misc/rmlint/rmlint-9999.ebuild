# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PLOCALES="de es fr"
PYTHON_COMPAT=( python3_{6,7,8} )

inherit eutils git-r3 gnome2-utils l10n python-r1 scons-utils

DESCRIPTION="rmlint finds space waste and other broken things on your filesystem and offers to remove it"
HOMEPAGE="https://github.com/sahib/rmlint"
EGIT_REPO_URI="https://github.com/sahib/${PN}.git"
EGIT_BRANCH="develop"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="X doc"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="X? ( x11-libs/gtksourceview:3.0
			dev-python/pygobject:3[${PYTHON_USEDEP}]
			gnome-base/librsvg:2 )
		doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
		dev-libs/json-glib"
DEPEND="${RDEPEND}
		dev-util/scons[${PYTHON_USEDEP}]
		sys-devel/gettext
		virtual/pkgconfig"

src_prepare() {
	default

	# DEBUG=1 - don't strip binary
	scons_opts="DEBUG=0 --libdir=/usr/$(get_libdir) --prefix="${ED%/}"/usr --actual-prefix={ED%/}/usr \
		--with-sse  \
		$(usex X --with-gui --without-gui)"

	l10n_prepare() {
		rm po/"${1}".po || die "removing of ${1}.po failed"
	}
	l10n_find_plocales_changes po "" .po
	l10n_for_each_disabled_locale_do l10n_prepare
}

src_configure() {
	escons config "${scons_opts}"
}

src_compile(){
	escons CC="$(tc-getCC)"  "${scons_opts}"
}

src_install(){
	escons "${scons_opts}" install
    rm -f ${ED%/}/usr/share/glib-2.0/schemas/gschemas.compiled
    if ! use X; then
    	rm -rf "${D}"/usr/share/{glib-2.0,icons,applications}
    	rm -rf "${D}"/usr/lib
	fi
	if ! use doc; then
		rm -rf "${D}"/usr/share/man
	fi
}

pkg_postinst() {
	use X && gnome2_schemas_update
	xdg_icon_cache_update
}

pkg_postrm() {
	use X && gnome2_schemas_update
	xdg_icon_cache_update
}
