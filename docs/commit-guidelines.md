# 📝 Git Commit Guidelines

This repository follows the
[Conventional Emoji Commits](https://conventional-emoji-commits.site/)
convention for commit messages.

## 📋 Commit Format

```text
<emoji> <type>(<scope>): <description>

[optional body]

[optional footer(s)]
```

## 🎨 Common Types and Emojis

- `✨ feat(<scope>):` - New features
- `🐛 fix(<scope>):` - Bug fixes
- `📝 docs(<scope>):` - Documentation changes
- `💄 style(<scope>):` - Code style changes (formatting, etc.)
- `♻️ refactor(<scope>):` - Code refactoring
- `⚡ perf(<scope>):` - Performance improvements
- `✅ test(<scope>):` - Adding or updating tests
- `🔧 chore(<scope>):` - Maintenance tasks
- `🚀 ci(<scope>):` - CI/CD changes
- `🔥 remove(<scope>):` - Removing code or files
- `🎨 improve(<scope>):` - General improvements
- `🔒 security(<scope>):` - Security fixes

## 🎯 Common Scopes

- `zsh` - Zsh shell configuration
- `nvim` - Neovim editor configuration
- `tmux` - Tmux terminal multiplexer
- `git` - Git configuration
- `brew` - Homebrew package management
- `aerospace` - AeroSpace window manager
- `karabiner` - Karabiner keyboard customization
- `raycast` - Raycast launcher and extensions
- `alacritty` - Alacritty terminal
- `bin` - Utility scripts
- `docs` - Documentation files

## 💡 Examples

```bash
✨ feat(zsh): add modular configuration system with custom functions
🐛 fix(ssh): resolve SSH config overwrite vulnerability
📝 docs(readme): update README with comprehensive setup guide  
♻️ refactor(nvim): reorganize plugin configuration structure
🔧 chore(brew): update package dependencies to latest versions
🔒 security(ssh): fix SSH agent management to prevent multiple agents
⚡ perf(zsh): implement lazy loading for NVM and development tools
🎨 improve(bin): enhance scripts with better error handling
```

## ✨ Best Practices

### 📝 Commit Message Guidelines

1. **Use present tense**: "Add feature" not "Added feature"
2. **Be descriptive**: Explain what and why, not just what
3. **Keep first line under 50 characters** when possible
4. **Use body for detailed explanations** when necessary
5. **Reference issues and PRs** when applicable

### 🎯 Scope Guidelines

1. **Use specific scopes**: Prefer `tmux` over `config`
2. **Be consistent**: Use the same scope for related changes
3. **Omit scope if change affects multiple areas**: Use general type only
4. **New scopes**: Add to the list above when introducing new components

### 🏷️ Type Selection

1. **feat**: Only for new functionality visible to users
2. **fix**: For bug fixes that resolve issues
3. **docs**: For documentation-only changes
4. **refactor**: For code changes that don't fix bugs or add features
5. **chore**: For maintenance tasks like dependency updates

## 🧹 Commit Hygiene

### ✅ Before Committing

1. **Run linting tools** to ensure code quality
2. **Test changes** in appropriate environments
3. **Update documentation** if functionality changes
4. **Check file permissions** and executable flags
5. **Review staged changes** to ensure intentionality

### ⏰ Commit Frequency

- **Commit often**: Small, focused commits are preferred
- **Logical grouping**: Related changes should be in the same commit
- **Atomic commits**: Each commit should represent one logical change
- **Avoid mixing concerns**: Don't combine refactoring with new features

### 🚨 Special Cases

#### 💥 Breaking Changes

For breaking changes, include `BREAKING CHANGE:` in the footer:

```text
♻️ refactor(zsh): restructure configuration file locations

BREAKING CHANGE: Configuration files moved from ~/.zshrc to ~/.config/zsh/
```

#### 🤝 Co-authored Commits

When working with Claude Code, include co-author information:

```text
🤖 Generated with [Claude Code](https://claude.ai/code)

Co-Authored-By: Claude <noreply@anthropic.com>
```
