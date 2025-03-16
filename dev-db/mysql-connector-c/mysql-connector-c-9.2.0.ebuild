# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib flag-o-matic

DESCRIPTION="C client library for MariaDB/MySQL"
HOMEPAGE="https://dev.mysql.com/downloads/"

if [[ ${PV} == "9999" ]]; then
	EGIT_REPO_URI="https://github.com/mysql/mysql-server.git"

	inherit git-r3
else
	SRC_URI="https://dev.mysql.com/get/Downloads/Connector-C++/${PN}++-${PV}-src.tar.gz"
	KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86"
	S="${WORKDIR}/${PN}++-${PV}-src"
fi

LICENSE="GPL-2"
SLOT="0/21"
IUSE="ldap static-libs"

RDEPEND="
	>=app-arch/lz4-1.9.4:=[${MULTILIB_USEDEP}]
	app-arch/zstd:=[${MULTILIB_USEDEP}]
	dev-libs/openssl:=[${MULTILIB_USEDEP}]
	>=sys-libs/zlib-1.2.13:=[${MULTILIB_USEDEP}]
	ldap? ( dev-libs/cyrus-sasl:=[${MULTILIB_USEDEP}] )
"
DEPEND="${RDEPEND}"
# Avoid file collisions, #692580
RDEPEND+="
	!<dev-db/mysql-5.6.45-r1
	!=dev-db/mysql-5.7.23*
	!=dev-db/mysql-5.7.24*
	!=dev-db/mysql-5.7.25*
	!=dev-db/mysql-5.7.26-r0
	!=dev-db/mysql-5.7.27-r0
	!<dev-db/percona-server-5.7.26.29-r1
"

DOCS=( README.md )

# Wrap the config script
MULTILIB_CHOST_TOOLS=( /usr/bin/mysql_config )

src_prepare() {
	cmake_src_prepare
}

multilib_src_configure() {
	# Code is now requiring C++20 due to https://github.com/mysql/mysql-server/commit/236ab55bedd8c9eacd80766d85edde2a8afacd08
	append-cxxflags -std=c++20

	local mycmakeargs=(
		-DCMAKE_C_FLAGS_RELWITHDEBINFO=-DNDEBUG
		-DCMAKE_CXX_FLAGS_RELWITHDEBINFO=-DNDEBUG
		-DINSTALL_LAYOUT=RPM
		-DINSTALL_LIBDIR=$(get_libdir)
		-DWITH_DEFAULT_COMPILER_OPTIONS=OFF
		-DENABLED_LOCAL_INFILE=ON
		-DMYSQL_UNIX_ADDR="${EPREFIX}/run/mysqld/mysqld.sock"
		# Automagically uses LLD with not using LTO (bug #710272, #775845)
		-DUSE_LD_LLD=OFF
		-DWITH_LZ4=system
		-DWITH_NUMA=OFF
		-DWITH_SSL=system
		-DWITH_ZLIB=system
		-DWITH_ZSTD=system
		-DLIBMYSQL_OS_OUTPUT_NAME=mysqlclient
		-DSHARED_LIB_PATCH_VERSION="0"
		-DCMAKE_POSITION_INDEPENDENT_CODE=ON
		-DWITHOUT_SERVER=ON
		-DWITH_BUILD_ID=OFF
	)

	cmake_src_configure
}

multilib_src_install_all() {
	# Not a GNU info file, more like a tiny README.
	#rm "${ED}"/usr/share/info/mysql.info || die

	doman \
		man/my_print_defaults.1 \
		man/perror.1 \
		man/zlib_decompress.1

	if ! use static-libs ; then
		find "${ED}" -name "*.a" -delete || die
	fi
}
