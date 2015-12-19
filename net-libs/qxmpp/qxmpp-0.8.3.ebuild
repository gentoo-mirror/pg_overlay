# Copyright 2002-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/qxmpp/qxmpp-0.8.0.ebuild,v 1.2 2014/06/28 12:58:19 maksbotan Exp $

EAPI=5

inherit qt4-r2 multibuild

DESCRIPTION="A cross-platform C++ XMPP client library based on the Qt framework."
HOMEPAGE="https://github.com/qxmpp-project/qxmpp/"
SRC_URI="https://github.com/qxmpp-project/qxmpp/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux"
IUSE="debug doc +qt4 qt5 +speex test theora vpx"

RDEPEND="qt4? ( dev-qt/qtcore:4 )
	qt5? ( dev-qt/qtcore:5 )
	speex? ( media-libs/speex )
	theora? ( media-libs/libtheora )
	vpx? ( media-libs/libvpx )"
DEPEND="${RDEPEND}
	test? (
			qt4? ( dev-qt/qttest:4 )
			qt5? ( dev-qt/qttest:5 )
		)"
REQUIRED_USE="|| ( qt4 qt5 )"

src_prepare(){
	if ! use doc; then
		sed -i \
			-e '/SUBDIRS/s/doc//' \
			-e '/INSTALLS/d' \
			qxmpp.pro || die "sed for removing docs failed"
	fi
	if ! use test; then
		sed -i -e '/SUBDIRS/s/tests//' \
			qxmpp.pro || die "sed for removing tests failed"
	fi
	# There is no point in building examples. Also, they require dev-qt/qtgui
	sed -i -e '/SUBDIRS/s/examples//' \
			qxmpp.pro || die "sed for removing examples failed"

	MULTIBUILD_VARIANTS=( )
	if use qt4; then
		MULTIBUILD_VARIANTS+=( qt4-shared )
	fi

	if use qt5; then
		MULTIBUILD_VARIANTS+=( qt5-shared )
	fi

	multibuild_copy_sources

	preparation() {
		case "${MULTIBUILD_VARIANT}" in
			qt4-*)
				sed \
					-e "s/QXMPP_LIBRARY_NAME = qxmpp/QXMPP_LIBRARY_NAME = qxmpp-qt4/g" \
					-i qxmpp.pri || die
				qt4-r2_src_prepare
			;;
			qt5-*)
				sed \
					-e "s/QXMPP_LIBRARY_NAME = qxmpp/QXMPP_LIBRARY_NAME = qxmpp-qt5/g" \
					-i qxmpp.pri || die
			;;
		esac
	}

	multibuild_foreach_variant run_in_build_dir preparation
}

src_configure(){
	local conf_speex
	local conf_theora
	local conf_vpx

	use speex && conf_speex="QXMPP_USE_SPEEX=1"
	use theora && conf_theora="QXMPP_USE_THEORA=1"
	use vpx && conf_vpx="QXMPP_USE_VPX=1"

	configuration() {
		case "${MULTIBUILD_VARIANT}" in
			qt4-*)
				eqmake4 "${BUILD_DIR}"/qxmpp.pro "PREFIX=${EPREFIX}/usr" "LIBDIR=$(get_libdir)" "${conf_speex}" "${conf_theora}" "${conf_vpx}"
			;;
			qt5-*)
				/usr/lib/qt5/bin/qmake "${BUILD_DIR}"/qxmpp.pro "PREFIX=${EPREFIX}/usr" "LIBDIR=$(get_libdir)" "${conf_speex}" "${conf_theora}" "${conf_vpx}"
			;;
		esac

	}
	multibuild_parallel_foreach_variant run_in_build_dir configuration
}

src_compile() {
	compilation() {
		case "${MULTIBUILD_VARIANT}" in
			qt4-*)
				qt4-r2_src_compile
			;;
			qt5-*)
				emake
			;;
		esac

	}
	multibuild_foreach_variant run_in_build_dir compilation
}
src_install() {
	installation() {
		case "${MULTIBUILD_VARIANT}" in
			qt4-*)
				qt4-r2_src_install
			;;
			qt5-*)
				emake INSTALL_ROOT="${D}" install
			;;
		esac
	}
	multibuild_foreach_variant run_in_build_dir installation

	if use doc; then
		# Use proper path for documentation
		mv "${ED}"/usr/share/doc/${PN} "${ED}"/usr/share/doc/${PF} || die "doc mv failed"
	fi
}
