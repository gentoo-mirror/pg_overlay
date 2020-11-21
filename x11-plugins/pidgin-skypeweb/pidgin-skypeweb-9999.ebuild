# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit git-r3

DESCRIPTION="SkypeWeb Plugin for Pidgin"
HOMEPAGE="https://github.com/EionRobb/skype4pidgin"
EGIT_REPO_URI="https://github.com/EionRobb/skype4pidgin.git"
LICENSE="GPL-3+"
SLOT="0"

RDEPEND="net-im/pidgin
	dev-libs/json-glib"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S="$S/skypeweb"
