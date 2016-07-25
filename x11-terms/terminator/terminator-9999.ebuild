# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit bzr distutils-r1 virtualx

DESCRIPTION="Multiple GNOME terminals in one window"
HOMEPAGE="http://www.tenshu.net/p/terminator.html"
EBZR_REPO_URI="https://code.launchpad.net/~gnome-terminator/terminator/gtk3"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="dbus doc gnome +libnotify"

RDEPEND="
	dev-libs/keybinder:3
	x11-libs/vte:2.91
	dev-python/psutil[${PYTHON_USEDEP}]
	dbus? ( sys-apps/dbus )
	gnome? (
		dev-python/gconf-python
		dev-python/libgnome-python
		dev-python/pygobject:2[${PYTHON_USEDEP}]
		dev-python/pygtk:2[${PYTHON_USEDEP}]
		)
	libnotify? ( dev-python/notify-python[${PYTHON_USEDEP}] )"
DEPEND="dev-util/intltool"

python_prepare_all() {
	local PATCHES=(
		"${FILESDIR}"/0.90-without-icon-cache.patch
		"${FILESDIR}"/0.94-session.patch
	)

	local i p
	if [[ -n "${LINGUAS+x}" ]] ; then
		pushd "${S}"/po > /dev/null
		strip-linguas -i .
		for i in *.po; do
			if ! has ${i%.po} ${LINGUAS} ; then
				rm ${i} || die
			fi
		done
		popd > /dev/null
	fi

	sed \
		-e "/'share', 'doc'/s:${PN}:${PF}:g" \
		-i setup.py terminatorlib/util.py || die

	use doc || \
		sed \
			-e '/install_documentation/s:True:False:g' \
			-i setup.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	VIRTUALX_COMMAND="esetup.py"
	virtualmake test
}
