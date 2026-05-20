#!/usr/bin/env bash

set -Eeuo pipefail

LOCK_FILE="/tmp/fix-network.lock"
LOG_TAG="netctl-failover"

PING_TARGETS_V4=("1.1.1.1" "8.8.8.8")
PING_TARGETS_V6=("2606:4700:4700::1111" "2001:4860:4860::8888")

PING_COUNT=1
PING_TIMEOUT=3
STOP_WAIT_SECONDS=5

WIFI_PROFILES=(
    "wifi-GALLISCHES"
    "wifi-reply-N"
)

ETHERNET_PROFILES=(
    "ethernet-home"
    "ethernet-port-right"
)

PROFILE_RETRIES=1
RETRY_BACKOFF_SECONDS=4
START_WAIT_SECONDS=15

log() {
    local level="$1"
    shift
    local msg="$*"
    printf '[%s] [%s] %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$level" "$msg" >&2
    logger -t "$LOG_TAG" "[$level] $msg" 2>/dev/null || true
}

acquire_lock() {
    exec 200>"$LOCK_FILE"
    if ! flock -n 200; then
        log WARN "Another instance is already running. Exiting."
        exit 0
    fi
}

cleanup() {
    log INFO "Exiting."
}

on_error() {
    local exit_code="$?"
    log ERROR "Script failed at line ${BASH_LINENO[0]} with exit code ${exit_code}"
    exit "$exit_code"
}

trap cleanup EXIT
trap on_error ERR

require_commands() {
    local cmds=(sudo netctl ip ping timeout flock cat test grep)
    local cmd
    for cmd in "${cmds[@]}"; do
        if ! command -v "$cmd" >/dev/null 2>&1; then
            log ERROR "Required command not found: $cmd"
            exit 1
        fi
    done
}
prime_sudo() {
    if ! sudo -v; then
        log ERROR "Failed to authenticate with sudo"
        exit 1
    fi
}

run_netctl() {
    sudo -n netctl "$@"
}

run_cat() {
    sudo -n cat "$@"
}

profile_exists_in_netctl() {
    local profile="$1"
    sudo -n test -f "/etc/netctl/${profile}"
}

validate_all_profiles() {
    local profile
    for profile in "${WIFI_PROFILES[@]}"; do
        if ! profile_exists_in_netctl "$profile"; then
            log ERROR "Profile '${profile}' does not exist in /etc/netctl"
            return 1
        fi
    done
    for profile in "${ETHERNET_PROFILES[@]}"; do
        if ! profile_exists_in_netctl "$profile"; then
            log ERROR "Profile '${profile}' does not exist in /etc/netctl"
            return 1
        fi
    done
}

profile_is_active() {
    local profile="$1"
    run_netctl is-active "$profile" >/dev/null 2>&1
}

wait_for_profile_state() {
    local profile="$1"
    local expected="$2"
    local timeout_seconds="$3"
    local i

    for ((i = 0; i < timeout_seconds; i++)); do
        if [[ "$expected" == "active" ]] && profile_is_active "$profile"; then
            return 0
        fi
        if [[ "$expected" == "inactive" ]] && ! profile_is_active "$profile"; then
            return 0
        fi
        sleep 1
    done

    if [[ "$expected" == "active" ]] && profile_is_active "$profile"; then
        return 0
    fi
    if [[ "$expected" == "inactive" ]] && ! profile_is_active "$profile"; then
        return 0
    fi

    return 1
}

stop_profile_if_active() {
    local profile="$1"

    if profile_is_active "$profile"; then
        log INFO "Stopping active profile: $profile"
        run_netctl stop "$profile" >/dev/null 2>&1 || true
        if ! wait_for_profile_state "$profile" "inactive" "$STOP_WAIT_SECONDS"; then
            log WARN "Profile '$profile' did not become inactive within ${STOP_WAIT_SECONDS}s"
        fi
    fi
}

stop_other_profiles_in_group() {
    local selected_profile="$1"
    shift
    local profiles=("$@")
    local profile

    for profile in "${profiles[@]}"; do
        if [[ "$profile" != "$selected_profile" ]]; then
            stop_profile_if_active "$profile"
        fi
    done
}

find_active_profile_in_group() {
    local profiles=("$@")
    local profile

    for profile in "${profiles[@]}"; do
        if profile_is_active "$profile"; then
            printf '%s\n' "$profile"
            return 0
        fi
    done

    return 1
}

profile_config_path() {
    local profile="$1"
    printf '/etc/netctl/%s\n' "$profile"
}

