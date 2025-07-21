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

1. Test configurations in a clean environment
2. Run appropriate linting tools
3. Verify symlinks are created correctly
4. Test that applications can load the configurations
5. Check for any breaking changes in dependencies
