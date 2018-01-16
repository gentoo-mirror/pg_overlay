# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools git-r3 multilib-minimal

DESCRIPTION="A library for multiprecision complex arithmetic with exact rounding"
HOMEPAGE="http://mpc.multiprecision.org/"
EGIT_REPO_URI="https://scm.gforge.inria.fr/anonscm/git/${PN}/${PN}.git"

LICENSE="LGPL-2.1"
SLOT="0/3"
KEYWORDS=""
IUSE="static-libs"

DEPEND=">=dev-libs/gmp-5.0.0:0=[${MULTILIB_USEDEP},static-libs?]
	>=dev-libs/mpfr-3.0.0:0=[${MULTILIB_USEDEP},static-libs?]"
RDEPEND="${DEPEND}"

src_prepare() {
	ECONF_SOURCE=${S} eautoreconf
}

multilib_src_configure() {
	ECONF_SOURCE=${S} econf $(use_enable static-libs static)
}

multilib_src_install_all() {
	einstalldocs
	find "${D}" -name '*.la' -delete || die
}
