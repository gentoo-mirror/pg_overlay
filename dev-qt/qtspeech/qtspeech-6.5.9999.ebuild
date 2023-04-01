# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qt6-build

DESCRIPTION="Text-to-speech library for the Qt6 framework"

IUSE=""

RDEPEND="
	>=app-accessibility/speech-dispatcher-0.8.7
	=dev-qt/qtbase-${PV}*
"
DEPEND="${RDEPEND}"
