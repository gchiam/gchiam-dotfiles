# Development Notes

This document covers development practices, configuration management, and
architectural details for working with the dotfiles repository.

## Zsh Configuration Architecture

The zsh configuration has been completely modernized with a modular system:

- **Main config**: `.zshrc` loads all modules with safe sourcing
- **Environment detection**: Work/personal/remote/container environments
- **Performance optimization**: Lazy loading for NVM, SDKMAN, and heavy tools
- **Modular files**: `aliases.zsh`, `functions.zsh`, `completion.zsh`, etc.
- **XDG compliance**: All configs moved to `~/.config/zsh/`

## File Modifications

When modifying configurations:

1. Edit files in their respective `stow/` directories
2. Changes are immediately reflected via symlinks
3. For new configurations, add a new directory under `stow/`
4. Run linting tools before committing (see Quality Assurance section)

## Configuration Guidelines

### Adding New Tools

1. Create a new directory under `stow/` for the tool
2. Place configuration files in their expected relative paths
3. Update the main Brewfile if the tool needs to be installed
4. Document any special setup requirements

### Modifying Existing Configurations

1. Always test changes in a safe environment first
2. Use the appropriate linting tools for the file type
3. Update documentation if the changes affect user workflows
4. Follow the established commit message conventions

### Environment-Specific Configurations

The zsh system supports different environments:

- **Work environment**: Detected via `$ZENDESK_ENV` or username patterns
- **Remote environment**: Detected via SSH connection variables
- **Container environment**: Detected via Docker/Kubernetes indicators
- **Minimal mode**: Automatically enabled for remote/container environments

## Testing and Validation

Before committing changes:

1. **Test configurations in a clean environment**

   ```bash
   # Create a test environment
   docker run -it --rm -v ~/.dotfiles:/dotfiles ubuntu:latest bash
   # Or use a separate user account on macOS
   ```

2. **Run appropriate linting tools**

   ```bash
   # Shell scripts
   shellcheck bin/*.sh
   
   # Markdown documentation
   markdownlint-cli2 docs/*.md
   
   # YAML configurations
   yamllint stow/*/config.yml
   
   # JSON configurations
   jq empty stow/*/*.json
   ```

3. **Verify symlinks are created correctly**

   ```bash
   # Check stow operations
   stow -n -d stow -t ~ <directory>  # Dry run first
   ls -la ~/<expected-symlink>       # Verify after stowing
   ```

4. **Test application configurations**

   ```bash
   # Test zsh configuration
   zsh -n ~/.zshrc                   # Syntax check
   zsh -c "source ~/.zshrc; echo OK" # Load test
   
   # Test tmux configuration
   tmux -f ~/.tmux.conf new-session -d -s test
   tmux has-session -t test && echo "tmux config OK"
   tmux kill-session -t test
   
   # Test Neovim configuration
   nvim --headless -c "checkhealth" -c "qa"
   ```

5. **Check for breaking changes**

   ```bash
   # Run health check after changes
   ./bin/health-check.sh all
   
   # Check compatibility
   ./bin/check-compatibility.sh --report
   
   # Verify package dependencies
   brew bundle check --file=~/.Brewfile
   ```

## Debugging and Troubleshooting

### Performance Profiling

```bash
# Profile zsh startup time
time zsh -i -c exit

# Enable zsh profiling
echo 'zmodload zsh/zprof' >> ~/.zshrc.local
# Restart shell, then run: zprof

# Monitor file system activity
sudo fs_usage -w -f filesystem | grep -E "(zsh|tmux|nvim)"
```

### Configuration Validation

```bash
# Validate JSON configurations
find stow -name "*.json" -exec jq empty {} \;

# Validate YAML configurations
find stow -name "*.yml" -o -name "*.yaml" | xargs yamllint

# Check for common issues
./bin/health-check.sh --verbose
```

### Environment Debugging

```bash
# Debug environment detection
echo "Work env: $ZENDESK_ENV"
echo "Remote: $SSH_CONNECTION"
echo "Container: $container"

# Debug path and loading
echo $PATH | tr ':' '\n'
echo $FPATH | tr ':' '\n'
which -a <command>
```

## Advanced Development Patterns

### Custom Script Development

When creating new scripts in `bin/`:

```bash
#!/opt/homebrew/bin/bash
set -euo pipefail  # Strict error handling

# Color definitions (only if terminal supports them)
if [[ -t 1 ]] && command -v tput &> /dev/null && [[ $(tput colors 2>/dev/null || echo 0) -ge 8 ]]; then
    RED='\033[0;31m'
    GREEN='\033[0;32m'
    YELLOW='\033[1;33m'
    BLUE='\033[0;34m'
    NC='\033[0m'
else
    RED='' GREEN='' YELLOW='' BLUE='' NC=''
fi

# Always include help
show_help() {
    cat << EOF
Script Name - Brief description

Usage: $0 [options] [arguments]

Options:
    -h, --help          Show this help message
    -v, --verbose       Enable verbose output
    -n, --dry-run       Show what would be done
    
Examples:
    $0 --dry-run        Preview changes
    $0 --verbose        Run with detailed output
EOF
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_help
            exit 0
            ;;
        -v|--verbose)
            VERBOSE=1
            shift
            ;;
        -n|--dry-run)
            DRY_RUN=1
            shift
            ;;
        *)
            echo "Unknown option: $1" >&2
            show_help
            exit 1
            ;;
    esac
done
```

### Configuration Templates

For new tool configurations in `stow/`:

1. **Create directory structure**:

   ```bash
   mkdir -p stow/new-tool/.config/new-tool
   ```

2. **Follow XDG Base Directory Specification**:
   - Config: `~/.config/tool/`
   - Data: `~/.local/share/tool/`
   - Cache: `~/.cache/tool/`
   - State: `~/.local/state/tool/`

3. **Include tool in package management**:

   ```bash
   echo 'brew "new-tool"' >> ~/.Brewfile
   ```

4. **Add to setup scripts if needed**:

   ```bash
   # In setup-stow.sh or similar
   stow -d stow -t ~ new-tool
   ```

### Plugin and Extension Development

For Raycast extensions or similar:

```bash
# Navigate to extensions directory
cd raycast/extension-name

# Install dependencies
npm install

# Development with hot reload
npm run dev

# Build for production
npm run build

# Validate extension
raycast build --validate
```

## Integration Patterns

### Runtime Environment Configurations

```bash
# In zsh configuration
if [[ -n "$ZENDESK_ENV" || "$USER" =~ ^(gchiam|graham) ]]; then
    # Work-specific configurations
    source ~/.config/zsh/work.zsh
    export HOMEBREW_BUNDLE_FILE="$HOME/.Brewfile.zendesk"
fi

# Remote/minimal environment
if [[ -n "$SSH_CONNECTION" || -n "$container" ]]; then
    # Lightweight configuration for remote environments
    export DOTFILES_MINIMAL=1
fi
```

### Conditional Loading

```bash
# Load tools only if available
command -v fzf >/dev/null && source ~/.config/fzf/fzf.zsh
[[ -f ~/.config/tool/config ]] && source ~/.config/tool/config

# Lazy loading for performance
lazy_load_nvm() {
    unset -f nvm node npm
    export NVM_DIR="$HOME/.nvm"
    [[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"
}
alias nvm=lazy_load_nvm
alias node=lazy_load_nvm
alias npm=lazy_load_nvm
```
