#!/bin/bash
# Installs the sync-local-hosts LaunchDaemon.
#
# Usage:   ~/dotfiles/launchd/install.sh
# Removes: ~/dotfiles/launchd/install.sh uninstall
#
# Idempotent: re-running re-bootstraps the daemon (safe after dotfiles updates).

set -euo pipefail

LABEL="com.morello.sync-local-hosts"
SRC_PLIST="$(cd "$(dirname "$0")" && pwd)/${LABEL}.plist"
DST_PLIST="/Library/LaunchDaemons/${LABEL}.plist"

cmd="${1:-install}"

run_root() {
    if [[ "$(id -u)" == "0" ]]; then
        "$@"
    else
        sudo "$@"
    fi
}

case "$cmd" in
install)
    [[ -f "$SRC_PLIST" ]] || { echo "missing $SRC_PLIST" >&2; exit 1; }
    echo "Installing $LABEL ..."
    run_root install -m 0644 -o root -g wheel "$SRC_PLIST" "$DST_PLIST"
    # bootout is a no-op if not currently loaded; ignore failure.
    run_root launchctl bootout system "$DST_PLIST" 2>/dev/null || true
    run_root launchctl bootstrap system "$DST_PLIST"
    run_root launchctl enable "system/${LABEL}"
    # Kick once to populate /etc/hosts now.
    run_root launchctl kickstart -k "system/${LABEL}"
    echo "Installed. Log: /var/log/sync-local-hosts.log"
    ;;
uninstall)
    echo "Removing $LABEL ..."
    run_root launchctl bootout system "$DST_PLIST" 2>/dev/null || true
    run_root rm -f "$DST_PLIST"
    echo "Removed. (Managed /etc/hosts block left in place; remove manually if desired.)"
    ;;
*)
    echo "Usage: $0 [install|uninstall]" >&2
    exit 2
    ;;
esac
