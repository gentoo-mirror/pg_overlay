# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit git-r3 autotools

DESCRIPTION="Vertex is a theme for GTK 3, GTK 2, Gnome-Shell, Cinnamon and xfce4"
HOMEPAGE="https://github.com/horst3180/Vertex-theme"
SRC_URI=""
EGIT_REPO_URI="git://github.com/horst3180/Vertex-theme.git"
LICENSE="GPL-3"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+cinnamon +vertex_dark gnome-shell gtk2 +gtk3 vertex_light metacity unity xfwm"

DEPEND=">=x11-libs/gtk+-3.12.2
	>=x11-themes/gtk-engines-murrine-0.98.2-r1"
RDEPEND="${DEPEND}"

src_prepare() {
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable cinnamon cinnamon) \
		$(use_enable vertex_dark dark) \
		$(use_enable gnome-shell gnome-shell) \
		$(use_enable gtk2 gtk2) \
		$(use_enable gtk3 gtk3) \
		$(use_enable vertex_light light)\
		$(use_enable vertex_dark dark) \
		$(use_enable metacity metacity) \
		$(use_enable unity unity)  \
		$(use_enable xfwm xfwm) \
		--with-gnome=3.20
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc AUTHORS ChangeLog README.md
}

pkg_preinst() {
	if ! has_version "=${CATEGORY}/${P}"; then
		first_install="1"
	fi
}

pkg_postinst() {
	if [[ "${first_install}" == "1" ]]; then
		ewarn ""
		ewarn "This theme provides custom themes for chrome/chromium and Firefox."
		ewarn "You can find them in the respective theme directoy."
		ewarn "Example:"
		ewarn "/usr/share/themes/Vertex/Chrome/Vertex.crx"
		ewarn "Drag&Drop it in your running chrome/chromium browser window to install it."
		ewarn ""
		ewarn "For Firefox copy /usr/share/themes/Vertex/Firefox/chrome to your profile folder. (~/.mozilla/firefox/????????.default/)"
		ewarn ""
	fi
}
