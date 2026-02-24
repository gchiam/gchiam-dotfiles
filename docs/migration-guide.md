# 📦 Migration Guide

This guide helps you upgrade between major changes in the dotfiles repository.

## 📖 Overview

The dotfiles repository evolves over time with new features, tool updates,
and structural changes. This guide provides step-by-step instructions for
migrating between major versions safely.

## 🔍 Before You Start

### 🛡️ Backup Your Current Setup

```bash
# Create a full backup
cp -r ~/.config ~/.config.backup.$(date +%Y%m%d)
cp -r ~/.zshrc ~/.zshrc.backup.$(date +%Y%m%d) 2>/dev/null || true
cp -r ~/.tmux.conf ~/.tmux.conf.backup.$(date +%Y%m%d) 2>/dev/null || true

# Create dotfiles backup
cp -r ~/.dotfiles ~/.dotfiles.backup.$(date +%Y%m%d) 2>/dev/null || true
```

### ✅ Check Compatibility

```bash
# Run compatibility check
./bin/check-compatibility.sh

# Generate compatibility report
./bin/check-compatibility.sh --report
```

### 🎥 Health Check

```bash
# Check current setup health
./bin/health-check.sh > health-before-migration.txt
```

## 🎯 Migration Scenarios

### 🎆 Scenario 1: Fresh Installation on New Machine

If you're setting up dotfiles on a completely new machine:

```bash
# Clone the repository
git clone https://github.com/gchiam/gchiam-dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# Check system compatibility
./bin/check-compatibility.sh

# Run interactive setup
./bin/setup-interactive.sh

# Apply your preferred profile
./bin/setup-profile.sh interactive

# Verify installation
./bin/health-check.sh
```

### 🔄 Scenario 2: Updating Existing Installation

If you have an existing dotfiles installation:

```bash
# Navigate to dotfiles directory
cd ~/.dotfiles

# Backup current state
./bin/setup-interactive.sh --dry-run > planned-changes.txt

# Pull latest changes
git pull origin main

# Check for breaking changes (see sections below)
# Run migration steps if needed

# Update installation
./bin/setup-interactive.sh --developer  # or your preferred profile

# Verify everything works
./bin/health-check.sh
```

### 🚀 Scenario 3: Major Version Upgrade

For major version upgrades with breaking changes:

```bash
# Backup everything
./bin/setup-interactive.sh --no-backup  # Skip if already backed up

# Check what's changed
git log --oneline --since="3 months ago"

# Review breaking changes (see version-specific sections)

# Clean install approach (safest)
cd ~/.dotfiles
./bin/setup-interactive.sh --full

# Or selective upgrade
./bin/setup-interactive.sh --custom

# Apply profile
./bin/setup-profile.sh apply [your-profile]

# Post-migration cleanup
# Remove old configurations if everything works
```

## 📅 Version-Specific Migrations

### 🗺️ Migration to Interactive Setup (v2.0+)

**What Changed:**

- New interactive setup system
- Profile-based configurations
- Enhanced backup functionality

**Migration Steps:**

1. **Update to new setup system:**

   ```bash
   # Old way (deprecated)
   ./bin/setup.sh

   # New way
   ./bin/setup-interactive.sh
   ```

2. **Configure profiles:**

   ```bash
   # Set up environment profile
   ./bin/setup-profile.sh list
   ./bin/setup-profile.sh apply personal  # or work
   ```

3. **Update shell configuration:**
   - Profile-specific settings now load from `~/.zshrc.local`
   - Check if you have custom settings to migrate

### 📦 Migration to Git LFS (v3.0+)

**What Changed:**

- Binary assets moved to Git LFS
- External dependencies prepared for submodules
- Repository size optimization

**Migration Steps:**

1. **Install Git LFS:**

   ```bash
   brew install git-lfs
   ```

2. **Run repository optimization:**

   ```bash
   ./bin/optimize-repo.sh --all
   ```

