# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PLOCALES="af ar ast be bg bn bs ca cs da de el en_AU en_CA en_GB eo es et eu fa fi fr gl he hi hr hu ia id it ja ko ku ky lt lv ms my nb nds nl nn pl pt pt_BR ro ru se sk sl sq sr sv ta te th tr ug uk uz vi zh_CN zh_TW"
PYTHON_COMPAT=( python3_8 )
PYTHON_REQ_USE="sqlite(+)"

inherit desktop distutils-r1 l10n git-r3

DESCRIPTION="Clean junk to free disk space and to maintain privacy"
HOMEPAGE="https://bleachbit.org/"
EGIT_REPO_URI="https://github.com/${PN}/${PN}.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="
	dev-python/chardet[$PYTHON_USEDEP]
	dev-python/pygobject:3[$PYTHON_USEDEP]
	dev-python/scandir[$PYTHON_USEDEP]
"
BDEPEND="
	dev-python/setuptools[$PYTHON_USEDEP]
	sys-devel/gettext
"

python_prepare_all() {
	rem_locale() {
		rm -fv "po/${1}.po" || die "removing of ${1}.po failed"
	}

	l10n_find_plocales_changes po "" ".po"
	l10n_for_each_disabled_locale_do rem_locale

	# choose correct Python implementation, bug #465254
	sed -i 's/python/${EPYTHON}/g' po/Makefile || die

	distutils-r1_python_prepare_all
}

python_compile_all() {
	emake -C po local
}

python_install() {
	distutils-r1_python_install
	python_newscript ${PN}.py ${PN}
}

python_install_all() {
	distutils-r1_python_install_all
	emake -C po DESTDIR="${D}" install

	# https://bugs.gentoo.org/388999
	insinto /usr/share/${PN}/cleaners
	doins cleaners/*.xml

	insinto /usr/share/${PN}
	doins data/app-menu.ui

	doicon ${PN}.png
	domenu org.${PN}.BleachBit.desktop

	insinto /usr/share/polkit-1/actions
	doins org.${PN}.policy
}
