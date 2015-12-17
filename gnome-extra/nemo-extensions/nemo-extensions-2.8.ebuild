# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="Extensions for Cinnamon's file-manager Nemo"
HOMEPAGE="https://github.com/linuxmint/nemo-extensions/"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="+fileroller +compare +terminal"

DEPEND=""

RDEPEND="${DEPEND}
		compare? ( >=gnome-extra/nemo-compare-2.8.0 )
		fileroller? ( >=gnome-extra/nemo-fileroller-2.8.0 )
		terminal? ( >=gnome-extra/nemo-terminal-2.8.0 )
		"
