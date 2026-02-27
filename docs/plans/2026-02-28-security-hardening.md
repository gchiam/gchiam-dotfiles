# Implement Security Hardening and Checklist for Shell Scripts Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans
> to implement this plan task-by-task.

**Goal:** Formalize security practices for shell scripts in the repository,
ensuring safer evaluations, mandatory input validation, and exploring
secret-scanning tools, ultimately reducing the risk of accidental vulnerabilities.

**Architecture:** This will involve modifying existing documentation
(`docs/quality-assurance.md`), potentially updating existing shell scripts
to use safer constructs and include input validation, and integrating new tools
(e.g., `gitleaks`) into pre-commit hooks for automated checks.

**Tech Stack:** Shell scripting (Bash/Zsh), Markdown, Git, pre-commit hooks,
`gitleaks` (potential new tool).

---

## Task 1: Add Security Checklist to docs/quality-assurance.md

**Files:**

- Modify: `docs/quality-assurance.md`

### Step 1: Add Security Checklist section

Append a new section titled "## 🛡️ Security Checklist for Shell Scripts"
to the `docs/quality-assurance.md` file. This section will contain the
initial checklist items proposed in the issue description.

```markdown
## 🛡️ Security Checklist for Shell Scripts

- [ ] Enforce the use of `[[ ... ]]` over `[ ... ]` for safer evaluations.
- [ ] Implement mandatory input validation for all scripts accepting command-line arguments.
- [ ] Explore integration of local secret-scanning tools (e.g., `gitleaks`) into pre-commit hooks.
- [ ] Ensure proper quoting of variables to prevent word splitting and glob expansion.
- [ ] Avoid using `eval` with untrusted input.
- [ ] Sanitize or validate all external input (user input, environment variables, file contents).
- [ ] Use `set -euo pipefail` for robust script execution.
- [ ] Limit script privileges where possible (Principle of Least Privilege).
- [ ] Log sensitive actions, but avoid logging sensitive data.
- [ ] Regularly review scripts for potential security vulnerabilities.
```

### Step 2: Commit

```bash
git add docs/quality-assurance.md docs/plans/2026-02-28-security-hardening.md
git commit -m "docs(security): add initial security checklist to quality assurance guide"
```

## Task 2: Enforce `[[ ... ]]` over `[ ... ]` in `bin/setup-git.sh`

**Files:**

- Modify: `bin/setup-git.sh`
- Create: `tests/setup-git.bats`

### Step 1: Write a failing test

Create a new bats test file `tests/setup-git.bats` to initially confirm
the presence of the `[` pattern. This test will be designed to *pass* if the
old pattern is found, and then *fail* once it's replaced.

```bash
# tests/setup-git.bats
#!/usr/bin/env bats

@test "setup-git.sh uses [[ for safer evaluations (initial check)" {
  # This test checks for a specific instance of '[' usage that will be replaced.
  # We are looking for 'if [ -z "$HOME" ]; then' as an example.
  run grep 'if \[ -z "$HOME" \]; then' bin/setup-git.sh
  [ "$status" -eq 0 ] # Expect to find the old pattern, so this test passes initially
}
```

### Step 2: Run test to verify it passes (initially)

Run: `bats tests/setup-git.bats`
Expected: PASS (because the `[` pattern is still present)

### Step 3: Modify `bin/setup-git.sh` to use `[[ ... ]]`

Locate the line `if [ -z "$HOME" ]; then` in `bin/setup-git.sh`
and replace it with `if [[ -z "$HOME" ]]; then`.

```bash
# bin/setup-git.sh (excerpt)
# Old:
# if [ -z "$HOME" ]; then
# New:
# if [[ -z "$HOME" ]]; then
```

### Step 4: Run test to verify it fails (after change)

Run: `bats tests/setup-git.bats`
Expected: FAIL (because the `[` pattern should no longer be found)

### Step 5: Adjust test to look for `[[` and verify it passes

Modify `tests/setup-git.bats` to search for `if \[\[ -z "$HOME" \]\]; then`.

```bash
# tests/setup-git.bats
#!/usr/bin/env bats

@test "setup-git.sh uses [[ for safer evaluations (final check)" {
  run grep 'if \[\[ -z "$HOME" \]\]; then' bin/setup-git.sh
  [ "$status" -eq 0 ] # Expect to find the new pattern
}
```

### Task 2 - Step 6: Run test to verify it passes

Run: `bats tests/setup-git.bats`
Expected: PASS

### Task 2 - Step 7: Commit

```bash
git add bin/setup-git.sh tests/setup-git.bats docs/plans/2026-02-28-security-hardening.md
git commit -m "refactor(shell): use [[ for safer evaluations in setup-git.sh and add test"
```

