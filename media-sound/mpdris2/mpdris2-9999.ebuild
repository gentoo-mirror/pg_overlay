# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{13..14})
PLOCALES="fr nl"

inherit python-r1 autotools git-r3 plocale

MY_PN="${PN/d/D}"

DESCRIPTION="An implementation of the MPRIS 2 interface as a client for MPD"
HOMEPAGE="https://github.com/eonpatapon/mpDris2"
EGIT_REPO_URI="https://github.com/eonpatapon/${PN}.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE=""

DEPEND="
	>=dev-python/dbus-python-0.80[$PYTHON_USEDEP]
	>=dev-python/pygobject-3.28.3[$PYTHON_USEDEP]
	>=dev-python/python-mpd2-0.3.0[$PYTHON_USEDEP]"

DOCS="AUTHORS COPYING INSTALL NEWS README README.md"

src_prepare() {
	default

	local loc_dir="po"
	plocale_find_changes "${loc_dir}" "" ".po"
	rm_locale() {
		rm -vf "${loc_dir}/${1}.po" || die
	}
	plocale_for_each_disabled_locale rm_locale

	eautoreconf
}

src_install() {
	emake install DESTDIR="${D}" || die "Failed to install"
}
