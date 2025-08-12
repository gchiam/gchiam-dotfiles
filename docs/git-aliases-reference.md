# Git Aliases Reference

This document provides a comprehensive reference for all git aliases
configured in this dotfiles repository. Git aliases are configured in two
places:

1. **Shell aliases** (`stow/zsh/.config/zsh/aliases.zsh:33-72`) - Quick shell shortcuts
2. **Git native aliases** (`bin/setup-git.sh`) - Feature-rich git commands

## Quick Reference

### Shell Git Aliases

Basic git operations with short, memorable aliases:

| Alias | Command | Description |
|-------|---------|-------------|
| `g` | `git` | Base git command |
| `ga` | `git add` | Add files to staging |
| `gaa` | `git add --all` | Add all files to staging |
| `gc` | `git commit` | Create commit |
| `gcm` | `git commit -m` | Commit with message |
| `gca` | `git commit --amend` | Amend last commit |
| `gcan` | `git commit --amend --no-edit` | Amend without editing message |
| `gco` | `git checkout` | Switch branches/checkout files |
| `gcb` | `git checkout -b` | Create and switch to new branch |
| `gd` | `git diff` | Show working directory changes |
| `gds` | `git diff --staged` | Show staged changes |
| `gdt` | `git difftool` | Launch diff tool |
| `gf` | `git fetch` | Fetch from remote |
| `gp` | `git push` | Push to remote |
| `gpl` | `git pull` | Pull from remote |

### Branch Management

| Alias | Command | Description |
|-------|---------|-------------|
| `gb` | `git branch` | List/manage branches |
| `gba` | `git branch -a` | List all branches (local & remote) |
| `gbd` | `git branch -d` | Delete branch (safe) |
| `gbD` | `git branch -D` | Force delete branch |

### Git Aliases that Reference Native Aliases

These shell aliases call git native aliases defined in `setup-git.sh`:

| Alias | Git Command | Description |
|-------|-------------|-------------|
| `gfp` | `git fp` | Fetch and prune (setup-git.sh:42) |
| `gl` | `git l` | Formatted log with graph (setup-git.sh:19) |
| `gll` | `git lg` | Log graph for all branches (setup-git.sh:20) |
| `gs` | `git s` | Short status (setup-git.sh:47) |
| `gss` | `git st` | Status with branch info (setup-git.sh:50) |
| `gmain` | `git main` | Switch to main branch (setup-git.sh:37) |
| `gmaster` | `git master` | Switch to master branch (setup-git.sh:39) |
| `gcleanup` | `git cleanup` | Clean merged branches (setup-git.sh:33) |
| `grecent` | `git recent` | Show recent branches (setup-git.sh:46) |

### Stash Operations

| Alias | Command | Description |
|-------|---------|-------------|
| `gst` | `git stash` | Stash changes |
| `gstp` | `git stash pop` | Apply and remove latest stash |
| `gstl` | `git stash list` | List all stashes |

### Remote Operations

| Alias | Command | Description |
|-------|---------|-------------|
| `gr` | `git remote` | Manage remotes |
| `grv` | `git remote -v` | Show remote URLs |

### Worktree

| Alias | Command | Description |
|-------|---------|-------------|
| `gw` | `git worktree` | Manage worktrees |

## Native Git Aliases

These are configured via `git config --global alias.*` in `bin/setup-git.sh`:

### Diff Operations

| Alias | Command | Description |
|-------|---------|-------------|
| `d` | `diff` | Standard diff |
| `dc` | `diff --cached` | Diff staged changes |
| `dw` | `diff --word-diff=color` | Word-level diff with color |
| `dcw` | `diff --word-diff=color --cached` | Word diff for staged |
| `dwc` | `diff --word-diff=color --cached` | Same as dcw |
| `dt` | `difftool` | Launch diff tool |
| `dtg` | `difftool --gui` | Launch GUI diff tool |

### Log Operations

| Alias | Command | Description |
|-------|---------|-------------|
| `lp` | Custom pretty log format | Beautiful colored log |
| `lr` | `lp --reverse` | Pretty log in reverse order |
| `l` | `lp --graph` | Pretty log with graph |
| `lg` | `l --all` | Graph log for all branches |
| `lm` | `l main...` | Changes since main branch |
| `lms` | `l master...` | Changes since master branch |
| `lom` | `l origin/main...` | Changes since origin/main |
| `loh` | `l origin/HEAD...` | Changes since origin/HEAD |
| `standup` | Custom standup log | Last 2 weeks of commits |
| `last` | `log -1 HEAD` | Show last commit |
| `search` | Custom search log | Search commits by message |

