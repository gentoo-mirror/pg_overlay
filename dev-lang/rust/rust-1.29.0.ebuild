# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{5,6,7} pypy )

inherit multiprocessing multilib-build python-any-r1 toolchain-funcs versionator llvm

if [[ ${PV} = *beta* ]]; then
	betaver=${PV//*beta}
	BETA_SNAPSHOT="${betaver:0:4}-${betaver:4:2}-${betaver:6:2}"
	MY_P="rustc-beta"
	SLOT="beta/${PV}"
	SRC="${BETA_SNAPSHOT}/rustc-beta-src.tar.xz"
	KEYWORDS=""
else
	ABI_VER="$(get_version_component_range 1-2)"
	SLOT="stable/${ABI_VER}"
	MY_P="rustc-${PV}"
	SRC="${MY_P}-src.tar.xz"
	KEYWORDS="~amd64 ~arm64 ~x86"
fi

CHOST_amd64=x86_64-unknown-linux-gnu
CHOST_x86=i686-unknown-linux-gnu
CHOST_arm64=aarch64-unknown-linux-gnu

RUST_STAGE0_VERSION="${PV}" #Use current version for stage0
RUST_STAGE0_amd64="rust-${RUST_STAGE0_VERSION}-${CHOST_amd64}"
RUST_STAGE0_x86="rust-${RUST_STAGE0_VERSION}-${CHOST_x86}"
RUST_STAGE0_arm64="rust-${RUST_STAGE0_VERSION}-${CHOST_arm64}"

CARGO_DEPEND_VERSION="0.$(($(get_version_component_range 2) + 1)).0"

DESCRIPTION="Systems programming language from Mozilla"
HOMEPAGE="https://www.rust-lang.org/"

SRC_URI="https://static.rust-lang.org/dist/${SRC} -> rustc-${PV}-src.tar.xz
	amd64? ( https://static.rust-lang.org/dist/${RUST_STAGE0_amd64}.tar.xz )
	x86? ( https://static.rust-lang.org/dist/${RUST_STAGE0_x86}.tar.xz )
	arm64? ( https://static.rust-lang.org/dist/${RUST_STAGE0_arm64}.tar.xz )
"

ALL_LLVM_TARGETS=( AArch64 AMDGPU ARM BPF Hexagon Lanai Mips MSP430
	NVPTX PowerPC Sparc SystemZ X86 XCore )
ALL_LLVM_TARGETS=( "${ALL_LLVM_TARGETS[@]/#/llvm_targets_}" )
LLVM_TARGET_USEDEPS=${ALL_LLVM_TARGETS[@]/%/?}

LICENSE="|| ( MIT Apache-2.0 ) BSD-1 BSD-2 BSD-4 UoI-NCSA"

IUSE="cargo debug doc +jemalloc libressl rls rustfmt wasm ${ALL_LLVM_TARGETS[*]} system-llvm"

RDEPEND=">=app-eselect/eselect-rust-0.3_pre20150425
		jemalloc? ( dev-libs/jemalloc )
		cargo? (
			!libressl? ( dev-libs/openssl:0= )
			libressl? ( dev-libs/libressl:0= )
		)"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	|| (
		>=sys-devel/gcc-4.7
		>=sys-devel/clang-3.5
	)
	cargo? ( !dev-util/cargo )
	rustfmt? ( !dev-util/rustfmt )
	dev-util/cmake
	dev-util/ninja
"
PDEPEND="!cargo? ( >=dev-util/cargo-${CARGO_DEPEND_VERSION} )"

REQUIRED_USE="|| ( ${ALL_LLVM_TARGETS[*]} )"

S="${WORKDIR}/${MY_P}-src"

PATCHES=( "${FILESDIR}"/rust-52876-const-endianess.patch
	"${FILESDIR}"/0001-std-stop-backtracing-when-the-frames-are-full.patch
	"${FILESDIR}"/0001-Set-more-llvm-function-attributes-for-__rust_try.patch )

toml_usex() {
	usex "$1" true false
}

src_prepare() {
	local rust_stage0_root="${WORKDIR}"/rust-stage0

	local rust_stage0_name="RUST_STAGE0_${ARCH}"
	local rust_stage0="${!rust_stage0_name}"

	"${WORKDIR}/${rust_stage0}"/install.sh --disable-ldconfig --destdir="${rust_stage0_root}" --prefix=/ || die

	default

	if use system-llvm; then
		rm -rf src/llvm/
		# We never enable emscripten.
		rm -rf src/llvm-emscripten/
	fi

	# This tests a problem of exponential growth, which seems to be less-reliably
	# fixed when running on older LLVM and/or some arches.  Just skip it for now.
	sed -i.ignore -e '1i // ignore-test may still be exponential...' \
	src/test/run-pass/issue-41696.rs

	# The configure macro will modify some autoconf-related files, which upsets
	# cargo when it tries to verify checksums in those files.  If we just truncate
	# that file list, cargo won't have anything to complain about.
	find src/vendor -name .cargo-checksum.json \
	-exec sed -i.uncheck -e 's/"files":{[^}]*}/"files":{ }/' '{}' '+'
}

src_configure() {
	if use system-llvm; then
		export LLVM_LINK_SHARED=1
		local llvm_config="$(get_llvm_prefix)/bin/${CBUILD}-llvm-config"
	fi

	local rust_target="" rust_targets="" rust_target_name arch_cflags

	# Collect rust target names to compile standard libs for all ABIs.
	for v in $(multilib_get_enabled_abi_pairs); do
		rust_target_name="CHOST_${v##*.}"
		rust_targets="${rust_targets},\"${!rust_target_name}\""
	done
	if use wasm; then
		rust_targets="${rust_targets},\"wasm32-unknown-unknown\""
	fi
	rust_targets="${rust_targets#,}"

	local extended="false" tools=""
	if use cargo; then
		extended="true"
		tools="\"cargo\","
	fi
	if use rls; then
		extended="true"
		tools="\"rls\",$tools"
	fi
	if use rustfmt; then
		extended="true"
		tools="\"rustfmt\",$tools"
	fi

	local rust_stage0_root="${WORKDIR}"/rust-stage0

	rust_target_name="CHOST_${ARCH}"
	rust_target="${!rust_target_name}"

	cat <<- EOF > "${S}"/config.toml
		[llvm]
		enabled = true
		optimize = $(toml_usex !debug)
		thin-lto=true
		release-debuginfo = $(toml_usex debug)
		assertions = $(toml_usex debug)
		ninja = true
		targets = "${LLVM_TARGETS// /;}"
		link-jobs = $(makeopts_jobs)
		[build]
		build = "${rust_target}"
		host = ["${rust_target}"]
		target = [${rust_targets}]
		cargo = "${rust_stage0_root}/bin/cargo"
		rustc = "${rust_stage0_root}/bin/rustc"
		docs = $(toml_usex doc)
		compiler-docs = $(toml_usex doc)
		submodules = false
		python = "${EPYTHON}"
		locked-deps = false
		vendor = true
		extended = ${extended}
		tools = [${tools}]
		verbose = 0
		sanitizers = false
		profiler = false
		[install]
		prefix = "${EPREFIX}/usr"
		libdir = "$(get_libdir)"
		docdir = "share/doc/${P}"
		mandir = "share/${P}/man"
		[rust]
		debug = $(toml_usex debug)
		optimize = $(toml_usex !debug)
		codegen-units = 1
		debug-assertions = $(toml_usex debug)
		debuginfo = $(toml_usex debug)
		use-jemalloc = $(toml_usex jemalloc)
		backtrace = $(toml_usex debug)
		default-linker = "$(tc-getCC)"
		channel = "stable"
		rpath = false
		codegen-tests = $(toml_usex debug)
		dist-src = $(toml_usex debug)
		lld = $(toml_usex wasm)
		deny-warnings = false
	EOF

	for v in $(multilib_get_enabled_abi_pairs); do
		rust_target=$(get_abi_CHOST ${v##*.})
		arch_cflags="$(get_abi_CFLAGS ${v##*.})"

		cat <<- EOF >> "${S}"/config.env
			CFLAGS_${rust_target}=${arch_cflags}
		EOF

		cat <<- EOF >> "${S}"/config.toml
			[target.${rust_target}]
			cc = "$(tc-getBUILD_CC)"
			cxx = "$(tc-getBUILD_CXX)"
			linker = "$(tc-getCC)"
			ar = "$(tc-getAR)"
		EOF

		if use system-llvm; then
			cat <<- EOF >> "${S}"/config.toml
				llvm-config = "${llvm_config}"
			EOF
		fi
	done

	if use wasm; then
		cat <<- EOF >> "${S}"/config.toml
			[target.wasm32-unknown-unknown]
			linker = "lld"
		EOF

		if use system-llvm; then
			cat <<- EOF >> "${S}"/config.toml
				llvm-config = "${llvm_config}"
			EOF
		fi
	fi
}

src_compile() {
	env $(cat "${S}"/config.env)\
		./x.py build --config="${S}"/config.toml -j$(makeopts_jobs) \
		--exclude src/tools/miri || die # https://github.com/rust-lang/rust/issues/52305
}

src_install() {
	local rust_target abi_libdir

	env DESTDIR="${D}" ./x.py install || die

	mv "${D}/usr/bin/rustc" "${D}/usr/bin/rustc-${PV}" || die
	mv "${D}/usr/bin/rustdoc" "${D}/usr/bin/rustdoc-${PV}" || die
	mv "${D}/usr/bin/rust-gdb" "${D}/usr/bin/rust-gdb-${PV}" || die
	mv "${D}/usr/bin/rust-lldb" "${D}/usr/bin/rust-lldb-${PV}" || die
	if use cargo; then
		mv "${D}/usr/bin/cargo" "${D}/usr/bin/cargo-${PV}" || die
	fi
	if use rls; then
		mv "${D}/usr/bin/rls" "${D}/usr/bin/rls-${PV}" || die
	fi
	if use rustfmt; then
		mv "${D}/usr/bin/rustfmt" "${D}/usr/bin/rustfmt-${PV}" || die
		mv "${D}/usr/bin/cargo-fmt" "${D}/usr/bin/cargo-fmt-${PV}" || die
	fi

	# Copy shared library versions of standard libraries for all targets
	# into the system's abi-dependent lib directories because the rust
	# installer only does so for the native ABI.
	for v in $(multilib_get_enabled_abi_pairs); do
		if [ ${v##*.} = ${DEFAULT_ABI} ]; then
			continue
		fi
		abi_libdir=$(get_abi_LIBDIR ${v##*.})
		rust_target=$(get_abi_CHOST ${v##*.})
		mkdir -p "${D}/usr/${abi_libdir}"
		cp "${D}/usr/$(get_libdir)/rustlib/${rust_target}/lib"/*.so \
		   "${D}/usr/${abi_libdir}" || die
	done

	dodoc COPYRIGHT

	# FIXME:
	# Really not sure if that env is needed, specailly LDPATH
	cat <<-EOF > "${T}"/50${P}
		LDPATH="/usr/$(get_libdir)/${P}"
		MANPATH="/usr/share/${P}/man"
	EOF
	doenvd "${T}"/50${P}

	cat <<-EOF > "${T}/provider-${P}"
		/usr/bin/rustdoc
		/usr/bin/rust-gdb
		/usr/bin/rust-lldb
	EOF
	if use cargo; then
	    echo /usr/bin/cargo >> "${T}/provider-${P}"
	fi
	if use rls; then
	    echo /usr/bin/rls >> "${T}/provider-${P}"
	fi
	if use rustfmt; then
	    echo /usr/bin/rustfmt >> "${T}/provider-${P}"
	    echo /usr/bin/cargo-fmt >> "${T}/provider-${P}"
	fi
	dodir /etc/env.d/rust
	insinto /etc/env.d/rust
	doins "${T}/provider-${P}"
}

pkg_postinst() {
	eselect rust update --if-unset

	elog "Rust installs a helper script for calling GDB and LLDB,"
	elog "for your convenience it is installed under /usr/bin/rust-{gdb,lldb}-${PV}."

	if has_version app-editors/emacs || has_version app-editors/emacs-vcs; then
		elog "install app-emacs/rust-mode to get emacs support for rust."
	fi

	if has_version app-editors/gvim || has_version app-editors/vim; then
		elog "install app-vim/rust-vim to get vim support for rust."
	fi

	if has_version 'app-shells/zsh'; then
		elog "install app-shells/rust-zshcomp to get zsh completion for rust."
	fi
}

pkg_postrm() {
	eselect rust unset --if-invalid
}
