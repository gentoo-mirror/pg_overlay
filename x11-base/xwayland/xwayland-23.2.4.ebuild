# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="Standalone X server running under Wayland"
HOMEPAGE="https://wayland.freedesktop.org/xserver.html"
SRC_URI="https://xorg.freedesktop.org/archive/individual/xserver/${P}.tar.xz"

IUSE="libei rpc unwind xcsecurity selinux systemd video_cards_nvidia"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux"

COMMON_DEPEND="
	dev-libs/libbsd
	dev-libs/openssl:=
	>=dev-libs/wayland-1.21.0
	>=dev-libs/wayland-protocols-1.30
	media-fonts/font-util
	>=media-libs/libepoxy-1.5.4[X,egl(+)]
	media-libs/libglvnd[X]
	>=media-libs/mesa-21.1[X(+),egl(+),gbm(+)]
	>=x11-libs/libdrm-2.4.109
	>=x11-libs/libXau-1.0.4
	x11-libs/libxcvt
	>=x11-libs/libXfont2-2.0.1
	x11-libs/libxkbfile
	>=x11-libs/libxshmfence-1.1
	>=x11-libs/pixman-0.27.2
	>=x11-misc/xkeyboard-config-2.4.1-r3

	libei? ( dev-libs/libei )
	systemd? ( sys-apps/systemd )
	unwind? ( sys-libs/libunwind )
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

	libei? ( >=sys-apps/xdg-desktop-portal-1.18.0 )
	selinux? ( sec-policy/selinux-xserver )
"
BDEPEND="
	app-alternatives/lex
	dev-util/wayland-scanner
"

PATCHES=(
	"${FILESDIR}"/xwayland-drop-redundantly-installed-files.patch
	"${FILESDIR}"/xwayland-23.2.3-systemd-automagic.patch
)

src_configure() {
	local emesonargs=(
		$(meson_use rpc secure-rpc)
		$(meson_use unwind libunwind)
		$(meson_use xcsecurity)
		$(meson_use selinux xselinux)
		$(meson_use systemd)
		$(meson_use video_cards_nvidia xwayland_eglstream)
		-Ddri3=true
		-Ddrm=true
		-Dglamor=true
		-Dglx=true
		-Dlibdecor=false
		-Dxdmcp=false
		-Dxinerama=false
		-Dxv=true
		-Dxvfb=true
		-Ddtrace=false
		-Ddocs=false
		-Ddevel-docs=false
		-Ddocs-pdf=false
	)

	if use libei; then
		emesonargs+=( -Dxwayland_ei=portal )
	else
		emesonargs+=( -Dxwayland_ei=false )
	fi

	meson_src_configure
}

src_install() {
	dosym ../bin/Xwayland /usr/libexec/Xwayland

	meson_src_install
}
