# Troubleshooting Guide

This guide covers common issues and solutions when setting up and using the dotfiles.

## Setup Issues

### Stow Command Not Found

**Problem**: `stow: command not found` when running setup scripts.

**Solution**:
```bash
# Install via Homebrew
brew install stow

# Or install manually
sudo apt-get install stow  # Ubuntu/Debian
sudo yum install stow      # CentOS/RHEL
```

### Permission Denied Errors

**Problem**: Permission denied when creating symlinks or running scripts.

**Solutions**:
```bash
# Make scripts executable
chmod +x bin/*.sh

# Fix ownership if needed
sudo chown -R $USER:$USER ~/.dotfiles

# For macOS, grant Terminal full disk access in System Preferences
```

### Stow Conflicts

**Problem**: `stow: WARNING! stowing ... would cause conflicts`

**Solutions**:
```bash
# Remove conflicting files/directories first
rm ~/.zshrc  # or move to backup

# Use --adopt flag to adopt existing files
stow --adopt -d stow -t ~ zsh

# Force restow (overwrites existing)
stow -R -d stow -t ~ zsh
```

### Homebrew Installation Fails

**Problem**: Brew bundle fails or packages can't be installed.

**Solutions**:
```bash
# Update Homebrew first
brew update && brew upgrade

# Install packages individually to identify issues
brew install $(grep "^brew" ~/.Brewfile | cut -d"'" -f2)

# Skip problematic packages temporarily
brew bundle --file=~/.Brewfile --no-upgrade
```

## Shell Issues

### Zsh Not Loading Configurations

**Problem**: Zsh starts but custom configurations don't load.

**Diagnostic**:
```bash
# Check if .zshrc exists and is linked correctly
ls -la ~/.zshrc

# Test configuration loading
zsh -n ~/.zshrc  # Check syntax
zsh -x ~/.zshrc  # Debug loading (verbose)
```

**Solutions**:
- Ensure antidote is installed: `brew install antidote`
- Reload shell: `exec zsh` or restart terminal
- Check for syntax errors in configuration files

### Slow Shell Startup

**Problem**: Zsh takes a long time to start.

**Diagnostic**:
```bash
# Profile startup time
time zsh -i -c exit

# Use zprof for detailed profiling
echo 'zmodload zsh/zprof' >> ~/.zshrc.local
# Restart shell, then run: zprof
```

**Solutions**:
- Disable unused plugins in antidote configuration
- Use lazy loading for heavy plugins
- Move expensive operations to background jobs

### Plugin Installation Fails

**Problem**: Antidote plugins fail to install or load.

**Solutions**:
```bash
# Update antidote
brew upgrade antidote

# Clear plugin cache
rm -rf ~/.cache/antidote

# Reinstall plugins
antidote bundle < ~/.config/antidote/.zsh_plugins.txt > ~/.config/antidote/.zsh_plugins.zsh
```

## Terminal Issues

### Colors Not Working

**Problem**: Colors don't display correctly in terminal.

**Solutions**:
```bash
# Test true color support
curl -s https://raw.githubusercontent.com/JohnMorales/dotfiles/master/colors/24-bit-color.sh | bash

# For tmux, ensure TERM is set correctly
echo $TERM  # Should be tmux-256color or similar

# Install custom terminfo if needed
tic ~/.dotfiles/terminfo/tmux-256color.terminfo
```

### Font Issues

**Problem**: Powerline symbols or icons don't display correctly.

**Solutions**:
- Install a Nerd Font: `brew install --cask font-fira-code-nerd-font`
- Configure terminal to use the Nerd Font
- For Alacritty: Check `font.normal.family` in config
- For Kitty: Check `font_family` setting

### Terminal Emulator Won't Start

**Problem**: Alacritty, Kitty, or WezTerm fails to launch.

**Solutions**:
```bash
# Check configuration syntax
alacritty --print-events  # Test Alacritty config
kitty --debug-config      # Test Kitty config

# Reset to default config temporarily
mv ~/.config/alacritty ~/.config/alacritty.backup
alacritty  # Should work with defaults

# Check logs
# Alacritty: ~/Library/Logs/alacritty.log (macOS)
# Kitty: Run with `kitty --debug-keyboard`
```

## Development Tool Issues

### Neovim Configuration Errors

**Problem**: Neovim fails to start or shows errors.

**Solutions**:
```bash
# Check for Lua syntax errors
nvim --headless -c 'lua print("Config OK")' -c 'qa'

# Reset LazyVim if needed
rm -rf ~/.local/share/nvim
rm -rf ~/.local/state/nvim
rm -rf ~/.cache/nvim

# Start with minimal config
nvim --clean
```

