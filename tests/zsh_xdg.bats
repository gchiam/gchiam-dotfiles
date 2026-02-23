#!/usr/bin/env bats

@test ".zshrc uses XDG_CACHE_HOME for compinit" {
    grep -q 'compinit -d "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump"' stow/zsh/.config/zsh/.zshrc
}

@test "setup-completions.sh uses XDG_CACHE_HOME for compinit" {
    grep -q 'compinit -d \\"\\${XDG_CACHE_HOME:-\\$HOME/.cache}/zsh/zcompdump\\"' bin/setup-completions.sh
}

@test "performance-monitor.sh uses XDG_CACHE_HOME for zcompdump cleanup" {
    grep -q 'local zcompdump="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump"' bin/performance-monitor.sh
}
