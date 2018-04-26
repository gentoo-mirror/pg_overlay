# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="CUE Sheet Parser Library"
HOMEPAGE="https://github.com/lipnitsk/libcue"
SRC_URI="https://github.com/lipnitsk/${PN}/archive/v${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86"
IUSE=""

RDEPEND=""
DEPEND="sys-devel/flex
	sys-devel/bison"

DOCS=( README.md  )
