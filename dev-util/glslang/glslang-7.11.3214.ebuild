# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-multilib cmake-utils

SNAPSHOT_COMMIT="c11e3156af2297f89a23c8db3f5e2323733ee556"
SRC_URI="https://github.com/KhronosGroup/${PN}/archive/${SNAPSHOT_COMMIT}.tar.gz -> ${P}.tar.gz"
KEYWORDS="amd64 x86"
S="${WORKDIR}/glslang-${SNAPSHOT_COMMIT}"

DESCRIPTION="Khronos reference front-end for GLSL and ESSL, and sample SPIR-V generator"
HOMEPAGE="https://www.khronos.org/opengles/sdk/tools/Reference-Compiler/"

LICENSE="BSD"
SLOT="0"
