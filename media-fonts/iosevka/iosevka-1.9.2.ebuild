# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit font unpacker

DESCRIPTION="Open source coding font"
HOMEPAGE="http://be5invis.github.io/Iosevka "
SRC_URI="https://github.com/be5invis/Iosevka/releases/download/v${PV}/${PN}-pack-${PV}.7z"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE=""
RESTRICT="binchecks strip"

DEPEND=""
RDEPEND=""

FONT_SUFFIX="ttf"
