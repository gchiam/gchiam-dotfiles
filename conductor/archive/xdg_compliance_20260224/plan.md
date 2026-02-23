# Implementation Plan: Harden XDG Compliance for Stateful Files

## Phase 1: Audit and Tooling [checkpoint: 99b7997]

- [x] Task: Audit repository for hardcoded `$HOME` paths (a9c1132)
  - [x] Search `bin/` and `stow/` for files starting with `.` in `$HOME`
  - [x] List all affected files and scripts
- [x] Task: Create XDG path resolution helper (a9c1132)
  - [x] Write tests to verify path resolution with/without XDG variables
  - [x] Implement `get_xdg_path` helper in a shared utility script
- [x] Task: Conductor - User Manual Verification 'Audit and Tooling'
  (Protocol in workflow.md) (99b7997)

## Phase 2: Shell Environment Configuration [checkpoint: 43e0e54]

- [x] Task: Update Zsh environment for XDG variables (a9c1132)
  - [x] Write tests ensuring XDG variables are exported correctly
  - [x] Update `stow/zsh/.zshenv` to export XDG_CONFIG_HOME, XDG_DATA_HOME,
    XDG_STATE_HOME, and XDG_CACHE_HOME
- [x] Task: Update Zsh history and state paths (a9c1132)
  - [x] Update `stow/zsh/.config/zsh/history.zsh` (if exists) or `.zshrc` to
    use XDG paths
  - [x] Verify shell startup performance is unaffected
- [x] Task: Conductor - User Manual Verification 'Shell Environment
  Configuration' (Protocol in workflow.md) (43e0e54)

## Phase 3: Custom Scripts Relocation [checkpoint: 311688b]

- [x] Task: Relocate log and state files in `bin/` scripts (a9c1132)
  - [x] Write tests for `bin/health-monitor.sh`, `bin/performance-monitor.sh`,
    etc.
  - [x] Update scripts to use `${XDG_STATE_HOME:-$HOME/.local/state}` for logs
- [x] Task: Relocate persistent data in custom scripts (a9c1132)
  - [x] Write tests for `bin/notes.sh` (or equivalent) and `.work-time.log`
    users
  - [x] Update scripts to use `${XDG_DATA_HOME:-$HOME/.local/share}` for data
- [x] Task: Conductor - User Manual Verification 'Custom Scripts Relocation'
  (Protocol in workflow.md) (311688b)

## Phase 4: Configuration Audit and Cleanup [checkpoint: 9323191]

- [x] Task: Update Stow package configurations (a9c1132)
  - [x] Audit `stow/nvim`, `stow/tmux`, etc., for hardcoded home paths
  - [x] Update configurations to use XDG-compliant paths where possible
- [x] Task: Final verification and documentation (a9c1132)
  - [x] Run comprehensive health check to ensure no regressions
  - [x] Update `docs/architecture.md` to reflect XDG compliance standards
- [x] Task: Conductor - User Manual Verification 'Configuration Audit and
  Cleanup' (Protocol in workflow.md) (9323191)
