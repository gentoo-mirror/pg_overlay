# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit readme.gentoo-r1 vcs-snapshot

DESCRIPTION="Bash commandline flac compressor, verifier, organizer, analyzer, retagger"
HOMEPAGE="https://github.com/sirjaren/redoflacs"
SRC_URI="https://github.com/sirjaren/${PN}/tarball/${PV} -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=app-shells/bash-4
	media-libs/flac
	sys-apps/coreutils"

src_prepare() {
	rm Makefile
	default
}

src_install() {
	dobin redoflacs
	doman redoflacs.1
	readme.gentoo_create_doc
}
