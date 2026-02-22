# Product Guidelines

## Documentation Style

- **Tutorial-style**: Documentation should provide step-by-step guidance with
  clear, beginner-friendly explanations for each procedure.
- Aim for clarity and readability, ensuring that even complex configuration
  steps are easy to follow.

## Branding & Visuals

- **Strict Catppuccin**: All application themes, terminal colors, and syntax
  highlighting must adhere strictly to the Catppuccin palette to ensure maximum
  visual harmony.
- Consistency across tools (Neovim, Tmux, Alacritty, WezTerm, etc.) is a top
  priority.

## User Experience (UX) Principles

- **CLI-First**: Prioritize command-line interactions and utilities over GUI
  alternatives wherever possible.
- **Zero-Config Goal**: Focus on high levels of automation to minimize the need
  for manual setup or configuration after the initial installation.
- **Keyboard Driven**: Optimize for keyboard-centric workflows, emphasizing
  modal editing (Vim), multiplexer navigation (Tmux), and tiling window
  management (AeroSpace).

## Change Management

- **Atomic Commits**: Follow Conventional Emoji Commits for every change. Each
  commit should represent a single, logical, and atomic update to the codebase.
- Maintain a clean and navigable git history to facilitate debugging and
  rollbacks.
