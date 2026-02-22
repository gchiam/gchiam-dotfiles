# Specification: Stow Conflict Detection and Backup

## Overview

Enhance the `bin/setup-stow.sh` script to detect existing files in the target
directory (usually `$HOME`) that would prevent GNU Stow from creating symlinks.
The script will provide an interactive resolution mode to safely backup, diff,
or overwrite these conflicting files.

## Functional Requirements

- **Conflict Detection**:
  - Identify existing regular files that are not symlinks.
  - Identify existing symlinks that point to a different source than the
    dotfiles repository.
  - Identify type mismatches (e.g., a directory exists where a symlink to a file
    should be).
- **Interactive Resolution**:
  - For each conflict, prompt the user with the following options:
    - **[b]ackup**: Rename the existing file by appending a `.bak` extension
      (e.g., `.zshrc` -> `.zshrc.bak`) and proceed with stowing.
    - **[d]iff**: Show a side-by-side comparison between the existing file and
      the dotfiles version using `delta`.
    - **[o]verwrite**: Permanently delete the existing file and replace it with
      the dotfiles symlink.
    - **[s]kip**: Leave the existing file untouched and do not stow this
      specific package.
- **Workflow Integration**:
  - The script should perform a detection pass for each Stow package before
    attempting the `stow` command.

## Non-Functional Requirements

- **Safety**: Ensure that "overwrite" requires a clear selection to prevent
  accidental data loss.
- **Performance**: Conflict detection should be fast and occur before the main
  stowing loop begins.
- **Dependency Awareness**: Check for the existence of `delta` before attempting
  to use it for diffs; fallback to standard `diff` if missing.

## Acceptance Criteria

- Running `./bin/setup-stow.sh` on a machine with existing config files (like an
  existing `~/.zshrc`) triggers the interactive resolution prompt.
- Selecting 'backup' successfully renames the file and allows Stow to create
  the symlink.
- Selecting 'diff' correctly displays the differences using `delta`.
- The script exits cleanly if the user cancels or skips all conflicts.

## Out of Scope

- Automatic merging of configuration files.
- Managing backups in a central repository (backups are in-place only).
