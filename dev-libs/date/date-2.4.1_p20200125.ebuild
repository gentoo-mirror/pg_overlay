# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit cmake-utils git-r3

DESCRIPTION="A date and time library based on the C++11/14/17 <chrono> header "
HOMEPAGE="https://github.com/HowardHinnant/date"
EGIT_REPO_URI="https://github.com/HowardHinnant/date.git"
EGIT_COMMIT="9a0ee2542848ab8625984fc8cdbfb9b5414c0082"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

src_prepare()
{
	eapply "${FILESDIR}/538-output-date-pc-for-pkg-config.patch"
	cmake-utils_src_prepare
}

src_configure()
{
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=true
		-DBUILD_TZ_LIB=true
		-DUSE_SYSTEM_TZ_DB=true
	)
	cmake-utils_src_configure
}
