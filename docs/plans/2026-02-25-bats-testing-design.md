# Design: Robust Mocking Framework for Shell Script Testing

## 1. Introduction

This document outlines the design for implementing a robust unit testing
framework for shell scripts in the `gchiam-dotfiles` repository, as requested in
[Issue #101](https://github.com/gchiam/gchiam-dotfiles/issues/101). The goal is
to move beyond simple syntax checks and validate the functional correctness of
critical scripts.

## 2. Goals

- **Automated Validation**: Ensure critical scripts (`setup-interactive.sh`,
  `setup-profile.sh`, `auto-sync.sh`) behave correctly across environments.
- **Regression Prevention**: Catch bugs before they are merged into the `main`
  branch.
- **Improved Maintainability**: Refactor scripts to be more modular and
  testable.
- **Standardized Infrastructure**: Provide a clear pattern for adding tests to
  future scripts.

## 3. Architecture: Robust Mocking Framework

We will use [BATS (Bash Automated Testing System)](https://github.com/bats-core/bats-core)
with a mocking strategy to isolate script logic from the host system.

### 3.1 Directory Structure

```text
tests/
├── helpers/
│   └── test_helper.bash     # Shared test setup, teardown, and mocking functions
├── libs/                    # BATS support libraries (installed via brew or git)
│   ├── bats-support
│   ├── bats-assert
│   └── bats-file
├── setup-interactive.bats   # Tests for bin/setup-interactive.sh
├── setup-profile.bats       # Tests for bin/setup-profile.sh
└── auto-sync.bats           # Tests for bin/auto-sync.sh
```

### 3.2 Test Runner: `bin/test.sh`

A new script `bin/test.sh` will serve as the entry point for running tests.

- It will verify dependencies (`bats`, `bats-assert`, etc.) are installed.
- It will execute all `.bats` files in the `tests/` directory.
- It will provide clear, color-coded output and exit with a non-zero code on
  failure.

## 4. Refactoring Strategy

To make scripts testable without side-effects, we will apply the following
refactors:

- **Main Wrapper**: Wrap the `main` function call in a check for the script
  being executed directly versus sourced.

  ```bash
  if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
      main "$@"
  fi
  ```

- **Modular Functions**: Ensure complex logic (like profile selection or sync
  logic) is contained within standalone functions that can be called
  independently in tests.

## 5. Mocking Strategy

The `test_helper.bash` will provide a `mock` function to intercept calls to
external binaries.

- Intercepted commands: `stow`, `git`, `brew`, `launchctl`, `date`, `read`.
- Mocked commands will record their arguments and return pre-defined outputs or
  exit statuses.

## 6. Implementation Plan Highlights

1. **Dependency Setup**: Add `bats-core` and support libraries to the `Brewfile`.
2. **Script Refactoring**: Update `setup-interactive.sh`, `setup-profile.sh`, and
   `auto-sync.sh`.
3. **Test Development**: Implement functional tests for all three scripts.
4. **CI Integration**: Add a `test-bats` job to
   `.github/workflows/comprehensive-ci.yml`.

## 7. Success Criteria

- `bin/test.sh` successfully executes all tests and passes locally and in CI.
- All critical logic paths in the targeted scripts are covered by at least one
  test case.
- No regressions are introduced during the refactoring process.
