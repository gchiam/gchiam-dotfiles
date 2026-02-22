# Implementation Plan: Stow Conflict Detection and Backup

## Phase 1: Foundation and Detection Logic [checkpoint: a5463b1]

- [x] **Task: Setup Test Environment**
  - [x] Create a dedicated directory structure for testing conflicts (simulated
        `$HOME` and dotfiles).
  - [x] Write initial BATS tests to detect existing files vs. symlinks.
- [x] **Task: Implement Core Detection Engine**
  - [x] Create a helper function `check_stow_conflicts` in `bin/setup-stow.sh`.
  - [x] Implement logic to identify regular files, different symlinks, and
        directories in target paths.
- [x] **Task: Conductor - User Manual Verification 'Foundation and Detection
      Logic' (Protocol in workflow.md)**

## Phase 2: Interactive Resolution Interface [checkpoint: 0bc258c]

- [x] **Task: Build Resolution Prompt**
  - [x] Implement the `resolve_conflict` function to present the [b]ackup,
        [d]iff, [o]verwrite, [s]kip options.
  - [x] Add the input loop to handle user choices and validate input.
- [x] **Task: Implement Diff Integration**
  - [x] Add logic to check for `delta` and execute it for the [d]iff option.
  - [x] Provide a fallback to standard `diff -u` if `delta` is missing.
- [x] **Task: Conductor - User Manual Verification 'Interactive Resolution
      Interface' (Protocol in workflow.md)**

## Phase 3: Backup and Execution [checkpoint: 431df88]

- [x] **Task: Implement Backup Logic**
  - [x] Add the actual `mv` command for the [b]ackup option, appending `.bak`.
  - [x] Implement the [o]verwrite logic using `rm -rf`.
- [x] **Task: Integrate with Main Stowing Loop**
  - [x] Update the main loop in `bin/setup-stow.sh` to call the detection engine
        before stowing each package.
  - [x] Ensure that selecting [s]kip correctly prevents the `stow` command for
        that package.
- [x] **Task: Conductor - User Manual Verification 'Backup and Execution'
      (Protocol in workflow.md)**

## Phase 4: Finalization and Safety Checks

- [x] **Task: Add Safety Guards**
  - [x] Ensure the script handles edge cases like file permission errors.
  - [x] Add a `--non-interactive` flag to bypass prompts (defaulting to skip).
- [x] **Task: Final Verification and Documentation**
  - [x] Run full BATS test suite across all resolution scenarios.
  - [x] Update `docs/troubleshooting.md` or similar with notes on conflict
        resolution.
- [x] **Task: Conductor - User Manual Verification 'Finalization and Safety
      Checks' (Protocol in workflow.md)**