### Git Configuration Issues

**Problem**: Git aliases or delta integration not working.

**Solutions**:
```bash
# Verify git config
git config --list | grep -E "(alias|delta)"

# Test delta manually
echo "test" | git diff --no-index /dev/null - | delta

# Reinstall delta if needed
brew reinstall git-delta
```

### tmux Plugin Issues

**Problem**: tmux plugins don't load or TPM fails.

**Solutions**:
```bash
# Ensure TPM is installed
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Install/update plugins
tmux new-session -d 'tmux run-shell ~/.tmux/plugins/tpm/scripts/install_plugins.sh'

# Reload tmux config
tmux source-file ~/.tmux.conf
```

## macOS Specific Issues

### AeroSpace Configuration

**Problem**: AeroSpace window manager not working.

**Solutions**:
```bash
# Check if AeroSpace is running
ps aux | grep -i aerospace

# Verify configuration
aerospace --check-config

# Restart AeroSpace
aerospace --restart-config
```

### Karabiner-Elements Issues

**Problem**: Keyboard modifications not working.

**Solutions**:
- Ensure Karabiner-Elements has necessary permissions in System Preferences
- Check configuration: `~/.config/karabiner/karabiner.json`
- Restart Karabiner-Elements from menu bar

### macOS Gatekeeper Issues

**Problem**: "App can't be opened because it is from an unidentified developer"

**Solutions**:
```bash
# Remove quarantine attribute
xattr -r -d com.apple.quarantine /path/to/app

# Allow unsigned applications (use with caution)
sudo spctl --master-disable
```

## Performance Issues

### High CPU Usage

**Problem**: Terminal or shell using excessive CPU.

**Diagnostic**:
```bash
# Check running processes
top -o cpu

# Profile shell startup
zsh -i -c 'zprof'

# Monitor file system activity
fs_usage -w -f filesystem | grep -E "(zsh|tmux|nvim)"
```

**Solutions**:
- Disable resource-intensive plugins
- Reduce prompt complexity
- Use `lazy` loading for plugins

### High Memory Usage

**Problem**: Applications using too much memory.

**Solutions**:
- Restart terminal sessions periodically
- Reduce tmux scrollback buffer size
- Close unused Neovim buffers
- Clear shell history if extremely large

## Recovery Options

### Reset Individual Tools

```bash
# Reset Zsh
mv ~/.zshrc ~/.zshrc.backup
mv ~/.config/zsh ~/.config/zsh.backup

# Reset Neovim
rm -rf ~/.config/nvim ~/.local/share/nvim ~/.cache/nvim

# Reset tmux
mv ~/.tmux.conf ~/.tmux.conf.backup
mv ~/.tmux ~/.tmux.backup
```

### Complete Reset

```bash
# Remove all dotfiles (CAUTION: This removes all configurations)
cd ~
stow -D -d ~/.dotfiles/stow -t ~ */
rm -rf ~/.dotfiles

# Restore from backup if available
if [[ -d ~/.dotfiles-backup-* ]]; then
    echo "Backup directories found:"
    ls -la ~/.dotfiles-backup-*
fi
```

## Getting Help

### Health Check

Always start troubleshooting with the health check:
```bash
~/.dotfiles/bin/health-check.sh
```

### Debug Mode

Run setup scripts with debug output:
```bash
bash -x ~/.dotfiles/bin/setup.sh
```

### Log Files

Check these locations for error logs:
- Shell: `~/.zsh_history`, `~/.bash_history`
- tmux: `~/.tmux.log` (if logging enabled)
- Neovim: `:messages` command, `~/.cache/nvim/`
- Terminal emulators: Usually in `~/Library/Logs/` (macOS)

### Community Support

1. Check existing issues in the repository
2. Search for similar problems in dotfiles communities
3. Create an issue with:
   - Output of `health-check.sh`
   - Error messages
   - System information (`uname -a`, macOS version)
   - Steps to reproduce

## Prevention

### Regular Maintenance

```bash
# Update packages regularly
brew update && brew upgrade
brew bundle dump --describe --force  # Update Brewfile

# Clean up old files
brew cleanup
tmux kill-server  # Restart tmux occasionally

# Validate configurations
~/.dotfiles/bin/health-check.sh
```

### Backup Strategy

```bash
# Create regular backups before updates
cp -r ~/.config ~/.config.backup.$(date +%Y%m%d)

# Use the interactive setup for major changes
~/.dotfiles/bin/setup-interactive.sh --dry-run
```