trim() {
    local s="$1"
    s="${s#"${s%%[![:space:]]*}"}"
    s="${s%"${s##*[![:space:]]}"}"
    printf '%s\n' "$s"
}

profile_interface() {
    local profile="$1"
    local cfg
    local raw_line
    local line
    local key
    local value

    cfg="$(profile_config_path "$profile")"

    if ! profile_exists_in_netctl "$profile"; then
        log WARN "Profile config not found: $cfg"
        return 1
    fi

    while IFS= read -r raw_line || [[ -n "$raw_line" ]]; do
        line="${raw_line%$'\r'}"
        line="$(trim "$line")"

        [[ -z "$line" ]] && continue
        [[ "$line" == \#* ]] && continue
        [[ "$line" != *=* ]] && continue

        key="${line%%=*}"
        value="${line#*=}"

        key="$(trim "$key")"
        value="$(trim "$value")"

        if [[ "$key" == "Interface" ]]; then
            value="${value%\"}"
            value="${value#\"}"
            value="${value%\'}"
            value="${value#\'}"

            if [[ -z "$value" ]]; then
                log WARN "Empty Interface= in profile '$profile'"
                return 1
            fi

            printf '%s\n' "$value"
            return 0
        fi
    done < <(run_cat "$cfg" 2>/dev/null || true)

    log WARN "No Interface= found in profile '$profile'"
    return 1
}

is_wireless_interface() {
    local iface="$1"
    [[ -d "/sys/class/net/${iface}/wireless" ]]
}

ethernet_has_carrier() {
    local iface="$1"
    local carrier_file="/sys/class/net/${iface}/carrier"

    if [[ ! -r "$carrier_file" ]]; then
        log WARN "Carrier file not readable for interface '$iface'"
        return 1
    fi

    [[ "$(cat "$carrier_file")" == "1" ]]
}

wifi_is_associated() {
    local iface="$1"
    local out

    if command -v iw >/dev/null 2>&1; then
        iw dev "$iface" link 2>/dev/null | grep -q '^Connected to '
        return $?
    fi

    if command -v iwconfig >/dev/null 2>&1; then
        out="$(iwconfig "$iface" 2>/dev/null || true)"
        if [[ -z "$out" ]]; then
            return 1
        fi
        if grep -q 'Not-Associated' <<<"$out"; then
            return 1
        fi
        grep -q 'Access Point:' <<<"$out"
        return $?
    fi

    log WARN "Neither 'iw' nor 'iwconfig' found; cannot verify Wi-Fi association for '$iface'"
    return 1
}

interface_is_up() {
    local iface="$1"
    ip link show dev "$iface" 2>/dev/null | grep -q "state UP"
}

interface_has_ipv4() {
    local iface="$1"
    ip -4 addr show dev "$iface" 2>/dev/null | grep -q "inet "
}

interface_has_ipv6_global() {
    local iface="$1"
    ip -6 addr show dev "$iface" scope global 2>/dev/null | grep -q "inet6 "
}

interface_has_any_ip() {
    local iface="$1"
    interface_has_ipv4 "$iface" || interface_has_ipv6_global "$iface"
}

interface_has_default_route_v4() {
    local iface="$1"
    ip route show default 2>/dev/null | grep -q " dev ${iface}\b"
}

interface_has_default_route_v6() {
    local iface="$1"
    ip -6 route show default 2>/dev/null | grep -q " dev ${iface}\b"
}

interface_link_is_ready() {
    local iface="$1"

    if is_wireless_interface "$iface"; then
        if wifi_is_associated "$iface"; then
            log INFO "Wireless interface '$iface' is associated"
            return 0
        fi
        log WARN "Wireless interface '$iface' is not associated"
        return 1
    fi

    if ethernet_has_carrier "$iface"; then
        log INFO "Ethernet interface '$iface' has carrier"
        return 0
    fi

    log WARN "Ethernet interface '$iface' has no carrier"
    return 1
}

interface_has_connectivity_once() {
    local iface="$1"
    local target

    if ! interface_is_up "$iface"; then
        log WARN "Interface '$iface' is not UP"
        return 1
    fi

    if ! interface_link_is_ready "$iface"; then
        return 1
    fi

    if ! interface_has_any_ip "$iface"; then
        log WARN "Interface '$iface' has no IPv4 or global IPv6 address"
        return 1
    fi

    # if interface_has_default_route_v4 "$iface"; then
    #     for target in "${PING_TARGETS_V4[@]}"; do
    #         if timeout "$PING_TIMEOUT" ping -I "$iface" -c "$PING_COUNT" "$target" >/dev/null 2>&1; then
    #             log INFO "Interface '$iface' reached IPv4 target '$target'"
    #             return 0
    #         fi
    #     done
    # fi

    # if interface_has_default_route_v6 "$iface"; then
    #     for target in "${PING_TARGETS_V6[@]}"; do
    #         if timeout "$PING_TIMEOUT" ping6 -I "$iface" -c "$PING_COUNT" "$target" >/dev/null 2>&1; then
    #             log INFO "Interface '$iface' reached IPv6 target '$target'"
    #             return 0
    #         fi
    #     done
    # fi

    # log WARN "Interface '$iface' could not reach any configured IPv4/IPv6 target"
    # return 1
    return 0
}

wait_for_interface_connectivity() {
    local iface="$1"
    local timeout_seconds="$2"
    local i

    for ((i = 0; i < timeout_seconds; i++)); do
        if interface_has_connectivity_once "$iface"; then
            return 0
        fi
        sleep 1
    done

    if interface_has_connectivity_once "$iface"; then
        return 0
    fi

    return 1
}

start_profile_and_verify_once() {
    local profile="$1"
    local iface="$2"

    log INFO "(Re-)Starting profile '$profile' on interface '$iface'"

    if ! run_netctl restart "$profile" >/dev/null 2>&1; then
        log WARN "netctl start failed for profile '$profile'"
        return 1
    fi

    if ! wait_for_profile_state "$profile" "active" "$START_WAIT_SECONDS"; then
        log WARN "Profile '$profile' did not become active within ${START_WAIT_SECONDS}s"
        stop_profile_if_active "$profile"
        return 1
    fi

    if wait_for_interface_connectivity "$iface" "$START_WAIT_SECONDS"; then
        log INFO "Profile '$profile' has working connectivity on interface '$iface'"
        return 0
    fi

    log WARN "Profile '$profile' became active, but connectivity validation failed on interface '$iface'"
    stop_profile_if_active "$profile"
    return 1
}

start_profile_with_retries() {
    local profile="$1"
    local iface="$2"
    local attempt

    for ((attempt = 1; attempt <= PROFILE_RETRIES; attempt++)); do
        log INFO "Attempt ${attempt}/${PROFILE_RETRIES} for profile '$profile'"

        if start_profile_and_verify_once "$profile" "$iface"; then
            return 0
        fi

        if ((attempt < PROFILE_RETRIES)); then
            log INFO "Backing off ${RETRY_BACKOFF_SECONDS}s before retrying profile '$profile'"
            sleep "$RETRY_BACKOFF_SECONDS"
        fi
    done

    log WARN "All retries failed for profile '$profile'"
    return 1
}

process_group() {
    local group_name="$1"
    shift
    local profiles=("$@")
    local active_profile=""
    local iface=""
    local profile=""

    log INFO "Processing group: $group_name"

    if active_profile="$(find_active_profile_in_group "${profiles[@]}")"; then
        iface="$(profile_interface "$active_profile" || true)"

        if [[ -z "$iface" ]]; then
            log WARN "Could not determine interface for active profile '$active_profile'"
        else
            if interface_has_connectivity_once "$iface"; then
                log INFO "Group '$group_name': active profile '$active_profile' is healthy on interface '$iface'. Doing nothing."
                return 0
            fi
            log WARN "Group '$group_name': active profile '$active_profile' has no usable connectivity on interface '$iface'. Recovery will start."
        fi
    else
        log INFO "Group '$group_name': no active profile found."
    fi

    for profile in "${profiles[@]}"; do
        iface="$(profile_interface "$profile" || true)"

        if [[ -z "$iface" ]]; then
            log WARN "Skipping profile '$profile' in group '$group_name': unable to determine interface"
            continue
        fi

        log INFO "Group '$group_name': trying profile '$profile' on interface '$iface'"
        stop_other_profiles_in_group "$profile" "${profiles[@]}"

        if start_profile_with_retries "$profile" "$iface"; then
            log INFO "Group '$group_name': selected working profile '$profile'"
            return 0
        fi
    done

    log ERROR "Group '$group_name': no configured profile established connectivity"
    return 1
}

main() {
    local rc=0

    require_commands
    acquire_lock
    prime_sudo
    validate_all_profiles

    log INFO "Starting interface-aware netctl failover logic"

    if ! process_group "wired" "${ETHERNET_PROFILES[@]}"; then
        log ERROR "Wired group recovery failed"
        rc=1
    fi

    if ! process_group "wireless" "${WIFI_PROFILES[@]}"; then
        log ERROR "Wireless group recovery failed"
        rc=1
    fi

    log INFO "Completed interface-aware netctl failover logic"
    return "$rc"
}

main "$@"
