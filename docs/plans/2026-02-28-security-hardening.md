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

## Task 2: Enforce `[[ ... ]]` over `[ ... ]` in `bin/lib/utils.sh`

**Files:**

- Modify: `bin/lib/utils.sh`
- Create: `tests/utils.bats`

### Step 1: Write a failing test (by temporarily introducing `[` in the script)

**IMPORTANT:** Before running this test, you will first need to manually modify `bin/lib/utils.sh` to temporarily introduce the `[` pattern that this test will look for. Change the first instance of `if [[ -t 1 ]]` to `if [ -t 1 ]`. This is a temporary modification *only* for the purpose of demonstrating the TDD flow for this task.

Create a new bats test file `tests/utils.bats` to initially confirm
the presence of the `[` pattern. This test will be designed to *pass* if the
old pattern is found, and then *fail* once it's replaced.

```bash
# tests/utils.bats
#!/usr/bin/env bats

@test "utils.sh uses [[ for safer evaluations (initial check)" {
  # This test checks for a specific instance of '[' usage that will be replaced.
  # We are looking for 'if [ -t 1 ]' as an example.
  run grep 'if \[ -t 1 \]' bin/lib/utils.sh
  [ "$status" -eq 0 ] # Expect to find the old pattern, so this test passes initially
}
```

### Step 2: Run test to verify it passes (initially)

Run: `bats tests/utils.bats`
Expected: PASS (because the `[` pattern is present, as per manual modification in Step 1)

### Step 3: Modify `bin/lib/utils.sh` to use `[[ ... ]]`

Locate the line `if [ -t 1 ]` in `bin/lib/utils.sh`
and replace it with `if [[ -t 1 ]]`.

```bash
# bin/lib/utils.sh (excerpt)
# Old:
# if [ -t 1 ]
# New:
# if [[ -t 1 ]]
```

### Step 4: Run test to verify it fails (after change)

Run: `bats tests/utils.bats`
Expected: FAIL (because the `[` pattern should no longer be found)

### Step 5: Adjust test to look for `[[` and verify it passes

Modify `tests/utils.bats` to search for `if \[\[ -t 1 \]\]`.

```bash
# tests/utils.bats
#!/usr/bin/env bats

@test "utils.sh uses [[ for safer evaluations (final check)" {
  run grep 'if \[\[ -t 1 \]\]' bin/lib/utils.sh
  [ "$status" -eq 0 ] # Expect to find the new pattern
}
```

### Task 2 - Step 6: Run test to verify it passes

Run: `bats tests/utils.bats`
Expected: PASS

### Task 2 - Step 7: Commit

```bash
git add bin/lib/utils.sh tests/utils.bats docs/plans/2026-02-28-security-hardening.md
git commit -m "refactor(shell): use [[ for safer evaluations in bin/lib/utils.sh and add test"
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

## Task 4: Integrate `gitleaks` into custom pre-commit hook

**Files:**

- Modify: `bin/setup-git-hooks.sh`
- Modify: `bin/setup.sh` (to ensure `gitleaks` is installed)

### Step 1: Add `gitleaks` installation to `bin/setup.sh`

Modify `bin/setup.sh` to check for and install `gitleaks` using Homebrew, similar to how `stow` is handled.

```bash
# Verify and install gitleaks if needed
if ! command -v gitleaks &> /dev/null; then
    print_info "gitleaks not found. Installing via Homebrew..."
    ensure_homebrew || exit 1
    brew install gitleaks
fi
```

### Step 2: Integrate `gitleaks` into `bin/setup-git-hooks.sh`

Modify the `install_pre_commit_hook` function in `bin/setup-git-hooks.sh` to include a new validation step that runs `gitleaks protect --staged --verbose`.

```bash
# ... in bin/setup-git-hooks.sh within install_pre_commit_hook ...

# 8. Run gitleaks to scan for secrets
echo
echo "Running gitleaks scan..."
if command -v gitleaks &> /dev/null; then
    if gitleaks protect --staged --verbose; then
        print_success "Gitleaks scan passed"
    else
        print_error "Gitleaks detected potential secrets in staged changes"
        validation_failed=true
    fi
else
    print_warning "gitleaks not available, skipping secret scanning"
fi
```

### Step 3: Run `bin/setup-git-hooks.sh install` to update the hook

Execute the setup script to re-generate and install the updated `pre-commit` hook.

### Step 4: Write a failing test (optional but good practice)

Create a temporary file with a simulated secret to verify that `gitleaks` correctly identifies it and prevents the commit.

```bash
# In a temporary file for testing
echo "MY_SECRET_KEY=supersecretkey" > temp_secret.txt
git add temp_secret.txt
# The next command should be blocked by the pre-commit hook
git commit -m "test: add secret"
```

### Step 5: Run test to verify it fails

Attempt to commit the temporary file with the secret.
Expected: `gitleaks` should detect the secret and the pre-commit hook should fail the commit.

### Task 4 - Step 6: Remove temporary secret and commit the changes

Remove `temp_secret.txt` and commit the `bin/setup.sh` and `bin/setup-git-hooks.sh` changes.

```bash
rm temp_secret.txt && \
git add . && \
git commit -m "ci(gitleaks): integrate gitleaks into pre-commit hooks"
```
