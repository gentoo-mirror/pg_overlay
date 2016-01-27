emerge --sync
emerge -1uDN --changed-use --changed-deps=y --with-bdeps=y --keep-going=y --exclude sys-kernel/gentoo-sources @system
emerge -1uDN --changed-use --changed-deps=y --with-bdeps=y --keep-going=y --exclude sys-kernel/gentoo-sources @selected
emerge -1uDN --changed-use --changed-deps=y --with-bdeps=y --keep-going=y --exclude sys-kernel/gentoo-sources @world
smart-live-rebuild
CONFIG_PROTECT="-*" emerge --clean --deep
CONFIG_PROTECT="-*" emerge --depclean --deep
emerge -1 --keep-going=y @preserved-rebuild
revdep-rebuild
env-update
eclean --destructive distfiles