### Branch Operations

| Alias | Command | Description |
|-------|---------|-------------|
| `br` | `branch` | Basic branch command |
| `bo` | `branch --all --verbose --verbose` | Verbose all branches |
| `bom` | `branch --all --list "*gchiam*" -vv` | User-specific branches |
| `bv` | `branch --verbose --verbose` | Verbose local branches |
| `bvm` | `branch --list "*gchiam*" -vv` | User-specific local branches |
| `cleanup` | Custom cleanup script | Delete merged branches |
| `cbr` | `rev-parse --abbrev-ref HEAD` | Current branch name |
| `co` | `checkout` | Checkout branches/files |
| `main` | `checkout main` | Switch to main branch |
| `mn` | `checkout main` | Short for main |
| `master` | `checkout master` | Switch to master branch |
| `ms` | `checkout master` | Short for master |
| `recent` | Custom recent branches | Show 10 most recent branches |

### Commit Operations

| Alias | Command | Description |
|-------|---------|-------------|
| `ci` | `commit` | Create commit |
| `cp` | `cherry-pick` | Cherry-pick commits |

### Fetch/Pull Operations

| Alias | Command | Description |
|-------|---------|-------------|
| `fp` | Custom fetch-prune | Fetch with prune |
| `fpm` | `fp main` | Fetch-prune main branch |
| `pl` | `pull` | Pull from remote |
| `plp` | `pull --prune` | Pull with prune |

### Status Operations

| Alias | Command | Description |
|-------|---------|-------------|
| `s` | `status -sb` | Short status with branch |
| `st` | `status -b` | Status with branch info |

### Utility Operations

| Alias | Command | Description |
|-------|---------|-------------|
| `adddiff` | Custom script | Add modified files from status |
| `sm` | `submodule` | Submodule operations |
| `unstage` | `reset HEAD --` | Unstage files |

## Configuration Features

### Visual Enhancements

- **Delta Pager**: Uses delta with Catppuccin theme for enhanced diffs
- **Color Configuration**: Comprehensive color scheme for all git operations  
- **Line Numbers**: Enabled in delta for better code review
- **Side-by-side Diff**: Available via delta configuration

### Security

- **GPG Signing**: Commits are signed using SSH keys (`commit.gpgsign true`)
- **SSH Format**: Uses SSH format for GPG signing

### Workflow Optimizations

- **Rebase on Pull**: `pull.rebase true` for cleaner history
- **Auto Stash**: `rebase.autoStash true` for seamless rebases
- **Histogram Diff**: Better diff algorithm
- **Color-moved Detection**: Highlights moved code blocks

### Tools Integration

- **Diff Tool**: Configured to use `vimdiff` (Neovim)
- **Merge Tool**: Uses `vimdiff` with three-way merge layout
- **GUI Tools**: `opendiff` for macOS GUI operations

## Usage Examples

### Daily Workflow

```bash
# Check status and recent changes
gs                  # Short status
gl                  # Pretty log with graph
grecent            # Show recent branches

# Make changes
ga .               # Add all changes
gcm "feat: add new feature"  # Commit with message

# Branch management
gcb feature/new    # Create and switch to new branch
gmain              # Switch back to main
gcleanup           # Clean up merged branches
```

### Advanced Operations

```bash
# Detailed diff analysis
gd                 # Working directory changes
gds                # Staged changes
gdt                # Launch diff tool

# Log investigation
git search "bug"   # Search commit messages
git standup        # Personal commit history
git lm             # Changes since main branch
```

### Stash Workflow

```bash
gst                # Stash current changes
gmain              # Switch to main
gpl                # Pull latest
gcb hotfix/urgent  # Create hotfix branch
gstp               # Pop stashed changes
```

## File Locations

- **Shell Aliases**: `stow/zsh/.config/zsh/aliases.zsh:33-72`
- **Git Configuration**: `bin/setup-git.sh`
- **Theme Configuration**: `~/dotfiles/external/catppuccin/delta/catppuccin.gitconfig`

## Setup

Run the git setup script to configure all native git aliases:

```bash
./bin/setup-git.sh
```

Shell aliases are automatically loaded when sourcing the zsh configuration.
