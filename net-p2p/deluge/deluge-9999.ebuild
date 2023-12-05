# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..12} )
DISTUTILS_SINGLE_IMPL=1
PLOCALES="af ar ast be bg bn bs ca cs cy da de el en_AU en_CA en_GB eo es et eu fa fi fo fr fy ga gl he hi hr hu id is it iu ja ka kk km kn ko ku ky la lb lt lv mk ml ms nap nb nds nl nn oc pl pms pt pt_BR ro ru si sk sl sr sv ta te th tl tlh tr uk ur vi zh_CN zh_HK zh_TW"
inherit distutils-r1 plocale xdg

DESCRIPTION="BitTorrent client with a client/server model"
HOMEPAGE="https://deluge-torrent.org/"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://git.deluge-torrent.org/${PN}
		git://deluge-torrent.org/${PN}.git"
	EGIT_BRANCH="develop"
else
	SRC_URI="http://download.deluge-torrent.org/source/2.0/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm ~ppc ~x86"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="console geoip gtk libnotify sound webinterface"
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	libnotify? ( gtk )
	sound? ( gtk )
"

DEPEND="
	>=net-libs/libtorrent-rasterbar-2.0.0:=[python,${PYTHON_SINGLE_USEDEP}]
	$(python_gen_cond_dep '
		dev-python/wheel[${PYTHON_USEDEP}]
	')
	dev-util/intltool
	acct-group/deluge
	acct-user/deluge"
RDEPEND="
	>=net-libs/libtorrent-rasterbar-2.0.0:=[python,${PYTHON_SINGLE_USEDEP}]
	$(python_gen_cond_dep '
		dev-python/chardet[${PYTHON_USEDEP}]
		dev-python/distro[${PYTHON_USEDEP}]
		dev-python/pillow[${PYTHON_USEDEP}]
		dev-python/pyopenssl[${PYTHON_USEDEP}]
		dev-python/pyxdg[${PYTHON_USEDEP}]
		dev-python/rencode[${PYTHON_USEDEP}]
		dev-python/setproctitle[${PYTHON_USEDEP}]
		dev-python/six[${PYTHON_USEDEP}]
		|| (
			>=dev-python/twisted-17.1.0[ssl(-),${PYTHON_USEDEP}]
			>=dev-python/twisted-17.1.0[crypt(-),${PYTHON_USEDEP}]
		)
		>=dev-python/zope-interface-4.4.2[${PYTHON_USEDEP}]
		geoip? ( dev-python/geoip-python[${PYTHON_USEDEP}] )
		gtk? (
			sound? ( dev-python/pygame[${PYTHON_USEDEP}] )
			dev-python/pygobject:3[${PYTHON_USEDEP}]
			gnome-base/librsvg
			libnotify? ( x11-libs/libnotify )
		)
		webinterface? ( dev-python/mako[${PYTHON_USEDEP}] )
	')"

PATCHES=(
	"${FILESDIR}/${PN}-2.0.3-UI-status.patch"
	"${FILESDIR}/${PN}-web_ui_columns.patch"
)

src_prepare() {
	default

	plocale_find_changes "${S}/deluge/i18n" "" ".po"
	rm_locale() {
		rm -vf "${S}/deluge/i18n/${1}.po" || die
	}
	plocale_for_each_disabled_locale rm_locale
}

python_prepare_all() {
	local args=(
		-e "/Compiling po file/a \\\tuptoDate = False"
	)
	sed -i "${args[@]}" -- 'setup.py' || die
	args=(
		-e 's|"new_release_check": True|"new_release_check": False|'
		-e 's|"check_new_releases": True|"check_new_releases": False|'
		-e 's|"show_new_releases": True|"show_new_releases": False|'
	)
	sed -i "${args[@]}" -- 'deluge/core/preferencesmanager.py' || die

	distutils-r1_python_prepare_all
}

esetup.py() {
	# bug 531370: deluge has its own plugin system. No need to relocate its egg info files.
	# Override this call from the distutils-r1 eclass.
	# This does not respect the distutils-r1 API. DONOT copy this example.
	set -- "${PYTHON}" setup.py "$@"
	echo "$@"
	"$@" || die
}

python_install_all() {
	distutils-r1_python_install_all
	if ! use console ; then
		rm -r "${D}/$(python_get_sitedir)/deluge/ui/console/" || die
		rm "${ED}/usr/bin/deluge-console" || die
		rm "${ED}/usr/share/man/man1/deluge-console.1" ||die
	fi
	if ! use gtk ; then
		rm -r "${D}/$(python_get_sitedir)/deluge/ui/gtk3/" || die
		rm -r "${ED}/usr/share/icons/" || die
		rm "${ED}/usr/bin/deluge-gtk" || die
		rm "${ED}/usr/share/man/man1/deluge-gtk.1" || die
		rm "${ED}/usr/share/applications/deluge.desktop" || die
	fi
	if use webinterface; then
		newinitd "${FILESDIR}/deluge-web.init-2" deluge-web
		newconfd "${FILESDIR}/deluge-web.conf" deluge-web
	else
		rm -r "${D}/$(python_get_sitedir)/deluge/ui/web/" || die
		rm "${ED}/usr/bin/deluge-web" || die
		rm "${ED}/usr/share/man/man1/deluge-web.1" || die
	fi
	mv "${ED}/usr/share/appdata/" "${ED}/usr/share/metainfo/"
	newinitd "${FILESDIR}"/deluged.init-2 deluged
	newconfd "${FILESDIR}"/deluged.conf-2 deluged

	python_optimize
}

pkg_postinst() {
	xdg_pkg_postinst

	elog
	elog "If, after upgrading, deluge doesn't work, please remove the"
	elog "'~/.config/deluge' directory and try again, but make a backup"
	elog "first!"
	elog
	elog "To start the daemon either run 'deluged' as user"
	elog "or modify /etc/conf.d/deluged and run"
	elog "/etc/init.d/deluged start as root"
	elog "You can still use deluge the old way"
	elog
	elog "For more information look at https://dev.deluge-torrent.org/wiki/Faq"
	elog
}
