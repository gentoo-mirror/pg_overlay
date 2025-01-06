# Copyright 2025 Vincent Ahluwalia
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="Openbox alternative for wayland"
HOMEPAGE="https://github.com/labwc/labwc"
SRC_URI="https://github.com/labwc/labwc/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+svg +icons X nls man test static_analyzer"

RESTRICT="network-sandbox"
RDEPEND="
	>=dev-libs/wayland-1.19.0
	>=gui-libs/wlroots-0.18.0[X?]
	dev-libs/libxml2
	dev-libs/glib
	x11-libs/cairo[X?]
	x11-libs/pango[X?]
	x11-libs/libdrm
	>=dev-libs/libinput-1.14.0
	x11-libs/libxkbcommon[X?]
	x11-libs/pixman
	media-libs/libpng
	nls? ( sys-devel/gettext )
	svg? ( >=gnome-base/librsvg-2.46.0 )
	X? ( x11-libs/libxcb )
	X? ( x11-base/xwayland )
"

DEPEND="${RDEPEND}"
BDEPEND="
	>=dev-build/meson-0.59.0
	dev-build/ninja
	>=dev-libs/wayland-protocols-1.35
	man? ( app-text/scdoc )
	test? ( dev-util/cmocka )
"

src_configure() {
	local emesonargs=(
		$(meson_feature X xwayland)
		$(meson_feature svg)
		$(meson_feature icons icon)
		$(meson_feature nls)
		$(meson_feature man man-pages)
		$(meson_feature test test)
		$(meson_feature static_analyzer)
	)
	if use icons ; then
		local emesonargs=(
			$(meson_feature X xwayland)
			$(meson_feature svg)
			$(meson_feature icons icon)
			$(meson_feature nls)
			$(meson_feature man man-pages)
			$(meson_feature test test)
			$(meson_feature static_analyzer)
			--wrap-mode=default
		)
	fi
	meson_src_configure
}