3. **Update working copy:**

   ```bash
   git pull origin main
   git lfs pull  # Download LFS assets
   ```

### 📚 Migration to Enhanced Documentation (v4.0+)

**What Changed:**

- Comprehensive troubleshooting guide
- Version compatibility checks
- Migration guides (this document)

**Migration Steps:**

1. **Update documentation references:**
   - Old troubleshooting: Check README
   - New troubleshooting: `docs/troubleshooting.md`

2. **Use new diagnostic tools:**

   ```bash
   # New compatibility checker
   ./bin/check-compatibility.sh

   # Enhanced health check
   ./bin/health-check.sh
   ```

## ⚠️ Breaking Changes

### 📂 Configuration File Locations

**Old Structure:**

```text
~/.zshrc (single file)
~/.tmux.conf (single file)
~/.gitconfig (single file)
```

**New Structure:**

```text
~/.config/zsh/.zshrc (modular)
~/.config/tmux/tmux.conf (modular)
~/.gitconfig + ~/.gitconfig.profile (profile support)
```

**Migration:**

Most changes are handled automatically by stow, but check for:

- Custom additions to old config files
- Profile-specific settings that need migration

### 🌍 Environment Variables

**Changed Variables:**

- `ZDOTDIR` now points to `~/.config/zsh`
- Profile-specific variables in `~/.zshrc.local`

**Migration:**

```bash
# Check for conflicting environment variables
env | grep -E "(ZDOTDIR|ZSH)"

# Remove old variables from ~/.zshenv if present
```

### 🔧 Tool-Specific Changes

#### 🐚 Zsh Configuration

**Old:** Single `.zshrc` file
**New:** Modular configuration in `~/.config/zsh/`

**Migration:**

```bash
# If you have custom ~/.zshrc additions
cp ~/.zshrc ~/.zshrc.custom.backup

# After new setup, add custom settings to:
# ~/.zshrc.local (profile-specific)
# ~/.config/zsh/local.zsh (general additions)
```

#### 🖥️ Tmux Configuration

**Old:** `~/.tmux.conf`
**New:** `~/.config/tmux/tmux.conf`

**Migration:**

```bash
# Backup custom tmux settings
if [[ -f ~/.tmux.conf.local ]]; then
    cp ~/.tmux.conf.local ~/.tmux.conf.local.backup
fi

# Custom settings go in ~/.config/tmux/local.conf after migration
```

### 🌳 Git Configuration

**Old:** Single `~/.gitconfig`
**New:** Main config + profile-specific configs

**Migration:**

```bash
# Your existing ~/.gitconfig will be preserved
# New profile system adds ~/.gitconfig.profile

# To use profiles:
./bin/setup-profile.sh apply work  # or personal
```

## ✅ Post-Migration Tasks

### ✓ Verify Installation

```bash
# Run comprehensive health check
./bin/health-check.sh

# Test key functionality
source ~/.zshrc
tmux new-session -d -s test
nvim --version
```

### 📚 Update Documentation

```bash
# Update README references if you've customized them
# Check for any personal documentation that needs updating
```

### 🧹 Clean Up Old Files

⚠️ **Only after verifying everything works correctly:**

```bash
# Remove old backup files (optional)
find ~ -name "*.backup.*" -mtime +30 -ls
# Manually remove if satisfied with new setup

# Clean up old configuration files (be careful!)
# Only remove if you're certain they're not needed
```

## 🐛 Troubleshooting Migration Issues

### ⚠️ Common Issues

#### 🔄 Stow Conflicts

```bash
# Error: "WARNING! stowing would cause conflicts"
# Solution: Remove conflicting files first
rm ~/.zshrc  # or move to backup
./bin/setup-interactive.sh
```

#### 🗺️ Profile Not Loading

```bash
# Check profile status
./bin/setup-profile.sh status

# Reapply profile
./bin/setup-profile.sh apply [profile-name]

# Check for syntax errors
zsh -n ~/.zshrc.local
```

