# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3 toolchain-funcs

DESCRIPTION="Tools and library to manipulate EFI variables"
HOMEPAGE="https://github.com/rhinstaller/efivar"
EGIT_REPO_URI="git://github.com/rhinstaller/${PN}.git"

LICENSE="GPL-2"
SLOT="0/${PV}"
KEYWORDS=""

RDEPEND="dev-libs/popt"
DEPEND="${RDEPEND}
	>=sys-kernel/linux-headers-3.18"

src_prepare() {
	default
	sed -i -e s/-Werror// gcc.specs || die
}

src_configure() {
	tc-export CC
	export libdir="/usr/$(get_libdir)"
}

src_compile() {
	# Avoid building static binary/libs
	opts=(
		BINTARGETS=efivar
		STATICLIBTARGETS=
	)
	emake "${opts[@]}"
}

src_install() {
	emake "${opts[@]}" DESTDIR="${D}" install
}
