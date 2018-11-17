# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_HANDBOOK="forceoptional"
KDE_SELINUX_MODULE="games"
inherit kde5

DESCRIPTION="KDE patience game"
HOMEPAGE="https://games.kde.org/game.php?game=kpat"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	$(add_frameworks_dep kcompletion)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kcrash)
	$(add_frameworks_dep kdbusaddons)
	$(add_frameworks_dep kguiaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep knewstuff)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kxmlgui)
	$(add_kdeapps_dep libkdegames)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtsvg)
	$(add_qt_dep qtwidgets)
	x11-misc/shared-mime-info
"
RDEPEND="${DEPEND}"

src_prepare() {
	default

	sed -i '/freecell-solver$/d' CMakeLists.txt
	sed -i '/freecell-solver$/d' patsolve/solverinterface.h
	sed -i '/freecell-solver$/d' patsolve/freecellsolver.cpp
	sed -i '/freecell-solver$/d' patsolve/abstract_fc_solve_solver.cpp
	sed -i '/freecell-solver$/d' patsolve/simonsolver.cpp

	sed -i '/freecellsolver$/d' CMakeLists.txt
	sed -i '/freecellsolver$/d' freecell.cpp
	sed -i '/freecellsolver$/d' freecell.h
	sed -i '/freecellsolver$/d' patsolve/freecellsolver.cpp
	sed -i '/freecellsolver$/d' patsolve/freecellsolver.h

	sed -i 's/libfcs_SRCS//g' CMakeLists.txt
	sed -i '/fcs$/d' patsolve/solverinterface.h
	sed -i '/fcs$/d' patsolve/abstract_fc_solve_solver.h
	sed -i '/fcs$/d' patsolve/freecellsolver.cpp
	sed -i '/fcs$/d' patsolve/abstract_fc_solve_solver.cpp
	sed -i '/fcs$/d' patsolve/simonsolver.cpp
	sed -i '/fcs$/d' patsolve/simonsolver.h
	sed -i '/fcs$/d' patsolve/freecellsolver.h

	sed -i '/freecell_solver$/d' patsolve/freecellsolver.cpp
	sed -i '/freecell_solver$/d' patsolve/abstract_fc_solve_solver.cpp
	sed -i '/freecell_solver$/d' patsolve/simonsolver.cpp
}
