#!/bin/sh

PROGRESS_CURR=0
PROGRESS_TOTAL=29                          

# This file was autowritten by rmlint
# rmlint was executed from: /home/MZ7WD240HAFV/pg_overlay/
# Your command line was: rmlint

RMLINT_BINARY="/usr/bin/rmlint"

# Only use sudo if we're not root yet:
# (See: https://github.com/sahib/rmlint/issues/27://github.com/sahib/rmlint/issues/271)
SUDO_COMMAND="sudo"
if [ "$(id -u)" -eq "0" ]
then
  SUDO_COMMAND=""
fi

USER='perfect_gentleman_007'
GROUP='perfect_gentleman_007'

# Set to true on -n
DO_DRY_RUN=

# Set to true on -p
DO_PARANOID_CHECK=

# Set to true on -r
DO_CLONE_READONLY=

# Set to true on -q
DO_SHOW_PROGRESS=true

# Set to true on -c
DO_DELETE_EMPTY_DIRS=

##################################
# GENERAL LINT HANDLER FUNCTIONS #
##################################

COL_RED='[0;31m'
COL_BLUE='[1;34m'
COL_GREEN='[0;32m'
COL_YELLOW='[0;33m'
COL_RESET='[0m'

print_progress_prefix() {
    if [ -n "$DO_SHOW_PROGRESS" ]; then
        PROGRESS_PERC=0
        if [ $((PROGRESS_TOTAL)) -gt 0 ]; then
            PROGRESS_PERC=$((PROGRESS_CURR * 100 / PROGRESS_TOTAL))
        fi
        printf '%s[%3d%%]%s ' "${COL_BLUE}" "$PROGRESS_PERC" "${COL_RESET}"
        if [ $# -eq "1" ]; then
            PROGRESS_CURR=$((PROGRESS_CURR+$1))
        else
            PROGRESS_CURR=$((PROGRESS_CURR+1))
        fi
    fi
}

handle_emptyfile() {
    print_progress_prefix
    echo "${COL_GREEN}Deleting empty file:${COL_RESET} $1"
    if [ -z "$DO_DRY_RUN" ]; then
        rm -f "$1"
    fi
}

handle_emptydir() {
    print_progress_prefix
    echo "${COL_GREEN}Deleting empty directory: ${COL_RESET}$1"
    if [ -z "$DO_DRY_RUN" ]; then
        rmdir "$1"
    fi
}

handle_bad_symlink() {
    print_progress_prefix
    echo "${COL_GREEN} Deleting symlink pointing nowhere: ${COL_RESET}$1"
    if [ -z "$DO_DRY_RUN" ]; then
        rm -f "$1"
    fi
}

handle_unstripped_binary() {
    print_progress_prefix
    echo "${COL_GREEN} Stripping debug symbols of: ${COL_RESET}$1"
    if [ -z "$DO_DRY_RUN" ]; then
        strip -s "$1"
    fi
}

handle_bad_user_id() {
    print_progress_prefix
    echo "${COL_GREEN}chown ${USER}${COL_RESET} $1"
    if [ -z "$DO_DRY_RUN" ]; then
        chown "$USER" "$1"
    fi
}

handle_bad_group_id() {
    print_progress_prefix
    echo "${COL_GREEN}chgrp ${GROUP}${COL_RESET} $1"
    if [ -z "$DO_DRY_RUN" ]; then
        chgrp "$GROUP" "$1"
    fi
}

handle_bad_user_and_group_id() {
    print_progress_prefix
    echo "${COL_GREEN}chown ${USER}:${GROUP}${COL_RESET} $1"
    if [ -z "$DO_DRY_RUN" ]; then
        chown "$USER:$GROUP" "$1"
    fi
}

###############################
# DUPLICATE HANDLER FUNCTIONS #
###############################

check_for_equality() {
    if [ -f "$1" ]; then
        # Use the more lightweight builtin `cmp` for regular files:
        cmp -s "$1" "$2"
        echo $?
    else
        # Fallback to `rmlint --equal` for directories:
        "$RMLINT_BINARY" -p --equal  --no-followlinks "$1" "$2"
        echo $?
    fi
}

original_check() {
    if [ ! -e "$2" ]; then
        echo "${COL_RED}^^^^^^ Error: original has disappeared - cancelling.....${COL_RESET}"
        return 1
    fi

    if [ ! -e "$1" ]; then
        echo "${COL_RED}^^^^^^ Error: duplicate has disappeared - cancelling.....${COL_RESET}"
        return 1
    fi

    # Check they are not the exact same file (hardlinks allowed):
    if [ "$1" = "$2" ]; then
        echo "${COL_RED}^^^^^^ Error: original and duplicate point to the *same* path - cancelling.....{COL_RESET}"
        return 1
    fi

    # Do double-check if requested:
    if [ -z "$DO_PARANOID_CHECK" ]; then
        return 0
    else
        if [ "$(check_for_equality "$1" "$2")" -ne "0" ]; then
            echo "${COL_RED}^^^^^^ Error: files no longer identical - cancelling.....${COL_RESET}"
        fi
    fi
}

cp_symlink() {
    print_progress_prefix
    echo "${COL_YELLOW}Symlinking to original: ${COL_RESET}$1"
    if original_check "$1" "$2"; then
        if [ -z "$DO_DRY_RUN" ]; then
            # replace duplicate with symlink
            rm -rf "$1"
            ln -s "$2" "$1"
            # make the symlink's mtime the same as the original
            touch -mr "$2" -h "$1"
        fi
    fi
}

cp_hardlink() {
    if [ -d "$1" ]; then
        # for duplicate dir's, can't hardlink so use symlink
        cp_symlink "$@"
        return $?
    fi
    print_progress_prefix
    echo "${COL_YELLOW}Hardlinking to original: ${COL_RESET}$1"
    if original_check "$1" "$2"; then
        if [ -z "$DO_DRY_RUN" ]; then
            # replace duplicate with hardlink
            rm -rf "$1"
            ln "$2" "$1"
        fi
    fi
}

cp_reflink() {
    if [ -d "$1" ]; then
        # for duplicate dir's, can't clone so use symlink
        cp_symlink "$@"
        return $?
    fi
    print_progress_prefix
    # reflink $1 to $2's data, preserving $1's  mtime
    echo "${COL_YELLOW}Reflinking to original: ${COL_RESET}$1"
    if original_check "$1" "$2"; then
        if [ -z "$DO_DRY_RUN" ]; then
            touch -mr "$1" "$0"
            if [ -d "$1" ]; then
                rm -rf "$1"
            fi
            cp --archive --reflink=always "$2" "$1"
            touch -mr "$0" "$1"
        fi
    fi
}

clone() {
    print_progress_prefix
    # clone $1 from $2's data
    # note: no original_check() call because rmlint --dedupe takes care of this
    echo "${COL_YELLOW}Cloning to: ${COL_RESET}$1"
    if [ -z "$DO_DRY_RUN" ]; then
        if [ -n "$DO_CLONE_READONLY" ]; then
            $SUDO_COMMAND $RMLINT_BINARY --dedupe  --dedupe-readonly "$2" "$1"
        else
            $RMLINT_BINARY --dedupe  "$2" "$1"
        fi
    fi
}

skip_hardlink() {
    print_progress_prefix
    echo "${COL_BLUE}Leaving as-is (already hardlinked to original): ${COL_RESET}$1"
}

skip_reflink() {
    print_progress_prefix
    echo "{$COL_BLUE}Leaving as-is (already reflinked to original): ${COL_RESET}$1"
}

user_command() {
    print_progress_prefix

    echo "${COL_YELLOW}Executing user command: ${COL_RESET}$1"
    if [ -z "$DO_DRY_RUN" ]; then
        # You can define this function to do what you want:
        echo 'no user command defined.'
    fi
}

remove_cmd() {
    print_progress_prefix
    echo "${COL_YELLOW}Deleting: ${COL_RESET}$1"
    if original_check "$1" "$2"; then
        if [ -z "$DO_DRY_RUN" ]; then
            rm -rf "$1"

            if [ ! -z "$DO_DELETE_EMPTY_DIRS" ]; then
                DIR=$(dirname "$1")
                while [ ! "$(ls -A "$DIR")" ]; do
                    print_progress_prefix 0
                    echo "${COL_GREEN}Deleting resulting empty dir: ${COL_RESET}$DIR"
                    rmdir "$DIR"
                    DIR=$(dirname "$DIR")
                done
            fi
        fi
    fi
}

original_cmd() {
    print_progress_prefix
    echo "${COL_GREEN}Keeping:  ${COL_RESET}$1"
}

##################
# OPTION PARSING #
##################

ask() {
    cat << EOF

This script will delete certain files rmlint found.
It is highly advisable to view the script first!

Rmlint was executed in the following way:

   $ rmlint

Execute this script with -d to disable this informational message.
Type any string to continue; CTRL-C, Enter or CTRL-D to abort immediately
EOF
    read -r eof_check
    if [ -z "$eof_check" ]
    then
        # Count Ctrl-D and Enter as aborted too.
        echo "${COL_RED}Aborted on behalf of the user.${COL_RESET}"
        exit 1;
    fi
}

usage() {
    cat << EOF
usage: $0 OPTIONS

OPTIONS:

  -h   Show this message.
  -d   Do not ask before running.
  -x   Keep rmlint.sh; do not autodelete it.
  -p   Recheck that files are still identical before removing duplicates.
  -r   Allow deduplication of files on read-only btrfs snapshots. (requires sudo)
  -n   Do not perform any modifications, just print what would be done. (implies -d and -x)
  -c   Clean up empty directories while deleting duplicates.
  -q   Do not show progress.
EOF
}

DO_REMOVE=
DO_ASK=

while getopts "dhxnrpqc" OPTION
do
  case $OPTION in
     h)
       usage
       exit 0
       ;;
     d)
       DO_ASK=false
       ;;
     x)
       DO_REMOVE=false
       ;;
     n)
       DO_DRY_RUN=true
       DO_REMOVE=false
       DO_ASK=false
       ;;
     r)
       DO_CLONE_READONLY=true
       ;;
     p)
       DO_PARANOID_CHECK=true
       ;;
     c)
       DO_DELETE_EMPTY_DIRS=true
       ;;
     q)
       DO_SHOW_PROGRESS=
       ;;
     *)
       usage
       exit 1
  esac
