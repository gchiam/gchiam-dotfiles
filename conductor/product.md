# Product Guide: My Dotfiles

## Initial Concept

Personal macOS development environment configuration files managed with GNU Stow.

## Vision

A highly modular, performance-oriented, and aesthetically consistent development
environment for macOS (Apple Silicon). This repository serves as a personal
"daily driver" while remaining clean and documented enough for others to adopt
or fork.

## Target Audience

- **Primary**: Self-use for daily development.
- **Secondary**: macOS developers looking for a modular and well-documented
  dotfiles foundation.

## Core Philosophy

- **Modularity**: Configurations are isolated into Stow packages, making them
  easy to toggle or replace.
- **Performance**: Prioritize fast shell startup times and low-latency editor
  performance.
- **Aesthetics/Consistency**: Maintain a unified visual experience (Catppuccin
  theme) across all tools (Neovim, Tmux, terminals, etc.).

## Key Features

- **Automated Setup**: One-command installation for new macOS machines.
- **Robust Symlink Management**: Interactive conflict detection and resolution
  (backup/diff/overwrite) during setup to safely migrate existing systems.
- **Profile Management**: Support for environment-specific configurations
  (Work vs. Personal).
- **Unified Theme Orchestration**: System-wide synchronization of Catppuccin
  theme flavors (Dark/Light) across all supported applications.
- **Health & Performance Monitoring**: Built-in scripts to validate setup
  integrity and monitor startup performance.
- **Standardized XDG Compliance**: Redirects all stateful files, logs, and
  persistent data to standard XDG Base Directory locations to maintain a
  clean $HOME directory.

## Success Metrics

- **Daily Reliability**: A stable, bug-free environment that "just works" for
  daily professional and personal tasks.
