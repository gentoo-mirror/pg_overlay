# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3

DESCRIPTION="Shared code used by several utilities written by Jody Bruchon"
HOMEPAGE="https://codeberg.org/jbruchon/libjodycode"
EGIT_REPO_URI="https://codeberg.org/jbruchon/${PN}.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"

# missing test script
# https://github.com/jbruchon/jdupes/issues/191
RESTRICT="test"

PATCHES=(
	"${FILESDIR}"/${PN}-3.0.1-static-lib.patch
)

src_compile() {
	emake sharedlib
}

src_install() {
	emake \
		DESTDIR="${D}" \
		LIB_DIR="/usr/$(get_libdir)" \
		PREFIX="${EPREFIX}"/usr \
		install
	einstalldocs
}
