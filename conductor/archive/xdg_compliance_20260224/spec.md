# Specification: Harden XDG Compliance for Stateful Files

## Overview

Redirect stateful files, logs, and persistent data from the user's `$HOME`
directory to standard XDG Base Directory locations (`$XDG_STATE_HOME`,
`$XDG_DATA_HOME`) to keep the home directory clean and adhere to modern
standards.

## Functional Requirements

- **Audit Scope**:
  - Custom scripts in `bin/` and `stow/custom-bin/bin/`.
  - Configuration files in `stow/` that hardcode `$HOME` paths for state/data.
  - Shell integration files (e.g., `.zshrc`, `.zshenv`).
- **Path Redirection**:
  - Redirect logs and temporary state to `${XDG_STATE_HOME:-$HOME/.local/state}`.
  - Redirect persistent data files to `${XDG_DATA_HOME:-$HOME/.local/share}`.
- **XDG Defaults**:
  - Use standard defaults if XDG environment variables are not defined:
    - `XDG_CONFIG_HOME`: `$HOME/.config`
    - `XDG_DATA_HOME`: `$HOME/.local/share`
    - `XDG_STATE_HOME`: `$HOME/.local/state`
    - `XDG_CACHE_HOME`: `$HOME/.cache`

## Non-Functional Requirements

- **Graceful Failure**: Scripts should verify or create the target XDG
  directories before use.
- **Portability**: Maintain compatibility across macOS (darwin) environments.

## Acceptance Criteria

- Stateful files like `~/.notes` and `~/.work-time.log` are relocated to
  appropriate XDG paths in the code.
- No new stateful files or logs are created directly in `$HOME` by internal
  scripts or configurations.
- All scripts in the audited scope use variable-based paths with XDG defaults.

## Out of Scope

- **Automatic Migration**: Existing files will NOT be moved automatically.
  The user is responsible for manual migration of their existing data to the
  new locations.
