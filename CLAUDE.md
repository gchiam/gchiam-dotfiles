# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working
with code in this repository.

## Repository Overview

This is a personal dotfiles repository for managing macOS development
environment configurations using GNU Stow for symlink management. The
repository follows a modular architecture where each tool/application has its
own configuration directory under `stow/` (29+ tool configurations).

## Documentation Structure

This repository uses modular documentation organized in the `docs/` directory:

- **[Setup Guide](docs/setup-guide.md)** - Installation commands and procedures
- **[Architecture](docs/architecture.md)** - Repository structure and components
- **[Development Notes](docs/development-notes.md)** - Development practices
  and configuration management
- **[Quality Assurance](docs/quality-assurance.md)** - Linting standards and
  testing requirements
- **[Commit Guidelines](docs/commit-guidelines.md)** - Git commit conventions
  and best practices

## Reference Documentation

- **[Tmux Reference](docs/tmux-reference.md)** - Complete tmux keybindings
  and configuration
- **[AeroSpace Reference](docs/aerospace-reference.md)** - Window manager
  keybindings and workflows

## Quick Reference

For immediate development needs, refer to the appropriate documentation:

- **Setting up the environment**: See [Setup Guide](docs/setup-guide.md)
- **Understanding the codebase**: See [Architecture](docs/architecture.md)
- **Making changes**: See [Development Notes](docs/development-notes.md)
- **Before committing**: See [Quality Assurance](docs/quality-assurance.md)
- **Writing commit messages**: See [Commit Guidelines](docs/commit-guidelines.md)

## Key Points for Claude Code

### Repository Context

- **Primary OS**: macOS (Apple Silicon optimized)
- **Package Manager**: Homebrew with curated package lists
- **Configuration Management**: GNU Stow for symlink management
- **Shell Environment**: Zsh with modular configuration system
- **Theme**: Consistent Catppuccin theming across all applications
- **External Dependencies**: Git submodules for themes and plugins in
  `external/`
- **Custom Extensions**: TypeScript-based Raycast extensions with separate
  package.json files

### Development Workflow

1. **Before making changes**: Read relevant documentation in `docs/` and
   consult [README.md](README.md) for high-level overview
2. **During development**: Follow patterns established in existing configurations
3. **Before committing**: Test configurations in appropriate environments
   (see Quality Assurance guide)
4. **Before committing**: Automatic linting validation via pre-commit hooks
5. **When committing**: Use Conventional Emoji Commits format (see below)
6. **After changes**: Update relevant documentation if functionality changes

### Commit Emoji Convention

Use these emojis for commit messages:

| Emoji | Type | Description |
| ----- | ---- | ----------- |
| 🎉 | feat | A new feature |
| 🐛 | fix | A bug fix |
| 📚 | docs | Documentation only changes |
| 🎨 | style | Changes that do not affect the meaning of the code |
| ♻️ | refactor | A code change that neither fixes a bug nor adds a feature |
| ⚡ | perf | A code change that improves performance |
| 🧪 | test | Adding missing tests or correcting existing tests |
| 🏗️ | build | Changes that affect the build system or external dependencies |
| 👷 | ci | Changes to CI configuration files and scripts |
| 🔧 | chore | Other changes that don't modify src or test files |
| 🔥 | remove | Remove code or files |
| 🚑️ | hotfix | Critical hotfix |

**Examples:**

- `🎉 feat(auth): add OAuth2 integration`
- `🐛 fix(api): resolve timeout issue in user endpoint`
- `📚 docs: update README with new installation steps`
- `🔧 chore: update dependencies to latest versions`

### Linting and Quality Assurance

#### Automatic Linting (No Action Required)

- **Pre-commit hooks**: Validate shell scripts, markdown, JSON, and configs
- **GitHub Actions**: Run comprehensive checks on push/PR
- **Post-commit hooks**: Run health checks and provide guidance

#### Manual Linting (For Immediate Feedback)

When you need immediate feedback while editing files:

```bash
# Markdown files
markdownlint-cli2 README.md docs/*.md

# Shell scripts
shellcheck bin/*.sh stow/*/bin/*

# All files (comprehensive check)
./bin/setup-git-hooks.sh test
```

The linting system is designed to be **commit-based** rather than
**file-change-based** for optimal performance and developer workflow.

### Important Reminders

- **Linting runs automatically** on commit via pre-commit hooks and on push
  via GitHub Actions - no manual intervention needed for standard workflow
- **For immediate feedback**, run linting tools manually as documented in
  Quality Assurance guide
- **Automation available**: Use `./bin/health-check.sh` for validation,
  `./bin/auto-sync.sh` for submodule management
- **Scripts are executable**: Files in `bin/` have execute permissions and
  should be run directly (e.g., `./bin/setup.sh`)
- **Test configurations** in appropriate environments
- **Update documentation** when adding new features or changing workflows
- **Follow established patterns** when adding new configurations
- **Keep commits atomic** and focused on single logical changes
- **Reference new documentation** in README.md when creating new
  documentation files

### File Locations

Most configurations follow XDG Base Directory Specification:

- **Modern configs**: `~/.config/` (preferred)
- **Legacy configs**: `~/.*` (when required by tools)
- **Scripts**: `~/bin/` (personal utilities)
- **Documentation**: `docs/` (reference guides)
- **Logs**: `~/.local/log/` (service logs and debugging)
- **Caches**: `~/.cache/` (application caches)
- **Application data**: `~/.local/share/` (persistent data)
- **Application state**: `~/.local/state/` (state files)

For detailed information on any aspect of this repository, consult the
appropriate documentation file in the `docs/` directory.
