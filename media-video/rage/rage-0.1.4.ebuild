# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit enlightenment

MY_P=${PN}-${PV/_/-}

DESCRIPTION="Video Player from Enlightenment"
HOMEPAGE="http://www.enlightenment.org/"
SRC_URI="http://download.enlightenment.org/rel/apps/${PN}/${MY_P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

S=${WORKDIR}/${MY_P}

DEPEND=">=dev-libs/efl-1.13.2[gstreamer]
  sys-devel/automake:1.14"
RDEPEND="${DEPEND}"