# Copyright 2017-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES=""

inherit cargo git-r3 optfeature

DESCRIPTION="dua (-> Disk Usage Analyzer) is a tool to conveniently learn about the usage of disk space of a given directory"
HOMEPAGE="https://github.com/Byron/dua-cli"

EGIT_REPO_URI="https://github.com/Byron/${PN}.git"
KEYWORDS=""

LICENSE="MIT"
SLOT="0"
IUSE=""

DEPEND=""

RDEPEND="${DEPEND}"

src_unpack() {
	git-r3_src_unpack
	cargo_live_src_unpack
}

src_configure() {
	cargo_src_configure
}

src_compile() {
	cargo_src_compile
}

src_install() {
	cargo_src_install
}
