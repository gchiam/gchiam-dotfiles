# Implementation Plan: Unified Theme Orchestrator

## Phase 1: Core Orchestrator Development [checkpoint: ba484c9]

- [x] **Task: Foundation - Setup Test Environment**
  - [ ] Create a BATS test suite for theme detection.
  - [ ] Define the test cases for Dark and Light mode outputs.
- [x] **Task: Implement Core Script - `bin/theme-sync.sh`**
  - [ ] Create the script with basic shebang and error handling.
  - [ ] Implement macOS theme detection logic using `defaults`.
  - [ ] Add `fswatch` integration for real-time monitoring.
  - [ ] Ensure the script handles the initial state on startup.
- [x] **Task: Implement Theme Broadcasting Logic**
  - [ ] Add logic to determine Catppuccin flavor (Frappe/Latte).
  - [ ] Implement a mechanism to notify other shells (e.g., via a state file in
        `/tmp/`).
- [ ] **Task: Conductor - User Manual Verification 'Core Orchestrator
      Development' (Protocol in workflow.md)**

## Phase 2: Application Integration

- [ ] **Task: Tmux Integration**
  - [ ] Update `bin/theme-sync.sh` to trigger `tmux source-file`.
  - [ ] Remove or deprecate old tmux theme watchers in `stow/custom-bin/bin/`.
- [ ] **Task: Neovim Integration**
  - [ ] Modify Neovim config to listen for the unified theme signal.
  - [ ] Verify `auto-dark-mode.nvim` compatibility or replace with orchestrator
        signal.
- [ ] **Task: Terminal Integration**
  - [ ] Ensure `alacritty.toml` and `wezterm.lua` correctly import the managed
        theme file.
  - [ ] Update orchestrator to rewrite the imported theme file on change.
- [ ] **Task: Conductor - User Manual Verification 'Application Integration'
      (Protocol in workflow.md)**
