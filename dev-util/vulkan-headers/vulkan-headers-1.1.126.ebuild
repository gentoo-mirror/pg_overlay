# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

if [[ "${PV}" == "9999" ]]; then
	EGIT_REPO_URI="https://github.com/KhronosGroup/Vulkan-Headers.git"
	inherit git-r3
else
	EGIT_COMMIT="737f4c1cd96283747967c2024a0108b742214455"
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://github.com/KhronosGroup/Vulkan-Headers/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/Vulkan-Headers-${PV}"
fi

DESCRIPTION="Vulkan Header files and API registry"
HOMEPAGE="https://github.com/KhronosGroup/Vulkan-Headers"

LICENSE="Apache-2.0"
SLOT="0"
