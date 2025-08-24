# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
"

RUST_MIN_VER="1.85.0"

inherit cargo git-r3 virtualx

DESCRIPTION="Efficient Duplicate File Finder"
HOMEPAGE="https://github.com/pkolaczk/fclones"
EGIT_REPO_URI="https://github.com/pkolaczk/${PN}.git"

# questionable license for gtk gui assets
# https://github.com/qarmin/czkawka/issues/1029
LICENSE="MIT"
# Dependent crate licenses
LICENSE+="
	Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD-2 BSD Boost-1.0 ISC
	LGPL-2.1 LGPL-3 MIT MPL-2.0 UoI-NCSA Unicode-3.0 ZLIB
	|| ( GPL-3 )
"

SLOT="0"
KEYWORDS="~amd64"
IUSE=""
DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND="
	virtual/pkgconfig
"

QA_FLAGS_IGNORED=".*"

src_unpack() {
	git-r3_src_unpack
	cargo_live_src_unpack
}


#src_configure() {
#	cargo_src_configure --no-default-features --bin czkawka_cli $(usev gui "--bin czkawka_gui") --bin krokiet
#}

src_test() {
	virtx cargo_src_test
}

src_install() {
	dobin $(cargo_target_dir)/fclones
}
