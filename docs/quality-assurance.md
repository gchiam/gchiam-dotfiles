# 🔍 Quality Assurance

This document outlines the quality assurance practices, linting standards,
and documentation requirements for the dotfiles repository.

## 🧹 Linting and Code Quality

Before committing changes, run appropriate linting tools:

### 📝 Markdown Files

```bash
markdownlint-cli2 docs/*.md README.md CLAUDE.md
```

### 🐚 Shell Scripts

```bash
shellcheck bin/*.sh stow/custom-bin/bin/*
```

### ⚙️ TOML Configuration

```bash
# For aerospace.toml and other TOML files
taplo fmt --check stow/aerospace/.config/aerospace/aerospace.toml
```

### 🔧 General File Checks

```bash
# Check for common issues
find . -name "*.sh" -exec shellcheck {} \;
find . -name "*.md" -exec markdownlint-cli2 {} \;
```

## 📚 Documentation Standards

- All documentation follows markdownlint rules (80 char line length,
  proper formatting)
- Scripts include `--help` flags with usage information
- Complex configurations have accompanying reference documents in `docs/`
- Use clear, descriptive commit messages following Conventional Emoji Commits

## 📄 File Standards

### 📝 Markdown Files Standards

- Maximum 80 characters per line
- Proper spacing around headings, lists, and code blocks
- Language specified for all fenced code blocks
- Single trailing newline at end of file

### 🐚 Shell Scripts Standards

- Include shebang (`#!/bin/bash`)
- Use proper quoting to prevent word splitting
- Include usage information with `--help` flag
- Add error handling for common failure cases
- Use shellcheck disable comments when intentional

### ⚙️ Configuration Files

- Follow the conventions of the specific tool
- Include comments explaining non-obvious settings
- Use consistent formatting and indentation
- Group related settings together

## 🧪 Testing Requirements

### 🆕 New Configurations

1. Test in a clean environment
2. Verify symlinks are created correctly
3. Test that the application can load the configuration
4. Check for conflicts with existing configurations

### 🔧 Script Changes

1. Test all code paths including error conditions
2. Verify help text is accurate and complete
3. Test with various input combinations
4. Ensure backward compatibility where possible

### 📚 Documentation Updates

1. Verify all links work correctly
2. Test any code examples provided
3. Ensure formatting renders correctly
4. Check that information is up-to-date

## 🔄 Continuous Improvement

- Regular reviews of linting rules and standards
- Updates to documentation as tools evolve
- Feedback incorporation from usage patterns
- Performance monitoring of complex configurations

## 🛡️ Security Checklist for Shell Scripts

- [ ] Enforce the use of `[[ ... ]]` over `[ ... ]`
      for safer evaluations.
- [ ] Implement mandatory input validation
  for all scripts accepting command-line arguments.
- [ ] Explore integration of local secret-scanning tools (e.g., `gitleaks`) into pre-commit hooks.
<!-- markdownlint-disable MD013 -->
- [ ] Ensure proper quoting of variables
  to prevent word splitting and glob expansion.
<!-- markdownlint-enable MD013 -->
- [ ] Avoid using `eval` with untrusted input.
- [ ] Sanitize or validate all external input (user input,
  environment variables, file contents).
- [ ] Use `set -euo pipefail` for robust script execution.
- [ ] Limit script privileges where possible (Principle of Least Privilege).
- [ ] Log sensitive actions, but avoid logging sensitive data.
- [ ] Regularly review scripts for potential security vulnerabilities.
