# BATS Automated Testing Framework Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement
> this plan task-by-task.

**Goal:** Implement a robust BATS testing framework with mocking to validate
critical shell scripts (`setup-interactive.sh`, `setup-profile.sh`,
`auto-sync.sh`).

**Architecture:** Unit testing with mocking using `bats-core` and support
libraries (`bats-assert`, `bats-support`, `bats-file`). Scripts will be
refactored with `main` wrappers to allow sourcing without execution.

**Tech Stack:** BATS, Bash, Homebrew.

---

## Task 1: Dependency Setup

### Files for Task 1

- Modify: `stow/brew/.Brewfile`
- Modify: `.github/workflows/comprehensive-ci.yml`

### Step 1.1: Add BATS to Brewfile

Add these lines to `stow/brew/.Brewfile`:

```ruby
brew 'bats-core'
brew 'bats-support'
brew 'bats-assert'
brew 'bats-file'
```

### Step 1.2: Update CI workflow

Modify `.github/workflows/comprehensive-ci.yml` to install these dependencies in
the `test-macos` job.

### Step 1.3: Commit Task 1

```bash
git add stow/brew/.Brewfile .github/workflows/comprehensive-ci.yml
git commit -m "🔧 chore(ci): add BATS dependencies to Brewfile and CI"
```

## Task 2: Test Infrastructure & Helpers

### Files for Task 2

- Create: `tests/helpers/test_helper.bash`

### Step 2.1: Implement `test_helper.bash`

Create `tests/helpers/test_helper.bash` with:

- Loading support libraries.
- Mocking function for external commands.
- Standard `setup` and `teardown`.

### Step 2.2: Commit Task 2

```bash
git add tests/helpers/test_helper.bash
git commit -m "🧪 test: add BATS test helper with mocking support"
```

## Task 3: Refactor `setup-interactive.sh` for Testability

### Files for Task 3

- Modify: `bin/setup-interactive.sh`

### Step 3.1: Wrap `main` call

Find the `main "$@"` call at the end and wrap it:

```bash
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    main "$@"
fi
```

### Step 3.2: Verify it still runs

Run: `bin/setup-interactive.sh --help`
Expected: Help output displayed.

### Step 3.3: Commit Task 3

```bash
git add bin/setup-interactive.sh
git commit -m "♻️ refactor(setup): wrap main in setup-interactive.sh for testability"
```

## Task 4: Test `setup-interactive.sh` Logic

### Files for Task 4

- Create: `tests/setup-interactive.bats`

### Step 4.1: Write tests for profile selection

Test `get_selected_stow_dirs` with different profiles ("minimal", "developer").

### Step 4.2: Run test to verify it passes

Run: `bats tests/setup-interactive.bats`
Expected: PASS

### Step 4.3: Commit Task 4

```bash
git add tests/setup-interactive.bats
git commit -m "🧪 test(setup): add unit tests for setup-interactive.sh logic"
```

## Task 5: Refactor and Test `setup-profile.sh`

### Files for Task 5

- Modify: `bin/setup-profile.sh`
- Create: `tests/setup-profile.bats`

### Step 5.1: Wrap `main` call in `bin/setup-profile.sh`

### Step 5.2: Implement tests in `tests/setup-profile.bats`

Test `apply_profile` and `get_current_profile`.

### Step 5.3: Commit Task 5

```bash
git add bin/setup-profile.sh tests/setup-profile.bats
git commit -m "🧪 test(profile): implement BATS tests for setup-profile.sh"
```

## Task 6: Refactor and Test `auto-sync.sh`

### Files for Task 6

- Modify: `bin/auto-sync.sh`
- Create: `tests/auto-sync.bats`

### Step 6.1: Wrap `main` call in `bin/auto-sync.sh`

### Step 6.2: Implement tests in `tests/auto-sync.bats`

Test `needs_sync` and `commit_updates` (mocking `date` and `git`).

### Step 6.3: Commit Task 6

```bash
git add bin/auto-sync.sh tests/auto-sync.bats
git commit -m "🧪 test(sync): implement BATS tests for auto-sync.sh"
```

## Task 7: Unified Test Runner

### Files for Task 7

- Create: `bin/test.sh`

### Step 7.1: Implement `bin/test.sh`

A script to run all tests in `tests/` with proper environment setup.

### Step 7.2: Verify it runs all tests

Run: `./bin/test.sh`
Expected: All tests pass.

### Step 7.3: Commit Task 7

```bash
git add bin/test.sh
git commit -m "✨ feat: add unified test runner bin/test.sh"
```

## Task 8: CI Integration for BATS

### Files for Task 8

- Modify: `.github/workflows/comprehensive-ci.yml`

### Step 8.1: Add `test-bats` job

Add a dedicated job to run `./bin/test.sh`.

### Step 8.2: Commit Task 8

```bash
git add .github/workflows/comprehensive-ci.yml
git commit -m "👷 ci: integrate BATS tests into CI pipeline"
```
