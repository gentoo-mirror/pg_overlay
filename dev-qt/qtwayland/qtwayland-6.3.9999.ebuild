# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qt6-build

DESCRIPTION="Provides APIs for Wayland"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64"
fi

DEPEND="
	=dev-qt/declataive-${PV}*
"
RDEPEND="${DEPEND}"

# TODO: qml/quick automagic
