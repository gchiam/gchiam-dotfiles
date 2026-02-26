# Zsh Plugin Deferral Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to
> implement this plan task-by-task.

**Goal:** Defer non-essential Zsh plugins to improve startup responsiveness.

**Architecture:** Use `antidote`'s `kind:defer` tag in plugin configuration
files, which leverages `romkatv/zsh-defer`.

**Tech Stack:** Zsh, Antidote, romkatv/zsh-defer.

---

## Task 1: Baseline Performance Measurement

**Files:**

- Run: `./bin/measure-shell-performance.sh`

### Step 1: Run baseline performance measurement

Run: `./bin/measure-shell-performance.sh 10`
Expected: Record the current average startup time.

---

## Task 2: Update Main Plugin Configuration

**Files:**

- Modify: `stow/antidote/.config/antidote/.zsh_plugins.txt`

### Task 2 Step 1: Add romkatv/zsh-defer and defer non-essential plugins

Modify `stow/antidote/.config/antidote/.zsh_plugins.txt`:

```text
# ... (existing content)
mattmc3/ez-compinit
zsh-users/zsh-completions kind:fpath path:src

romkatv/zsh-defer  # Explicitly add for clarity

Aloxaf/fzf-tab kind:defer # Deferred
# ...
olets/zsh-abbr kind:defer
rupa/z kind:defer # Deferred
zdharma-continuum/fast-syntax-highlighting kind:defer
zsh-users/zsh-autosuggestions kind:defer # Deferred
zsh-users/zsh-history-substring-search kind:defer # Deferred
# ...
```

### Task 2 Step 2: Commit changes

Run: `git add stow/antidote/.config/antidote/.zsh_plugins.txt`
Run: `git commit -m "⚡ perf(antidote): defer non-essential plugins in main config"`

---

## Task 3: Update Work Plugin Configuration

**Files:**

- Modify: `stow/antidote/.config/antidote/.zsh_plugins_work.txt`

### Task 3 Step 1: Defer non-essential plugins in work config

Modify `stow/antidote/.config/antidote/.zsh_plugins_work.txt`:

```text
# ...
Aloxaf/fzf-tab kind:defer # Deferred
# ...
rupa/z kind:defer # Deferred
zsh-users/zsh-autosuggestions kind:defer # Deferred
zsh-users/zsh-history-substring-search kind:defer # Deferred
# ...
```

### Task 3 Step 2: Commit changes

Run: `git add stow/antidote/.config/antidote/.zsh_plugins_work.txt`
Run: `git commit -m "⚡ perf(antidote): defer non-essential plugins in work config"`

---

## Task 4: Update Performance Documentation

**Files:**

- Modify: `docs/performance-tuning.md`

### Task 4 Step 1: Update zsh-defer recipe

Modify `docs/performance-tuning.md` (Recipe 1 section):

````markdown
#### 🚀 **Recipe 1: Ultra-Fast Shell Startup**

Target: < 0.1s startup time

Using `romkatv/zsh-defer` via `antidote`'s `kind:defer` tag.

```bash
# In .zsh_plugins.txt
romkatv/zsh-defer
zsh-users/zsh-autosuggestions kind:defer
zdharma-continuum/fast-syntax-highlighting kind:defer
```
````

### Task 4 Step 2: Commit changes

Run: `git add docs/performance-tuning.md`
Run: `git commit -m "📝 docs(perf): update zsh-defer optimization recipe"`

---

## Task 5: Verify Implementation and Performance

**Files:**

- Run: `./bin/measure-shell-performance.sh`

### Task 5 Step 1: Force antidote to re-generate the static cache

Run:

```bash
rm -f ~/.config/antidote/.zsh_plugins.zsh
source /opt/homebrew/share/antidote/antidote.zsh
antidote load ~/.config/antidote/.zsh_plugins.txt \
  > ~/.config/antidote/.zsh_plugins.zsh
```

### Task 5 Step 2: Run performance measurement

Run: `./bin/measure-shell-performance.sh 10`
Expected: Startup time should be maintained or improved.

### Task 5 Step 3: Manually verify plugins are working

Open a new shell and type a few characters to see if autosuggestions and
syntax highlighting appear (after a short idle period). Check if `rupa/z`
and `fzf-tab` are functional.

### Task 5 Step 4: Final Commit

Run: `git status`
Run: `git commit -m "⚡ perf: finalize plugin deferral implementation"`
