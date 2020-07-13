# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils git-r3

DESCRIPTION="CDEmu manager front end for KF5"
HOMEPAGE="https://github.com/Real-Gecko/KDE-CDEmu"

EGIT_REPO_URI="https://github.com/Real-Gecko/KDE-CDEmu.git"

LICENSE="GPLv3"
SLOT="0"
IUSE=""
REQUIRED_USE=""

RDEPEND="
	dev-qt/qtwidgets:5
	kde-frameworks/ki18n
	kde-frameworks/kcoreaddons
	kde-frameworks/knotifications
	kde-frameworks/kxmlgui
	kde-frameworks/kconfigwidgets
	kde-frameworks/kwidgetsaddons
	kde-frameworks/kdbusaddons
"
DEPEND="${RDEPEND}"

DOCS=(ChangeLog.md README.md)
