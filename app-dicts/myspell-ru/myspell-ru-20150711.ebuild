# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MYSPELL_DICT=(
"russian-aot.dic"
"russian-aot.aff"
)

MYSPELL_HYPH=(
"hyph_ru_RU.dic"
)

MYSPELL_THES=(
ru_th_aot.dat
ru_th_aot.idx
)

inherit myspell-r2

DESCRIPTION="Russian dictionaries for myspell/hunspell"
LICENSE="LGPL-2.1 myspell-ru_RU-ALexanderLebedev"
HOMEPAGE="http://lingucomponent.openoffice.org/"
SRC_URI="http://extensions.libreoffice.org/extension-center/russian-dictionary-pack/releases/0.4.0/dict_pack_ru-aot-0-4-0.oxt"

SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sh sparc x86 ~amd64-fbsd ~amd64-linux ~x86-fbsd"
