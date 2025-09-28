# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES=""

inherit cargo git-r3 optfeature

DESCRIPTION="A tool to conveniently learn about the disk usage of directories, fast!"
HOMEPAGE="https://github.com/Byron/dua-cli"

EGIT_REPO_URI="https://github.com/Byron/${PN}.git"
KEYWORDS=""

LICENSE="MIT"
SLOT="0"
IUSE=""

QA_FLAGS_IGNORED="usr/bin/dua"

DOCS=(
	README.md
	CHANGELOG.md
)

src_install() {
	cargo_src_install
	dodoc -r "${DOCS[@]}"
}