done

if [ -z $DO_REMOVE ]
then
    echo "#${COL_YELLOW} ///${COL_RESET}This script will be deleted after it runs${COL_YELLOW}///${COL_RESET}"
fi

if [ -z $DO_ASK ]
then
  usage
  ask
fi

if [ ! -z $DO_DRY_RUN  ]
then
    echo "#${COL_YELLOW} ////////////////////////////////////////////////////////////${COL_RESET}"
    echo "#${COL_YELLOW} /// ${COL_RESET} This is only a dry run; nothing will be modified! ${COL_YELLOW}///${COL_RESET}"
    echo "#${COL_YELLOW} ////////////////////////////////////////////////////////////${COL_RESET}"
fi

######### START OF AUTOGENERATED OUTPUT #########

handle_emptyfile '/home/MZ7WD240HAFV/pg_overlay/net-p2p/rtorrent-ps/files/series' # empty file
original_cmd '/home/MZ7WD240HAFV/pg_overlay/app-misc/lfm/metadata.xml' # original
remove_cmd '/home/MZ7WD240HAFV/pg_overlay/app-misc/fslint/metadata.xml' '/home/MZ7WD240HAFV/pg_overlay/app-misc/lfm/metadata.xml' # duplicate
original_cmd '/home/MZ7WD240HAFV/pg_overlay/net-p2p/rtorrent-ps/files/rtorrentd.conf' # original
remove_cmd '/home/MZ7WD240HAFV/pg_overlay/net-p2p/rtorrent/files/rtorrentd.conf' '/home/MZ7WD240HAFV/pg_overlay/net-p2p/rtorrent-ps/files/rtorrentd.conf' # duplicate
original_cmd '/home/MZ7WD240HAFV/pg_overlay/net-p2p/rtorrent-ps/files/rtorrentd_at.service' # original
remove_cmd '/home/MZ7WD240HAFV/pg_overlay/net-p2p/rtorrent/files/rtorrentd_at.service' '/home/MZ7WD240HAFV/pg_overlay/net-p2p/rtorrent-ps/files/rtorrentd_at.service' # duplicate
original_cmd '/home/MZ7WD240HAFV/pg_overlay/net-p2p/rtorrent-ps/files/rtorrent.1' # original
remove_cmd '/home/MZ7WD240HAFV/pg_overlay/net-p2p/rtorrent/files/rtorrent.1' '/home/MZ7WD240HAFV/pg_overlay/net-p2p/rtorrent-ps/files/rtorrent.1' # duplicate
original_cmd '/home/MZ7WD240HAFV/pg_overlay/x11-drivers/xf86-video-nouveau/metadata.xml' # original
remove_cmd '/home/MZ7WD240HAFV/pg_overlay/x11-drivers/xf86-input-libinput/metadata.xml' '/home/MZ7WD240HAFV/pg_overlay/x11-drivers/xf86-video-nouveau/metadata.xml' # duplicate
original_cmd '/home/MZ7WD240HAFV/pg_overlay/sys-apps/polychromatic/metadata.xml' # original
remove_cmd '/home/MZ7WD240HAFV/pg_overlay/sys-apps/openrazer/metadata.xml' '/home/MZ7WD240HAFV/pg_overlay/sys-apps/polychromatic/metadata.xml' # duplicate
original_cmd '/home/MZ7WD240HAFV/pg_overlay/www-client/ungoogled-chromium/files/ungoogled-chromium-libusb-interrupt-event-handler-r0.patch' # original
remove_cmd '/home/MZ7WD240HAFV/pg_overlay/www-client/chromium/files/opensuse-patches-73/chromium-libusb_interrupt_event_handler.patch' '/home/MZ7WD240HAFV/pg_overlay/www-client/ungoogled-chromium/files/ungoogled-chromium-libusb-interrupt-event-handler-r0.patch' # duplicate
original_cmd '/home/MZ7WD240HAFV/pg_overlay/www-client/ungoogled-chromium/files/ungoogled-chromium-system-libusb-r0.patch' # original
remove_cmd '/home/MZ7WD240HAFV/pg_overlay/www-client/chromium/files/opensuse-patches-73/chromium-system-libusb.patch' '/home/MZ7WD240HAFV/pg_overlay/www-client/ungoogled-chromium/files/ungoogled-chromium-system-libusb-r0.patch' # duplicate
original_cmd '/home/MZ7WD240HAFV/pg_overlay/mail-client/thunderbird/files/opensuse-kde/kde.js-1' # original
remove_cmd '/home/MZ7WD240HAFV/pg_overlay/www-client/firefox/files/opensuse-kde-66/kde.js-1' '/home/MZ7WD240HAFV/pg_overlay/mail-client/thunderbird/files/opensuse-kde/kde.js-1' # duplicate
original_cmd '/home/MZ7WD240HAFV/pg_overlay/www-client/firefox/files/opensuse-kde-66/mozilla-nongnome-proxies.patch' # original
remove_cmd '/home/MZ7WD240HAFV/pg_overlay/mail-client/thunderbird/files/opensuse-kde/mozilla-nongnome-proxies.patch' '/home/MZ7WD240HAFV/pg_overlay/www-client/firefox/files/opensuse-kde-66/mozilla-nongnome-proxies.patch' # duplicate
original_cmd '/home/MZ7WD240HAFV/pg_overlay/www-client/ungoogled-chromium/files/chromium-browser.xml' # original
remove_cmd '/home/MZ7WD240HAFV/pg_overlay/www-client/chromium/files/chromium-browser.xml' '/home/MZ7WD240HAFV/pg_overlay/www-client/ungoogled-chromium/files/chromium-browser.xml' # duplicate
original_cmd '/home/MZ7WD240HAFV/pg_overlay/dev-python/pycairo/metadata.xml' # original
remove_cmd '/home/MZ7WD240HAFV/pg_overlay/dev-python/python-nbxmpp/metadata.xml' '/home/MZ7WD240HAFV/pg_overlay/dev-python/pycairo/metadata.xml' # duplicate
original_cmd '/home/MZ7WD240HAFV/pg_overlay/dev-libs/libpwquality/metadata.xml' # original
remove_cmd '/home/MZ7WD240HAFV/pg_overlay/dev-libs/gobject-introspection-common/metadata.xml' '/home/MZ7WD240HAFV/pg_overlay/dev-libs/libpwquality/metadata.xml' # duplicate
remove_cmd '/home/MZ7WD240HAFV/pg_overlay/games-board/aisleriot/metadata.xml' '/home/MZ7WD240HAFV/pg_overlay/dev-libs/libpwquality/metadata.xml' # duplicate
remove_cmd '/home/MZ7WD240HAFV/pg_overlay/dev-util/gdbus-codegen/metadata.xml' '/home/MZ7WD240HAFV/pg_overlay/dev-libs/libpwquality/metadata.xml' # duplicate
                                               
                                               
                                               
######### END OF AUTOGENERATED OUTPUT #########
                                               
if [ $PROGRESS_CURR -le $PROGRESS_TOTAL ]; then
    print_progress_prefix                      
    echo "${COL_BLUE}Done!${COL_RESET}"      
fi                                             
                                               
if [ -z $DO_REMOVE ] && [ -z $DO_DRY_RUN ]     
then                                           
  echo "Deleting script " "$0"             
  rm -f '/home/MZ7WD240HAFV/pg_overlay/rmlint.sh';                                     
fi                                             
