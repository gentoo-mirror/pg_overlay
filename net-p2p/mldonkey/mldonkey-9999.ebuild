# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools git-r3 flag-o-matic toolchain-funcs

DESCRIPTION="Multi-network P2P application written in Ocaml, with Gtk, web & telnet interface"
HOMEPAGE="http://mldonkey.sourceforge.net/ https://github.com/ygrek/mldonkey"
EGIT_REPO_URI="https://github.com/ygrek/${PN}.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""

IUSE="bittorrent doc fasttrack gd gnutella magic +ocamlopt upnp"

RDEPEND="dev-lang/perl
	dev-libs/crypto++
	dev-ml/camlp4:=
	gd? ( media-libs/gd:2=[truetype] )
	magic? ( sys-apps/file )
	upnp? (
		net-libs/libnatpmp
		net-libs/miniupnpc:=
	)
	acct-user/p2p
	app-arch/bzip2
	sys-libs/zlib
"
# Can't yet use newer OCaml
# -unsafe-string usage:
# https://github.com/ygrek/mldonkey/issues/46
DEPEND="${RDEPEND}
	<dev-lang/ocaml-5:=[ocamlopt?]
	bittorrent? ( dev-ml/num )
"

RESTRICT="!ocamlopt? ( strip )"

pkg_setup() {
	# dev-lang/ocaml creates its own objects but calls gcc for linking, which will
	# results in relocations if gcc wants to create a PIE executable
	if gcc-specs-pie ; then
		append-ldflags -nopie
		ewarn "Ocaml generates its own native asm, you're using a PIE compiler"
		ewarn "We have appended -nopie to ocaml build options"
		ewarn "because linking an executable with pie while the objects are not pic will not work"
	fi
}

src_prepare() {
	cd config || die
	eautoconf
	cd .. || die
	if ! use ocamlopt; then
		sed -i -e "s/ocamlopt/idontwantocamlopt/g" "${S}/config/configure" || die "failed to disable ocamlopt"
	fi

	default
}

src_configure() {
	append-cflags -std=gnu17

	local myconf=()

	local my_extra_libs
	if use gd; then
		my_extra_libs="-lpng"
	fi

	econf LIBS="${my_extra_libs}"\
		--sysconfdir=/etc/mldonkey \
		--sharedstatedir=/var/mldonkey \
		--localstatedir=/var/mldonkey \
		--enable-checks \
		--disable-batch \
		$(use_enable bittorrent) \
		$(use_enable fasttrack) \
		$(use_enable gnutella) \
		$(use_enable gnutella gnutella2) \
		$(use_enable gd) \
		$(use_enable magic) \
		$(use_enable upnp upnp-natpmp) \
		--disable-force-upnp-natpmp \
		--disable-gui
		${myconf[@]}
}

src_compile() {
	export OCAMLRUNPARAM="l=256M"
	emake -j1 # Upstream bug #48
	emake utils
}

src_install() {
	local myext i
	use ocamlopt || myext=".byte"
	for i in mlnet mld_hash get_range copysources subconv; do
		newbin "${i}${myext}" "${i}"
	done
	use bittorrent && newbin "make_torrent${myext}" make_torrent

	newconfd "${FILESDIR}/mldonkey.confd" mldonkey
	newinitd "${FILESDIR}/mldonkey.initd" mldonkey

	if use doc ; then
		docompress -x "/usr/share/doc/${PF}/scripts" "/usr/share/doc/${PF}/html"

		dodoc distrib/ChangeLog distrib/*.txt docs/*.txt docs/*.tex docs/*.pdf docs/developers/*.{txt,tex}

		docinto scripts
		dodoc distrib/{kill_mldonkey,mldonkey_command,mldonkey_previewer,make_buginfo}

		docinto html
		dodoc docs/*.html

		docinto html/images
		dodoc docs/images/*
	fi
}

pkg_postinst() {
	if [ -f /etc/conf.d/mldonkey ] && grep -qE "^(BASEDIR|SUBDIR|LOW_DOWN|LOW_UP|HIGH_DOWN|HIGH_UP|SERVER|PORT|TELNET_PORT|USERNAME|PASSWORD|MLDONKEY_TIMEOUT)=" /etc/conf.d/mldonkey; then
		ewarn "The following settings are deprecated and will be ignored,"
		ewarn "please remove them from /etc/conf.d/mldonkey:"
		ewarn "LOW_DOWN LOW_UP HIGH_DOWN HIGH_UP SERVER PORT TELNET_PORT USERNAME PASSWORD MLDONKEY_TIMEOUT"
	fi
}
