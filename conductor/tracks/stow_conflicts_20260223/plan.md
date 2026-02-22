# Implementation Plan: Stow Conflict Detection and Backup

## Phase 1: Foundation and Detection Logic

- [x] **Task: Setup Test Environment**
  - [x] Create a dedicated directory structure for testing conflicts (simulated
        `$HOME` and dotfiles).
  - [x] Write initial BATS tests to detect existing files vs. symlinks.
- [x] **Task: Implement Core Detection Engine**
  - [x] Create a helper function `check_stow_conflicts` in `bin/setup-stow.sh`.
  - [x] Implement logic to identify regular files, different symlinks, and
        directories in target paths.
- [ ] **Task: Conductor - User Manual Verification 'Foundation and Detection
      Logic' (Protocol in workflow.md)**

## Phase 2: Interactive Resolution Interface

- [ ] **Task: Build Resolution Prompt**
  - [ ] Implement the `resolve_conflict` function to present the [b]ackup,
        [d]iff, [o]verwrite, [s]kip options.
  - [ ] Add the input loop to handle user choices and validate input.
- [ ] **Task: Implement Diff Integration**
  - [ ] Add logic to check for `delta` and execute it for the [d]iff option.
  - [ ] Provide a fallback to standard `diff -u` if `delta` is missing.
- [ ] **Task: Conductor - User Manual Verification 'Interactive Resolution
      Interface' (Protocol in workflow.md)**

## Phase 3: Backup and Execution

- [ ] **Task: Implement Backup Logic**
  - [ ] Add the actual `mv` command for the [b]ackup option, appending `.bak`.
  - [ ] Implement the [o]verwrite logic using `rm -rf`.
- [ ] **Task: Integrate with Main Stowing Loop**
  - [ ] Update the main loop in `bin/setup-stow.sh` to call the detection engine
        before stowing each package.
  - [ ] Ensure that selecting [s]kip correctly prevents the `stow` command for
        that package.
- [ ] **Task: Conductor - User Manual Verification 'Backup and Execution'
      (Protocol in workflow.md)**

## Phase 4: Finalization and Safety Checks

- [ ] **Task: Add Safety Guards**
  - [ ] Ensure the script handles edge cases like file permission errors.
  - [ ] Add a `--non-interactive` flag to bypass prompts (defaulting to skip).
- [ ] **Task: Final Verification and Documentation**
  - [ ] Run full BATS test suite across all resolution scenarios.
  - [ ] Update `docs/troubleshooting.md` or similar with notes on conflict
        resolution.
- [ ] **Task: Conductor - User Manual Verification 'Finalization and Safety
      Checks' (Protocol in workflow.md)**
