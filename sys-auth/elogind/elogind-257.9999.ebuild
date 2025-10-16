# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{13..14} )

inherit git-r3 linux-info meson pam python-any-r1 udev xdg-utils

DESCRIPTION="The systemd project's logind, extracted to a standalone package"
HOMEPAGE="https://github.com/elogind/elogind"
EGIT_REPO_URI="https://github.com/${PN}/${PN}.git"
EGIT_BRANCH="v257-stable"
EGIT_SUBMODULES=()

LICENSE="CC0-1.0 LGPL-2.1+ public-domain"
SLOT="0"
IUSE="+acl audit debug doc efi +pam +policykit selinux test +userdb"
RESTRICT="!test? ( test )"

BDEPEND="
	app-text/docbook-xml-dtd:4.2
	app-text/docbook-xml-dtd:4.5
	app-text/docbook-xsl-stylesheets
	dev-util/gperf
	virtual/pkgconfig
	$(python_gen_any_dep 'dev-python/jinja2[${PYTHON_USEDEP}]')
	$(python_gen_any_dep 'dev-python/lxml[${PYTHON_USEDEP}]')
"
DEPEND="
	audit? ( sys-process/audit )
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

DOCS=( README.md )

PATCHES=(
	# all downstream patches:
	"${FILESDIR}/${PN}-252.9-nodocs.patch"
)

python_check_deps() {
	python_has_version "dev-python/jinja2[${PYTHON_USEDEP}]" &&
	python_has_version "dev-python/lxml[${PYTHON_USEDEP}]"
}

pkg_setup() {
	local CONFIG_CHECK="~CGROUPS ~EPOLL ~INOTIFY_USER ~SIGNALFD ~TIMERFD"

	use kernel_linux && linux-info_pkg_setup
}

src_prepare() {
	default
	xdg_environment_reset
}

src_configure() {

	python_setup

	EMESON_BUILDTYPE="$(usex debug debug release)"

	# Removed -Ddefault-hierarchy=${cgroupmode}
	# -> It is deprecated and will be ignored by the build system
	local emesonargs=(
		$(usex debug "-Ddebug-extra=elogind" "")
		-Ddocdir="${EPREFIX}/usr/share/doc/${PF}"
		-Dhtmldir="${EPREFIX}/usr/share/doc/${PF}/html"
		-Dudevrulesdir="${EPREFIX}$(get_udevdir)"/rules.d
		--libexecdir="lib/elogind"
		--localstatedir="${EPREFIX}"/var
		-Dbashcompletiondir="${EPREFIX}/usr/share/bash-completion/completions"
		-Dman=auto
		-Dsmack=false
		-Dcgroup-controller=openrc
		-Ddefault-kill-user-processes=true
		-Dacl=$(usex acl enabled disabled)
		-Daudit=$(usex audit enabled disabled)
		-Defi=$(usex efi true false)
		-Dhtml=$(usex doc auto disabled)
		-Dpam=$(usex pam enabled disabled)
		-Dpamlibdir="$(getpam_mod_dir)"
		-Dselinux=$(usex selinux enabled disabled)
		-Dtests=$(usex test true false)
		-Duserdb=$(usex userdb true false)
		-Dutmp=$(usex elibc_musl false true)
		-Dmode=release
		-Defi=true
		-Dzshcompletiondir=""
		-Db_lto=true
	)

	meson_src_configure
}

src_install() {
	meson_src_install

	keepdir /var/lib/elogind

	newinitd "${FILESDIR}"/${PN}.init ${PN}
	newconfd "${FILESDIR}"/${PN}.conf ${PN}

	if use userdb; then
		newinitd "${FILESDIR}"/${PN}-userdbd.init ${PN}-userdbd
		newconfd "${FILESDIR}"/${PN}-userdbd.conf ${PN}-userdbd
	fi
}

pkg_postinst() {
	udev_reload
	if ! use pam; then
		ewarn "${PN} will not be managing user logins/seats without USE=\"pam\"!"
		ewarn "In other words, it will be useless for most applications."
		ewarn
	fi
	if ! use policykit; then
		ewarn "loginctl will not be able to perform privileged operations without"
		ewarn "USE=\"policykit\"! That means e.g. no suspend or hibernate."
		ewarn
	fi
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

	for version in ${REPLACING_VERSIONS}; do
		if ver_test "${version}" -lt 255.3; then
			elog "Starting with release 255.3 the sleep configuration is now done"
			elog "in the /etc/elogind/sleep.conf while the elogind additions have"
			elog "been moved to /etc/elogind/sleep.conf.d/10-elogind.conf."
			elog "Should you use non-default sleep configuration remember to migrate"
			elog "those to a new configuration file in /etc/elogind/sleep.conf.d/."
		fi
	done

	local file files
	# find custom hooks excluding known (nvidia-drivers, sys-power/tlp)
	if [[ -d "${EROOT}"/$(get_libdir)/elogind/system-sleep ]]; then
		readarray -t files < <(find "${EROOT}"/$(get_libdir)/elogind/system-sleep/ \
		          -type f \( -not -iname ".keep_dir" -a \
		          -not -iname "nvidia" -a \
		          -not -iname "49-tlp-sleep" \) || die)
	fi
	if [[ ${#files[@]} -gt 0 ]]; then
		ewarn "*** Custom hooks in obsolete path detected ***"
		for file in "${files[@]}"; do
			ewarn "    ${file}"
		done
		ewarn "Move these custom hooks to ${EROOT}/etc/elogind/system-sleep/ instead."
	fi
}

pkg_postrm() {
	udev_reload
}
