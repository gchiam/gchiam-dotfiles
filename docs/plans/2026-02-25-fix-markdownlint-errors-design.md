# Design: Hybrid Formatting for Resolving Documentation Lint Errors

## 1. Introduction

This document outlines the strategy for resolving the 325+ markdownlint errors
found in the `gchiam-dotfiles` project documentation, as tracked in
[Issue #99](https://github.com/gchiam/gchiam-dotfiles/issues/99).

## 2. Goals

- **Lint Compliance**: Achieve zero errors when running `markdownlint-cli2` on
  the project's documentation.
- **Improved Readability**: Ensure tables and content are consistently
  formatted for both raw reading and rendered output.
- **Maintainability**: Establish a high-quality baseline for future
  documentation updates.

## 3. Strategy: Hybrid Formatting

We will use a two-phase approach to maximize efficiency and precision.

### 3.1 Phase 1: Automated Bulk Formatting

We will use `prettier --write` to address the majority of formatting issues,
particularly:

- `MD060/table-column-style`: Prettier will automatically align and space
  Markdown tables correctly.
- `MD013/line-length`: Standardize line wrapping.
- General white space and indentation inconsistencies.

**Scope**:

- `docs/*.md`
- `README.md`
- `.gemini-clipboard/*.md`
- `conductor/*.md` (excluding archive)

### 3.2 Phase 2: Manual Surgical Fixes

After the automated pass, we will rerun the linter and address any remaining
errors that Prettier cannot solve automatically, such as:

- `MD041/first-line-heading`: Ensuring files start with an H1.
- `MD032/blanks-around-lists`: Proper spacing before and after list blocks.
- Link fragment validation or specific heading duplication issues.

## 4. Components

- **Prettier**: The primary engine for bulk formatting.
- **Markdownlint-cli2**: The validation tool to ensure success.
- **Gemini CLI `replace` tool**: For precise manual corrections.

## 5. Success Criteria

- Running the project's standard linting command returns no errors for project
  documentation.
- Tables are visually aligned in the raw Markdown source.
- No regressions in documentation content or links.
