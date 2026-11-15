#!/usr/bin/env bats

# Tests for bin/setup-git.sh. Each test writes git settings to a throwaway
# global config (GIT_CONFIG_GLOBAL), never to the real ~/.gitconfig.

setup() {
    TEST_DIR="$(mktemp -d)"
    export GIT_CONFIG_GLOBAL="$TEST_DIR/gitconfig"
    : > "$GIT_CONFIG_GLOBAL"
    sh bin/setup-git.sh >/dev/null 2>&1
}

teardown() {
    rm -rf "$TEST_DIR"
}

@test "setup-git.sh enables push.autoSetupRemote" {
    [ "$(git config --global --get push.autoSetupRemote)" = "true" ]
}

@test "git cleanup deletes merged branches but keeps main, master, current and worktree branches" {
    cd "$TEST_DIR"
    git init -q -b main repo
    cd repo
    git -c user.name=test -c user.email=test@example.com -c commit.gpgsign=false commit -q --allow-empty -m init
    git branch master
    git branch feature-done
    git branch in-worktree
    git worktree add -q ../worktree in-worktree
    git switch -q -c current

    run git cleanup
    [ "$status" -eq 0 ]

    run git branch --format='%(refname:short)'
    [[ "$output" != *"feature-done"* ]]
    for kept in main master current in-worktree; do
        [[ "$output" == *"$kept"* ]] || { echo "deleted $kept" >&2; return 1; }
    done
}
