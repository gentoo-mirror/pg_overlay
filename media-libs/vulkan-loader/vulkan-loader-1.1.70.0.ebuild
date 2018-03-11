# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python3_{4,5,6} )

if [[ "${PV}" == "9999" ]]; then
	EGIT_REPO_URI="https://github.com/KhronosGroup/Vulkan-LoaderAndValidationLayers.git"
	inherit git-r3
else
#	KEYWORDS="~amd64"
	SRC_URI="https://github.com/KhronosGroup/Vulkan-LoaderAndValidationLayers/archive/sdk-${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/Vulkan-LoaderAndValidationLayers-sdk-${PV}"
fi

inherit python-any-r1 cmake-multilib

DESCRIPTION="Vulkan Installable Client Driver (ICD) Loader"
HOMEPAGE="https://github.com/KhronosGroup/Vulkan-LoaderAndValidationLayers"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="wayland X"

RDEPEND=""
DEPEND="${PYTHON_DEPS}
	wayland? ( dev-libs/wayland:=[${MULTILIB_USEDEP}] )
	X? ( x11-libs/libX11:=[${MULTILIB_USEDEP}] )"

src_prepare() {
	cmake-utils_src_prepare
	# Change the search path to match dev-util/glslang
	sed -i -e 's@\("library_path": "\).@\1/usr/lib@' layers/linux/*.json
	# Use our system SPIRV-Tools (including generated commit_id)
	sed -i -e '/spirv_tools_commit_id\.h/d' CMakeLists.txt
	sed -i -e 's/\(spirv_tools_commit_id\.h\)/spirv-tools\/\1/' layers/shader_validation.h
	default
}

multilib_src_configure() {
	local mycmakeargs=(
		-DCMAKE_SKIP_RPATH=On
		-DBUILD_TESTS=Off
		-DBUILD_LAYERS=Off
		-DBUILD_DEMOS=Off
		-DBUILD_VKJSON=Off
		-DBUILD_LOADER=True
		-DBUILD_WSI_MIR_SUPPORT=Off
		-DBUILD_WSI_WAYLAND_SUPPORT=$(usex wayland)
		-DBUILD_WSI_XCB_SUPPORT=$(usex X)
		-DBUILD_WSI_XLIB_SUPPORT=$(usex X)
	)
	cmake-utils_src_configure
}

multilib_src_install() {
	keepdir /etc/vulkan/icd.d

	default
}