#### 🔍 Missing Tools

```bash
# Check what's missing
./bin/health-check.sh

# Install missing tools
brew bundle install --file=~/.Brewfile
```

#### 🔒 Permission Issues

```bash
# Fix ownership
sudo chown -R $USER:$USER ~/.dotfiles ~/.config

# Fix permissions
chmod +x ~/.dotfiles/bin/*.sh
```

### 🔄 Recovery Procedures

#### ⚠️ Partial Migration Failure

```bash
# Restore from backup
cp -r ~/.config.backup.YYYYMMDD ~/.config

# Clean slate approach
cd ~/.dotfiles
./bin/setup-interactive.sh --full --no-backup
```

#### 🛡️ Complete Recovery

```bash
# Nuclear option: start fresh
rm -rf ~/.dotfiles
git clone https://github.com/gchiam/gchiam-dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./bin/setup-interactive.sh
```

## 🧪 Testing Your Migration

### ✅ Functionality Checklist

- [ ] Shell loads without errors
- [ ] Aliases and functions work
- [ ] Tmux starts and loads configuration
- [ ] Neovim opens and loads plugins
- [ ] Terminal emulator themes load correctly
- [ ] Git aliases and delta integration work
- [ ] Window manager (AeroSpace/yabai) works
- [ ] Profile-specific settings load
- [ ] Development tools function correctly

### 🚀 Performance Check

```bash
# Test shell startup time
time zsh -i -c exit

# Should be under 1 second for good performance
```

### 🔗 Integration Test

```bash
# Full workflow test
cd ~/projects/some-project
git status
nvim README.md
tmux new-session -d
# Test your typical workflow
```

## 🆘 Getting Help

### 🔍 Self-Diagnosis

```bash
# Run all diagnostic tools
./bin/check-compatibility.sh --report
./bin/health-check.sh > health-after-migration.txt
./bin/optimize-repo.sh --analyze
```

### 📚 Support Resources

1. **Troubleshooting Guide:** `docs/troubleshooting.md`
2. **Health Check:** `./bin/health-check.sh`
3. **Compatibility Check:** `./bin/check-compatibility.sh`
4. **Repository Issues:** GitHub issues for bug reports

### 📨 Reporting Migration Issues

When reporting migration problems, include:

```bash
# System information
./bin/check-compatibility.sh --system > system-info.txt

# Health check results
./bin/health-check.sh > health-check.txt

# Error messages
# Copy any error output from migration steps

# Migration context
echo "Migrating from: [previous version]" >> migration-context.txt
echo "Migrating to: $(git rev-parse HEAD)" >> migration-context.txt
echo "Migration method: [interactive/manual/etc]" >> migration-context.txt
```

## 🔮 Future Migrations

### 🔄 Staying Updated

```bash
# Set up update notifications (optional)
# Add to crontab or use Dependabot/Renovate

# Manual update check
cd ~/.dotfiles
git fetch origin
git log HEAD..origin/main --oneline
```

### 🏆 Migration Best Practices

1. **Always backup before migrating**
2. **Test compatibility first**
3. **Read migration notes carefully**
4. **Migrate during low-activity times**
5. **Verify functionality after migration**
6. **Keep backups until certain migration succeeded**

## ⏪ Rollback Procedures

### ⚡ Quick Rollback

```bash
# Restore from recent backup
cp -r ~/.config.backup.YYYYMMDD ~/.config
cp ~/.zshrc.backup.YYYYMMDD ~/.zshrc 2>/dev/null || true

# Restart shell
exec zsh
```

### 🛡️ Complete Rollback

```bash
# Restore dotfiles to previous version
cd ~/.dotfiles
git log --oneline  # Find commit to rollback to
git reset --hard [previous-commit-hash]

# Restore configurations
./bin/setup-interactive.sh
```

This migration guide will be updated with each major version to include
specific instructions for new changes and features.
