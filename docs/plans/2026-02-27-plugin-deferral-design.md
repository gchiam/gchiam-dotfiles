# ⚡ Design: Zsh Plugin Deferral for Faster Startup

## Objective

Optimize Zsh startup time by deferring the loading of non-essential plugins
using `romkatv/zsh-defer` via the `antidote` plugin manager.

## Context

Current Zsh startup is monitored and performance is measured. The goal is to
provide an "instant" feel when opening new terminal sessions by deferring
plugins like `zsh-autosuggestions` and `fast-syntax-highlighting` until after
the initial prompt is rendered.

## Proposed Design

The implementation will follow the idiomatic `antidote` integration by using
`kind:defer` in the plugin configuration files. `antidote` automatically
handles the `romkatv/zsh-defer` dependency when it encounters a `kind:defer`
tag.

### Key Components

1. **Antidote Configuration (`.zsh_plugins.txt` & `.zsh_plugins_work.txt`)**
   - Explicitly add `romkatv/zsh-defer` to the plugin list for clarity.
   - Apply `kind:defer` to non-essential plugins.

2. **Performance Documentation (`docs/performance-tuning.md`)**
   - Update the `zsh-defer` recipe to reference the `romkatv/zsh-defer` plugin
     instead of the simple backgrounding function.

## Approach 1: Idiomatic Antidote Integration (Recommended)

This approach leverages `antidote`'s built-in support for `kind:defer`, which
uses `romkatv/zsh-defer` to source plugins when the shell is idle.

### Changes

- **`stow/antidote/.config/antidote/.zsh_plugins.txt`**
  - Add `romkatv/zsh-defer`.
  - Defer `zsh-users/zsh-autosuggestions`.
  - Defer `zsh-users/zsh-history-substring-search`.
  - Defer `rupa/z`.
  - Defer `Aloxaf/fzf-tab`.

- **`stow/antidote/.config/antidote/.zsh_plugins_work.txt`**
  - Similar deferral for work-specific plugins.

- **`docs/performance-tuning.md`**
  - Update documentation to show how `zsh-defer` is integrated.

## Success Criteria

- [ ] Zsh startup time is maintained or improved (ideally < 0.1s).
- [ ] Non-essential plugins work as expected after the initial prompt appears.
- [ ] `zsh-defer` is correctly loaded by `antidote`.

## Testing & Verification

- Measure startup time before and after changes using
  `./bin/measure-shell-performance.sh`.
- Manually verify that deferred plugins (e.g., autosuggestions) are active.
- Check `stow/antidote/.config/antidote/.zsh_plugins.zsh` to ensure
  `zsh-defer` is correctly utilized.
