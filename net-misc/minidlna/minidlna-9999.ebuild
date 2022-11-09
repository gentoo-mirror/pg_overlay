# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools git-r3 tmpfiles

DESCRIPTION="DLNA/UPnP-AV compliant media server"
HOMEPAGE="https://sourceforge.net/projects/minidlna/"
EGIT_REPO_URI="https://git.code.sf.net/p/${PN}/git"

LICENSE="BSD GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="netgear readynas zeroconf tivo"

DEPEND="
	dev-db/sqlite:3
	media-libs/flac:=
	media-libs/libexif
	media-libs/libid3tag:=
	media-libs/libjpeg-turbo:=
	media-libs/libogg
	media-libs/libvorbis
	media-video/ffmpeg:=
	elibc_musl? ( sys-libs/queue-standalone )
	zeroconf? ( net-dns/avahi )
"
RDEPEND="
	${DEPEND}
	acct-group/minidlna
	acct-user/minidlna
"
BDEPEND="
	virtual/pkgconfig
"

CONFIG_CHECK="~INOTIFY_USER"

PATCHES=(
	"${FILESDIR}"/minidlna-gentoo-artwork.patch
	# fix https://sourceforge.net/p/minidlna/bugs/297/
	"${FILESDIR}"/minidlna_listen_interface.patch
)

src_prepare() {
	sed -e "/log_dir/s:/var/log:/var/log/minidlna:" \
		-e "/db_dir/s:/var/cache/:/var/lib/:" \
		-i minidlna.conf || die

	default
	eautoreconf
}

src_configure() {
	local myconf=(
		--with-db-path=/var/lib/minidlna
		--with-log-path=/var/log/minidlna
		$(use_enable netgear)
		$(use_enable readynas)
		$(use_enable tivo)
		ac_cv_lib_id3tag__lz___id3_file_open=yes
		ac_cv_lib_avformat__lavcodec__lavutil__lz___av_open_input_file=yes
		ac_cv_lib_avformat__lavcodec__lavutil__lz___avformat_open_input=yes
	)
	use zeroconf || myconf+=(
		ac_cv_lib_avahi_client_avahi_threaded_poll_new=no
	)

	econf "${myconf[@]}"
}

src_test() {
	:
}

src_install() {
	default

	#bug 536532
	dosym ../sbin/minidlnad /usr/bin/minidlna

	insinto /etc
	doins minidlna.conf

	newconfd "${FILESDIR}"/minidlna-1.0.25.confd minidlna
	newinitd "${FILESDIR}"/minidlna-1.1.5.initd minidlna
	newtmpfiles - minidlna.conf <<-EOF
		d /run/minidlna 0755 minidlna minidlna -
	EOF

	keepdir /var/{lib,log}/minidlna

	doman minidlnad.8 minidlna.conf.5
}

pkg_preinst() {
	local my_is_new=yes
	[[ -d ${EROOT}/var/lib/minidlna ]] && my_is_new=no

	fowners minidlna:minidlna /var/{lib,log}/minidlna
	fperms 0750 /var/{lib,log}/minidlna
}

pkg_postinst() {
	tmpfiles_process minidlna.conf
}
