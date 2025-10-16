# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PLOCALES="af ar ast be bg bn bs ca cs da de el en_AU en_CA en_GB eo es et eu fa fi fr ga gl grc he hi hr hu ia id ie it ja ka kn ko ku ky lt lv ms my nb nds nl nn pl pt pt_BR ro ru se si sk sl sq sr sv ta te th tr ug uk uz vi yi zh_CN zh_TW"
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{13..14} )
PYTHON_REQ_USE="sqlite(+)"
DISTUTILS_SINGLE_IMPL=1

inherit desktop distutils-r1 plocale git-r3 virtualx

DESCRIPTION="Clean junk to free disk space and to maintain privacy"
HOMEPAGE="https://www.bleachbit.org/"
EGIT_REPO_URI="https://github.com/${PN}/${PN}.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""

RDEPEND="
	$(python_gen_cond_dep '
		dev-python/chardet[${PYTHON_USEDEP}]
		dev-python/psutil[${PYTHON_USEDEP}]
		dev-python/pygobject:3[${PYTHON_USEDEP}]
	')
	x11-libs/gtk+:3
"
BDEPEND="
	sys-devel/gettext
"

distutils_enable_tests unittest

python_prepare_all() {
	if use test; then
		# avoid tests requiring internet access
		rm tests/Test{Chaff,GuiChaff,Network,Update}.py || die

		sed -e "s/test_chaff(self)/_&/" \
			-i tests/TestGUI.py || die

		# fails due to invalid language code format pt_pt
		sed -e "s/test_assertIsLanguageCode_live(self)/_&/" \
			-i tests/TestCommon.py || die

		# fails due to non-existent $HOME/.profile
		rm tests/TestInit.py || die

		# fails due to permission error on /proc
		sed -e "s/test_make_self_oom_target_linux(self)/_&/" \
			-i tests/TestMemory.py || die

		# only applicable to Windows
		rm tests/{TestNsisUtilities,TestWindows}.py || die

		# random failures, some also on upstream CI
		sed -e "s/test_notify(self)/_&/" \
			-i tests/TestGUI.py || die

		sed -e "s/test_get_proc_swaps(self)/_&/" \
			-i tests/TestMemory.py || die

		sed -e "s/test_is_process_running(self)/_&/" \
			-i tests/TestUnix.py || die
	fi

	rem_locale() {
		rm -fv "po/${1}.po" || die "removing of ${1}.po failed"
	}

	plocale_find_changes po "" ".po"
	plocale_for_each_disabled_locale rem_locale

	distutils-r1_python_prepare_all
}

python_compile_all() {
	emake -C po local
}

python_test() {
	virtx emake tests
}

python_install() {
	distutils-r1_python_install
	python_newscript ${PN}.py ${PN}
}

python_install_all() {
	distutils-r1_python_install_all
	emake -C po DESTDIR="${D}" install

	insinto /usr/share/${PN}/cleaners
	doins cleaners/*.xml

	insinto /usr/share/${PN}
	doins data/app-menu.ui

	doicon ${PN}.png
	domenu org.${PN}.BleachBit.desktop

	insinto /usr/share/polkit-1/actions
	doins org.${PN}.policy
}
