# Fix Documentation Lint Errors Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement
> this plan task-by-task.

**Goal:** Achieve zero markdownlint errors in project documentation using a
hybrid strategy of automated formatting and manual fixes.

**Architecture:** Two-phase approach: 1) Automated bulk formatting with
Prettier, 2) Manual surgical remediation of remaining lint errors.

**Tech Stack:** Prettier, markdownlint-cli2.

---

## Task 1: Automated Bulk Formatting

### Files for Task 1

- Modify: `docs/*.md`
- Modify: `README.md`
- Modify: `.gemini-clipboard/*.md`
- Modify: `conductor/*.md` (excluding archive)

### Step 1.1: Run Prettier on documentation files

Run:

```bash
npx prettier --write "docs/*.md" "README.md" \
  ".gemini-clipboard/*.md" "conductor/*.md"
```

### Step 1.2: Verify formatting changes

Review a few files (e.g., `docs/aerospace-reference.md`) to ensure tables are
properly aligned.

### Step 1.3: Commit Task 1

```bash
git add .
git commit -m "🎨 style: bulk format documentation with Prettier"
```

## Task 2: Baseline Re-assessment

### Step 2.1: Run markdownlint to identify remaining errors

Run:

```bash
markdownlint-cli2 "**/*.md" "!external/**/*.md" \
  "!stow/alacritty/.config/alacritty/catppuccin/**/*.md" \
  "!stow/tmux/.tmux/plugins/**/*.md" "!tests/libs/**/*.md"
```

### Step 2.2: Note remaining error types

Identify which rules (e.g., `MD041`, `MD032`) are still being violated.

## Task 3: Resolve `MD041/first-line-heading` Errors

### Files for Task 3

- Modify: `.gemini-clipboard/*.md` (or any other identified files)

### Step 3.1: Add H1 headings where missing

Ensure the first line of each file is a top-level heading.

### Step 3.2: Commit Task 3

```bash
git add .
git commit -m "📝 docs: add missing top-level headings (MD041)"
```

## Task 4: Resolve `MD032/blanks-around-lists` Errors

### Files for Task 4

- Modify: Various identified files

### Step 4.1: Add blank lines around list blocks

Ensure all lists are preceded and followed by a blank line.

### Step 4.2: Commit Task 4

```bash
git add .
git commit -m "📝 docs: ensure blank lines around lists (MD032)"
```

## Task 5: Resolve `MD013/line-length` Lingering Errors

### Step 5.1: Manually wrap long lines

In cases where Prettier didn't wrap (e.g., long URLs or specific blocks),
manually wrap them.

### Step 5.2: Commit Task 5

```bash
git add .
git commit -m "📝 docs: fix lingering line length issues (MD013)"
```

## Task 6: Final Surgical Cleanup

### Step 6.1: Address any remaining miscellaneous lint errors

Fix `MD024`, `MD012`, `MD051`, etc., as reported by the linter.

### Step 6.2: Commit Task 6

```bash
git add .
git commit -m "📝 docs: finalize lint error resolution"
```

## Task 7: Final Verification

### Step 7.1: Run final lint check

Run:

```bash
markdownlint-cli2 "**/*.md" "!external/**/*.md" \
  "!stow/alacritty/.config/alacritty/catppuccin/**/*.md" \
  "!stow/tmux/.tmux/plugins/**/*.md" "!tests/libs/**/*.md"
```

Expected: 0 errors (within project scope).

### Step 7.2: Simulate CI validation

Run the project's standard quality check command if available.