## Task 3: Implement input validation in `bin/setup.sh`

**Files:**

- Modify: `bin/setup.sh`
- Create: `tests/setup.bats`

### Step 1: Write a failing test for invalid argument

Create a new bats test file `tests/setup.bats` to check for invalid arguments.
This test will ensure that the script exits with an error if an unknown
argument is provided.

```bash
# tests/setup.bats
#!/usr/bin/env bats

@test "setup.sh exits with error for invalid argument" {
  run bin/setup.sh --invalid-arg
  [ "$status" -ne 0 ] # Expect a non-zero exit status for invalid arguments
  [ "${lines[0]}" = "Error: Unknown argument: --invalid-arg" ] # Expect specific
                                                             # error message
}```

### Step 2: Run test to verify it fails

Run: `bats tests/setup.bats`
Expected: FAIL (because the script does not yet handle invalid arguments and won't produce the exact error message)

### Step 3: Implement argument parsing and validation in `bin/setup.sh`

Add a `while` loop to parse arguments and a `case` statement to handle known
arguments. Add an error message for unknown arguments.

```bash
# bin/setup.sh (excerpt)

# ... existing code ...

# Argument parsing
DEBUG_MODE=false
while [[ "$#" -gt 0 ]]; do
  key="$1"
  case $key in
    --debug)
      DEBUG_MODE=true
      shift # past argument
      ;;
    --help|-h)
      echo "Usage: setup.sh [--debug]"
      exit 0
      ;;
    *)
      echo "Error: Unknown argument: $key" >&2
      exit 1
      ;;
  esac
done

# ... rest of the script ...

if \$DEBUG_MODE; then
  print_info "Debug mode is enabled."
fi
```

### Step 4: Run test to verify it passes

Run: `bats tests/setup.bats`
Expected: PASS

### Step 5: Write a failing test for `--debug` argument

Add another test to `tests/setup.bats` to verify the `--debug` flag is
processed correctly.

```bash
# tests/setup.bats

@test "setup.sh enters debug mode with --debug argument" {
  run bin/setup.sh --debug
  [ "$status" -eq 0 ] # Expect zero exit status
  [ "${lines[*]}" =~ "Debug mode is enabled." ] # Expect debug message in output
}
```

### Task 3 - Step 6: Run test to verify it passes

Run: `bats tests/setup.bats`
Expected: PASS

### Task 3 - Step 7: Commit

```bash
git add bin/setup.sh tests/setup.bats docs/plans/2026-02-28-security-hardening.md
git commit -m "feat(shell): add argument parsing and validation to setup.sh"
```

## Task 4: Explore integration of `gitleaks` into pre-commit hooks

**Files:**

- Modify: `.pre-commit-config.yaml`
- Modify: `bin/setup-git-hooks.sh`
- Create: `docs/gitleaks-integration.md` (or similar documentation for usage)

### Step 1: Research `gitleaks` pre-commit hook setup

Use web search (e.g., Google) to find official documentation and common
practices for integrating `gitleaks` into `pre-commit` hooks. Look for
configurations, recommended versions, and any specific considerations
for shell scripts.

### Step 2: Add `gitleaks` to `.pre-commit-config.yaml`

Add a new entry for `gitleaks` in the `.pre-commit-config.yaml` file.
This will typically involve specifying the repository, revision, and hooks.

```yaml
# .pre-commit-config.yaml (excerpt)
# ... existing hooks ...

- repo: https://github.com/gitleaks/gitleaks
  rev: v8.18.3 # Use a specific version
  hooks:
    - id: gitleaks
```

### Step 3: Modify `bin/setup-git-hooks.sh` to ensure `pre-commit` is installed and hooks are updated

Ensure `bin/setup-git-hooks.sh` installs `pre-commit` if it's not already
installed and runs `pre-commit install` to set up the hooks.

### Step 4: Write a failing test (optional but good practice for pre-commit hooks)

Create a temporary file with a simulated secret to verify that `gitleaks`
correctly identifies it and prevents the commit.

```bash
# In a temporary file for testing
echo "MY_SECRET_KEY=supersecretkey" > temp_secret.txt
git add temp_secret.txt
git commit -m "test: add secret" # This commit should be blocked by gitleaks
```

### Step 5: Run test to verify it fails

Attempt to commit the temporary file with the secret.
Expected: `gitleaks` should detect the secret and prevent the commit,
showing an error message.

### Task 4 - Step 6: Remove temporary secret and commit the changes

Remove `temp_secret.txt` and commit the `.pre-commit-config.yaml` and `bin/setup-git-hooks.sh`
changes.

```bash
rm temp_secret.txt && \
git add . && \
git commit -m "ci(gitleaks): integrate gitleaks into pre-commit hooks"
```
