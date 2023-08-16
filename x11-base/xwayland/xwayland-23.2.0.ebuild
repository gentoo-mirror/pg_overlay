# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="Standalone X server running under Wayland"
HOMEPAGE="https://wayland.freedesktop.org/xserver.html"
SRC_URI="https://xorg.freedesktop.org/archive/individual/xserver/${P}.tar.xz"

IUSE="rpc unwind ipv6 xcsecurity selinux video_cards_nvidia"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux"

COMMON_DEPEND="
	dev-libs/libbsd
	dev-libs/openssl:=
	>=dev-libs/wayland-1.21.0
	>=dev-libs/wayland-protocols-1.28
	media-fonts/font-util
	>=media-libs/libepoxy-1.5.4[X,egl(+)]
	media-libs/libglvnd[X]
	>=media-libs/mesa-21.1[X(+)]
	rpc? ( net-libs/libtirpc )
	unwind? ( sys-libs/libunwind )
	>=x11-libs/libXau-1.0.4
	x11-libs/libxcvt
	>=x11-libs/libXfont2-2.0.1
	>=x11-libs/libdrm-2.4.89
	x11-libs/libxkbfile
	>=x11-libs/libxshmfence-1.1
	>=x11-libs/pixman-0.27.2
	video_cards_nvidia? ( gui-libs/egl-wayland )
"
DEPEND="
	${COMMON_DEPEND}
	>=x11-base/xorg-proto-2022.2
	>=x11-libs/xtrans-1.3.5
"
RDEPEND="
	${COMMON_DEPEND}
	x11-apps/xkbcomp
	!<=x11-base/xorg-server-1.20.11
	selinux? ( sec-policy/selinux-xserver )
"
BDEPEND="
	sys-devel/flex
	dev-util/wayland-scanner
"

PATCHES=(
	"${FILESDIR}"/xwayland-drop-redundantly-installed-files.patch
)

src_configure() {
	local emesonargs=(
		$(meson_use rpc secure-rpc)
		$(meson_use unwind libunwind)
		$(meson_use ipv6)
		$(meson_use xcsecurity)
		$(meson_use selinux xselinux)
		$(meson_use video_cards_nvidia xwayland_eglstream)
		-Ddri3=true
		-Ddrm=true
		-Dglamor=true
		-Dglx=true
		-Dxdmcp=false
		-Dxinerama=false
		-Dxv=true
		-Dxvfb=true
		-Ddtrace=false
		-Ddocs=false
		-Ddevel-docs=false
		-Ddocs-pdf=false
		-Dlibdecor=false
	)

	meson_src_configure
}

src_install() {
	meson_src_install
}
