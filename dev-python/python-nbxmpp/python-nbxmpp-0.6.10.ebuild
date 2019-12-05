# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )

inherit distutils-r1 vcs-snapshot

DESCRIPTION="Python library to use Jabber/XMPP networks in a non-blocking way"
HOMEPAGE="https://dev.gajim.org/gajim/python-nbxmpp/"
SRC_URI="https://dev.gajim.org/gajim/python-nbxmpp/repository/archive.tar.gz?ref=nbxmpp-${PV} -> ${P}.tar.gz"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~alpha ~amd64 ~arm ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""
