# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg
EGO_SUM=(
	filippo.io/edwards25519 v1.1.0
	filippo.io/edwards25519 v1.1.0/go.mod
	github.com/coreos/go-systemd/v22 v22.5.0/go.mod
	github.com/davecgh/go-spew v1.1.1
	github.com/davecgh/go-spew v1.1.1/go.mod
	github.com/godbus/dbus/v5 v5.0.4/go.mod
	github.com/google/go-cmp v0.6.0
	github.com/google/go-cmp v0.6.0/go.mod
	github.com/google/uuid v1.6.0
	github.com/google/uuid v1.6.0/go.mod
	github.com/gorilla/websocket v1.5.0
	github.com/gorilla/websocket v1.5.0/go.mod
	github.com/mattn/go-colorable v0.1.13
	github.com/mattn/go-colorable v0.1.13/go.mod
	github.com/mattn/go-isatty v0.0.16/go.mod
	github.com/mattn/go-isatty v0.0.19
	github.com/mattn/go-isatty v0.0.19/go.mod
	github.com/mattn/go-sqlite3 v1.14.24
	github.com/mattn/go-sqlite3 v1.14.24/go.mod
	github.com/mdp/qrterminal v1.0.1
	github.com/mdp/qrterminal v1.0.1/go.mod
	github.com/pkg/errors v0.9.1/go.mod
	github.com/pmezard/go-difflib v1.0.0
	github.com/pmezard/go-difflib v1.0.0/go.mod
	github.com/rs/xid v1.5.0/go.mod
	github.com/rs/zerolog v1.33.0
	github.com/rs/zerolog v1.33.0/go.mod
	github.com/skip2/go-qrcode v0.0.0-20200617195104-da1b6568686e
	github.com/skip2/go-qrcode v0.0.0-20200617195104-da1b6568686e/go.mod
	github.com/stretchr/testify v1.10.0
	github.com/stretchr/testify v1.10.0/go.mod
	go.mau.fi/libsignal v0.1.1
	go.mau.fi/libsignal v0.1.1/go.mod
	go.mau.fi/util v0.8.4
	go.mau.fi/util v0.8.4/go.mod
	golang.org/x/crypto v0.32.0
	golang.org/x/crypto v0.32.0/go.mod
	golang.org/x/net v0.34.0
	golang.org/x/net v0.34.0/go.mod
	golang.org/x/sys v0.0.0-20220811171246-fbc7d0a398ab/go.mod
	golang.org/x/sys v0.6.0/go.mod
	golang.org/x/sys v0.12.0/go.mod
	golang.org/x/sys v0.29.0
	golang.org/x/sys v0.29.0/go.mod
	google.golang.org/protobuf v1.36.4
	google.golang.org/protobuf v1.36.4/go.mod
	gopkg.in/yaml.v3 v3.0.1
	gopkg.in/yaml.v3 v3.0.1/go.mod
	rsc.io/qr v0.2.0
	rsc.io/qr v0.2.0/go.mod
)

DESCRIPTION="Terminal-based Telegram / WhatsApp client for Linux and macOS"
HOMEPAGE="https://github.com/d99kris/nchat"
SRC_URI="https://github.com/d99kris/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

LANGUAGES="bn cs de es fr hu it ka nl pl pt_BR ru si tr uk"
for lang in ${LANGUAGES}; do
	IUSE+=" +l10n_${lang/_/-}"
done

RDEPEND="
	dev-libs/openssl
	dev-db/sqlite
	sys-libs/ncurses
	sys-libs/readline
"
DEPEND="${RDEPEND}
		dev-util/gperf
		sys-apps/file
		sys-apps/help2man
		sys-libs/zlib"

BDEPEND="dev-build/cmake
		dev-lang/go"

src_compile() {
	export GOCACHE="${T}/go-build"
	export GOFLAGS="-mod=vendor"
	cmake_src_compile
}
