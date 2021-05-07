# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P="${PN}-$(ver_rs 2 -)"
DESCRIPTION="Console S-Lang-based editor"
HOMEPAGE="http://www.jedsoft.org/jed/"
if [[ "${PV}" = *_pre* ]] ; then
	MY_P="${PN}-pre${PV/_pre/-}"
	SRC_URI="https://www.jedsoft.org/snapshots/${MY_P}.tar.gz"
	S="${WORKDIR}/${MY_P}"
else
	SRC_URI="http://www.jedsoft.org/releases/${PN}/${P}.tar.bz2
		http://www.jedsoft.org/releases/${PN}/old/${P}.tar.bz2"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x86-solaris"
fi
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~x86-macos"
IUSE="gpm gui xft"

RDEPEND=">=sys-libs/slang-2
	gpm? ( sys-libs/gpm )
	gui? (
		x11-libs/libX11
		xft? (
			>=media-libs/freetype-2
			x11-libs/libXft
		)
	)"
DEPEND="${RDEPEND}
	gui? (
		x11-libs/libXt
		x11-base/xorg-proto
	)"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	# replace IDE mode with EMACS mode
	sed -i -e 's/\(_Jed_Default_Emulation = \).*/\1"emacs";/' \
		lib/jed.conf || die
	eapply_user
}

src_configure() {
	econf \
		$(use_enable gpm) \
		$(use_enable xft) \
		JED_ROOT="${EPREFIX}"/usr/share/jed
}

src_compile() {
	emake
	use gui && emake xjed
}

src_install() {
	emake -j1 DESTDIR="${D}" install

	dodoc changes.txt INSTALL{,.unx} README
	doinfo info/jed*

	insinto /etc
	doins lib/jed.conf
}
