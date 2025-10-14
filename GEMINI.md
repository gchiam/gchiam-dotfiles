# GEMINI.md: AI Assistant Guide

This document provides context for AI assistants to understand and interact with this dotfiles repository.

## Project Overview

This is a personal dotfiles repository for a macOS (Apple Silicon optimized) development environment. It uses GNU Stow to manage symlinks for various configuration files and scripts. The goal is to create a consistent, reproducible, and highly customized development environment.

The project is built around a modular architecture, with each tool's configuration residing in its own directory under `stow/`. It includes configurations for:

*   **Primary OS**: macOS (Apple Silicon optimized)
*   **Package Manager**: Homebrew with curated package lists
*   **Configuration Management**: GNU Stow for symlink management
*   **Shell Environment**: Zsh with a modular configuration system
*   **Editor**: Neovim (LazyVim distribution)
*   **Terminals**: Alacritty, Kitty, WezTerm
*   **Window Management**: AeroSpace
*   **Theming**: Consistent Catppuccin theming across all applications

The repository also contains a rich set of scripts in the `bin/` directory for setup, automation, health checks, and performance monitoring.

## Documentation Structure

This repository uses modular documentation organized in the `docs/` directory. For immediate development needs, refer to the appropriate documentation:

- **Setting up the environment**: See [Setup Guide](docs/setup-guide.md)
- **Understanding the codebase**: See [Architecture](docs/architecture.md)
- **Making changes**: See [Development Notes](docs/development-notes.md)
- **Before committing**: See [Quality Assurance](docs/quality-assurance.md)
- **Writing commit messages**: See [Commit Guidelines](docs/commit-guidelines.md)

## Building and Running

This project is not "built" in a traditional sense. Instead, it is "installed" by symlinking the configuration files into the user's home directory.

**Key Commands:**

*   **Quick Setup:**
    ```bash
    ./bin/setup.sh
    ```
*   **Interactive Setup (Recommended):**
    ```bash
    ./bin/setup-interactive.sh
    ```
*   **Manual Installation (using Stow):**
    ```bash
    # Install all configurations
    ./bin/setup-stow.sh

    # Install a specific tool's configuration
    stow -d stow -t ~ nvim
    ```
*   **Package Installation (using Homebrew):**
    ```bash
    brew bundle --file=stow/brew/.Brewfile
    ```

## Development Workflow

1.  **Before making changes**: Read relevant documentation in `docs/`.
2.  **During development**: Follow patterns established in existing configurations.
3.  **Before committing**: Automatic linting validation via pre-commit hooks.
4.  **When committing**: Use Conventional Emoji Commits format.
5.  **After changes**: Update relevant documentation if functionality changes.

## Linting and Quality Assurance

Linting runs automatically on commit via pre-commit hooks and on push via GitHub Actions. No manual intervention is needed for the standard workflow.

**Manual Linting (For Immediate Feedback):**

When you need immediate feedback while editing files:

```bash
# Markdown files
markdownlint-cli2 README.md docs/*.md

# Shell scripts
shellcheck bin/*.sh stow/*/bin/*

# All files (comprehensive check)
./bin/setup-git-hooks.sh test
```

## Development Conventions

*   **Modularity:** Each tool's configuration is self-contained within its own directory in `stow/`.
*   **Symlink Management:** GNU Stow is the single source of truth for managing symlinks.
*   **Documentation:** The `docs/` directory contains extensive documentation on architecture, workflows, and tool-specific references.
*   **Automation:** The `bin/` directory contains scripts for automating setup, maintenance, and other tasks.
*   **CI/CD:** The project uses GitHub Actions for comprehensive CI/CD, including linting, testing on macOS, performance regression testing, and security scanning.
*   **Commit Style:** Based on the commit history, the project follows the [Conventional Commits](https://www.conventionalcommits.org/) specification. Commits should be in the format `type(scope): message`.
*   **File Locations:** Most configurations follow the XDG Base Directory Specification:
    *   **Modern configs**: `~/.config/` (preferred)
    *   **Legacy configs**: `~/.*` (when required by tools)
    *   **Scripts**: `~/bin/` (personal utilities)
    *   **Documentation**: `docs/` (reference guides)
*   **Atomic Commits:** Keep commits atomic and focused on single logical changes.