# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit systemd

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="git://linux-nfs.org/~steved/rpcbind.git"
	inherit autotools git-r3
else
	SRC_URI="https://git.linux-nfs.org/?p=steved/rpcbind.git;a=snapshot;h=74da58dde5b1a1a7e54df1fb16315845195a69c0;sf=tgz -> ${P}.tar.gz"
	KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"
fi

DESCRIPTION="portmap replacement which supports RPC over various protocols"
HOMEPAGE="https://sourceforge.net/projects/rpcbind/"

LICENSE="BSD"
SLOT="0"
IUSE="debug remotecalls selinux systemd tcpd warmstarts"
REQUIRED_USE="systemd? ( warmstarts )"

DEPEND=">=net-libs/libtirpc-0.2.3:=
	systemd? ( sys-apps/systemd:= )
	tcpd? ( sys-apps/tcp-wrappers )"
RDEPEND="${DEPEND}
	selinux? ( sec-policy/selinux-rpcbind )"
BDEPEND="
	virtual/pkgconfig"

S=${WORKDIR}/${PN}-74da58d

src_prepare() {
	default
	[[ ${PV} == "9999" ]] && eautoreconf
}

src_configure() {
	local myeconfargs=(
		--bindir="${EPREFIX}"/sbin
		--sbindir="${EPREFIX}"/sbin
		--with-statedir="${EPREFIX}"/run/${PN}
		--with-systemdsystemunitdir=$(usex systemd "$(systemd_get_systemunitdir)" "no")
		$(use_enable debug)
		$(use_enable remotecalls rmtcalls)
		$(use_enable warmstarts)
		$(use_enable tcpd libwrap)
	)

	# Avoid using rpcsvc headers
	# https://bugs.gentoo.org/705224
	export ac_cv_header_rpcsvc_mount_h=no

	econf "${myeconfargs[@]}"
}

src_install() {
	default

	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
}
