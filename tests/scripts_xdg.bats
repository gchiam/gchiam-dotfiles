#!/usr/bin/env bats

@test "auto-sync.sh uses XDG paths" {
    grep -q 'SYNC_LOG="$(get_xdg_path STATE)/dotfiles/sync.log"' bin/auto-sync.sh
    grep -q 'LAST_SYNC_FILE="$(get_xdg_path STATE)/dotfiles/last-sync"' bin/auto-sync.sh
}

@test "health-monitor.sh uses XDG paths" {
    grep -q 'MONITOR_LOG="$(get_xdg_path STATE)/dotfiles/health-monitor.log"' bin/health-monitor.sh
    grep -q 'ALERT_LOG="$(get_xdg_path STATE)/dotfiles/alerts.log"' bin/health-monitor.sh
    grep -q 'STATUS_FILE="$(get_xdg_path STATE)/dotfiles/health-status.json"' bin/health-monitor.sh
}

@test "performance-monitor.sh uses XDG paths" {
    grep -q 'PERFORMANCE_LOG="$(get_xdg_path STATE)/dotfiles/performance.log"' bin/performance-monitor.sh
}

@test "setup-profile.sh uses XDG paths" {
    grep -q 'CURRENT_PROFILE_FILE="$(get_xdg_path STATE)/dotfiles/profile"' bin/setup-profile.sh
}

@test "zsh functions use XDG_DATA_HOME for notes" {
    grep -q 'notes_file="${XDG_DATA_HOME:-$HOME/.local/share}/dotfiles/notes"' stow/zsh/.config/zsh/functions.zsh
}

@test "zsh functions use XDG_DATA_HOME for work-time.log" {
    grep -q 'time_file="${XDG_DATA_HOME:-$HOME/.local/share}/dotfiles/work-time.log"' stow/zsh/.config/zsh/work-functions.zsh
}
