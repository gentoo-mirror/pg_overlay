# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic git-r3 linux-info meson pam udev xdg-utils

DESCRIPTION="The systemd project's logind, extracted to a standalone package"
HOMEPAGE="https://github.com/elogind/elogind"
EGIT_REPO_URI="https://github.com/elogind/elogind.git"
EGIT_BRANCH="v243-stable"
EGIT_SUBMODULES=()

LICENSE="CC0-1.0 LGPL-2.1+ public-domain"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="+acl debug doc efi +pam +policykit selinux"

BDEPEND="
	app-text/docbook-xml-dtd:4.2
	app-text/docbook-xml-dtd:4.5
	app-text/docbook-xsl-stylesheets
	dev-util/gperf
	dev-util/intltool
	virtual/pkgconfig
"
DEPEND="
	sys-apps/util-linux
	sys-libs/libcap
	virtual/libudev:=
	acl? ( sys-apps/acl )
	pam? ( sys-libs/pam )
	selinux? ( sys-libs/libselinux )
"
RDEPEND="${DEPEND}
	!sys-apps/systemd
"
PDEPEND="
	sys-apps/dbus
	policykit? ( sys-auth/polkit )
"

PATCHES=(
	"${FILESDIR}/${PN}-243.4-nodocs.patch"
)

pkg_setup() {
	local CONFIG_CHECK="~CGROUPS ~EPOLL ~INOTIFY_USER ~SIGNALFD ~TIMERFD"

	use kernel_linux && linux-info_pkg_setup
}

src_prepare() {
	default
	xdg_environment_reset
}

src_configure() {
	local rccgroupmode="$(grep rc_cgroup_mode ${EPREFIX}/etc/rc.conf | cut -d '"' -f 2)"
	local cgroupmode="legacy"

	if [[ "xhybrid" = "x${rccgroupmode}" ]] ; then
		cgroupmode="hybrid"
	elif [[ "xunified" = "x${rccgroupmode}" ]] ; then
		cgroupmode="unified"
	fi

	local emesonargs=(
		$debugmode
		--buildtype $(usex debug debug release)
		--libdir="${EPREFIX}"/usr/$(get_libdir)
		-Dacl=$(usex acl true false)
		-Dbashcompletiondir="${EPREFIX}/usr/share/bash-completion/completions"
		-Dcgroup-controller=openrc
		-Ddefault-hierarchy=${cgroupmode}
		-Ddefault-kill-user-processes=true
		-Ddocdir="${EPREFIX}/usr/share/doc/${PF}"
		-Defi=$(usex efi true false)
		-Dhtml=$(usex doc auto false)
		-Dhtmldir="${EPREFIX}/usr/share/doc/${PF}/html"
		-Dman=auto
		-Dpam=$(usex pam true false)
		-Dpamlibdir=$(getpam_mod_dir)
		-Drootlibdir="${EPREFIX}"/$(get_libdir)
		-Drootlibexecdir="${EPREFIX}"/$(get_libdir)/elogind
		-Drootprefix="${EPREFIX}/"
		-Dselinux=$(usex selinux true false)
		-Dsmack=true
		-Dudevrulesdir="${EPREFIX}$(get_udevdir)"/rules.d
		-Dutmp=$(usex elibc_musl false true)
	)

	meson_src_configure
}

src_install() {
	DOCS+=( src/libelogind/sd-bus/GVARIANT-SERIALIZATION )

	meson_src_install

	newinitd "${FILESDIR}"/${PN}.init ${PN}

	sed -e "s/@libdir@/$(get_libdir)/" "${FILESDIR}"/${PN}.conf.in > ${PN}.conf || die
	newconfd ${PN}.conf ${PN}
}

pkg_postinst() {
	if [[ "$(rc-config list boot | grep elogind)" != "" ]]; then
		elog "elogind is currently started from boot runlevel."
	elif [[ "$(rc-config list default | grep elogind)" != "" ]]; then
		ewarn "elogind is currently started from default runlevel."
		ewarn "Please remove elogind from the default runlevel and"
		ewarn "add it to the boot runlevel by:"
		ewarn "# rc-update del elogind default"
		ewarn "# rc-update add elogind boot"
	else
		elog "elogind is currently not started from any runlevel."
		elog "You may add it to the boot runlevel by:"
		elog "# rc-update add elogind boot"
		elog
		elog "Alternatively, you can leave elogind out of any"
		elog "runlevel. It will then be started automatically"
		if use pam; then
			elog "when the first service calls it via dbus, or"
			elog "the first user logs into the system."
		else
			elog "when the first service calls it via dbus."
		fi
	fi
}
