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

@test ".zshrc runs compinit exactly once" {
    # Count calls (lines starting with compinit or chained after &&), not `autoload -Uz compinit`
    [ "$(grep -cE '(^|&&)[[:space:]]*compinit([[:space:]]|$)' stow/zsh/.config/zsh/.zshrc)" -eq 1 ]
}

@test ".zshrc has no hardcoded home directory paths" {
    ! grep -nE '/(Users|home)/[a-z]' stow/zsh/.config/zsh/.zshrc
}

@test "interactive zsh starts cleanly without optional tools and writes nothing into the repo" {
    command -v zsh >/dev/null || skip "zsh not installed"
    local test_home
    test_home="$(mktemp -d)"
    mkdir -p "$test_home/.config"
    ln -s "$PWD/stow/zsh/.config/zsh" "$test_home/.config/zsh"
    HOME="$test_home" bin/setup-zshenv.sh >/dev/null

    run env -i HOME="$test_home" PATH="/usr/bin:/bin" TERM=dumb zsh -i -c 'whence -w safe_source' 2>&1
    rm -rf "$test_home"

    [[ "$output" == *"safe_source: function"* ]]
    # Optional tools must be guarded (the ZETUP brew block is tool-managed and not checked here)
    [[ "$output" != *"atuin"* ]]
    [[ "$output" != *".opencode"* ]]
    [[ "$output" != *".bun"* ]]
    # compinit must write its dump to XDG_CACHE_HOME, not into ZDOTDIR (the repo)
    [ -z "$(git ls-files --others -- stow/zsh/.config/zsh)" ]
}
