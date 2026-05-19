#!/bin/bash
# sync-local-hosts.sh
#
# Resolves a fixed list of bare hostnames via the router's unicast DNS
# (the .lan suffix that the T-Mobile gateway hands out) and mirrors the
# results into /etc/hosts as .local entries inside a managed block.
#
# Purpose: keep .local hostname resolution working on this Mac when
# Wi-Fi mDNS (multicast) is broken by the gateway. macOS getaddrinfo
# consults /etc/hosts before mDNS, so ssh / ping / curl / MCP clients
# all resolve instantly without waiting for the 5s mDNS timeout.
#
# Idempotent: rewrites the block between BEGIN/END markers on each run.
# Re-run after a network change; the LaunchDaemon does this automatically
# when /etc/resolv.conf changes.

set -euo pipefail

HOSTS=(richard-ai richard-nuc)
SUFFIX_SRC=".lan"
SUFFIX_DST=".local"
HOSTS_FILE="/etc/hosts"
BEGIN_MARK="# BEGIN sync-local-hosts"
END_MARK="# END sync-local-hosts"

log() { logger -t sync-local-hosts "$*"; echo "$*" >&2; }

resolve_lan() {
    # Use dscacheutil so we hit the router's DNS (resolver #1), not mDNS.
    # Returns first IPv4 address or empty string.
    dscacheutil -q host -a name "${1}${SUFFIX_SRC}" 2>/dev/null \
        | awk '/^ip_address:/ {print $2; exit}'
}

build_block() {
    printf '%s\n' "$BEGIN_MARK"
    printf '# Managed by ~/dotfiles/bin/sync-local-hosts.sh — do not edit by hand.\n'
    printf '# Mirrors <host>%s (from router DNS) to <host>%s for mDNS-broken networks.\n' \
        "$SUFFIX_SRC" "$SUFFIX_DST"
    local h ip resolved=0
    for h in "${HOSTS[@]}"; do
        ip="$(resolve_lan "$h" || true)"
        if [[ -n "$ip" ]]; then
            printf '%s\t%s%s\t%s\n' "$ip" "$h" "$SUFFIX_DST" "# also resolves bare name"
            printf '%s\t%s\n' "$ip" "$h"
            resolved=$((resolved + 1))
        else
            printf '# %s%s unresolved at %s\n' "$h" "$SUFFIX_SRC" "$(date -u +%FT%TZ)"
            log "could not resolve ${h}${SUFFIX_SRC}"
        fi
    done
    printf '%s\n' "$END_MARK"
    log "wrote block with $resolved/${#HOSTS[@]} hosts resolved"
}

write_hosts() {
    local tmp
    tmp="$(mktemp)"
    # Strip any existing managed block.
    awk -v b="$BEGIN_MARK" -v e="$END_MARK" '
        $0 == b { skip = 1; next }
        $0 == e { skip = 0; next }
        !skip   { print }
    ' "$HOSTS_FILE" > "$tmp"

    # Also strip the legacy `# Added by Richard` block that pinned
    # richard-nuc to a stale subnet — the managed block supersedes it.
    awk '
        /^# Added by Richard$/        { skip = 1; next }
        skip && /^[[:space:]]*$/      { skip = 0; next }
        skip && /^#/                  { next }
        skip && /^[0-9]/              { next }
        !skip                          { print }
    ' "$tmp" > "${tmp}.2" && mv "${tmp}.2" "$tmp"

    # Trim trailing blank lines, then append a single blank line + new block.
    awk 'NF {p=1} p' "$tmp" \
        | awk 'BEGIN{n=0} /^$/{n++; next} {while(n--)print ""; n=0; print} END{print ""}' \
        > "${tmp}.3" && mv "${tmp}.3" "$tmp"
    build_block >> "$tmp"

    install -m 0644 -o root -g wheel "$tmp" "$HOSTS_FILE"
    rm -f "$tmp"
    # Flush mDNSResponder so any prior negative cache entries clear.
    killall -HUP mDNSResponder 2>/dev/null || true
}

if [[ "$(id -u)" != "0" ]]; then
    log "must run as root (got uid=$(id -u))"
    echo "sync-local-hosts: must run as root" >&2
    exit 1
fi

write_hosts
log "done"
