# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PLOCALES="de en"
PYTHON_COMPAT=( python3_7 )

inherit desktop distutils-r1 l10n git-r3

DESCRIPTION="CoverGrid (mcg) is a client for the Music Player Daemon (MPD), focusing on albums instead of single tracks. It is not intended to be a replacement for your favorite MPD client but an addition to get a better album-experience"
HOMEPAGE="https://www.suruatoel.xyz/codes/mcg"
EGIT_REPO_URI="https://gitlab.com/coderkun/${PN}.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""

RDEPEND="dev-python/pygobject:3[$PYTHON_USEDEP]"
DEPEND="${RDEPEND}
	dev-python/setuptools[$PYTHON_USEDEP]"

python_prepare_all() {
	rem_locale() {
		rm -frv "locale/${1}" || die "removing of ${1}.po failed"
		sed -i 's:'locale/de/LC_MESSAGES/mcg.mo'::g' setup.py
	}

	#l10n_for_each_disabled_locale_do rem_locale

	distutils-r1_python_prepare_all
}

python_install() {
	distutils-r1_python_install
	python_newscript ${PN}/${PN}.py ${PN}
}

python_install_all() {
	distutils-r1_python_install_all
	#emake -C DESTDIR="${D}" install

	#doicon ${PN}/${PN}.svg
	#domenu ${PN}/${PN}.desktop
}
