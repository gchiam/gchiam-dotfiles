#!/bin/bash
set -e

# Git Hooks Setup Script
# Installs and configures validation hooks for the dotfiles repository

# Colors (only if terminal supports them)
if [[ -t 1 ]] && command -v tput &> /dev/null && [[ $(tput colors 2>/dev/null || echo 0) -ge 8 ]]; then
    RED='\033[0;31m'
    GREEN='\033[0;32m'
    YELLOW='\033[1;33m'
    BLUE='\033[0;34m'
    CYAN='\033[0;36m'
    NC='\033[0m'
else
    RED=''
    GREEN=''
    YELLOW=''
    BLUE=''
    CYAN=''
    NC=''
fi

print_header() {
    echo -e "\n${BLUE}=== $1 ===${NC}"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_info() {
    echo -e "${CYAN}ℹ${NC} $1"
}

# Get repository root
REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
HOOKS_DIR="$REPO_ROOT/.git/hooks"

# Check if we're in a git repository
check_git_repo() {
    print_header "Checking Repository"
    
    if ! git rev-parse --git-dir &> /dev/null; then
        print_error "Not in a git repository"
        exit 1
    fi
    
    print_success "Git repository detected"
    print_info "Repository: $REPO_ROOT"
    print_info "Hooks directory: $HOOKS_DIR"
}

# Install pre-commit hook
install_pre_commit_hook() {
    print_header "Installing Pre-Commit Hook"
    
    local hook_file="$HOOKS_DIR/pre-commit"
    
    cat > "$hook_file" << 'EOF'
#!/bin/bash

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

print_success() { echo -e "${GREEN}✓${NC} $1"; }
print_warning() { echo -e "${YELLOW}⚠${NC} $1"; }
print_error() { echo -e "${RED}✗${NC} $1"; }
print_info() { echo -e "${CYAN}ℹ${NC} $1"; }

echo -e "${BLUE}Pre-commit validation${NC}"
echo "===================="

# Get list of staged files
staged_files=$(git diff --cached --name-only)

if [[ -z "$staged_files" ]]; then
    print_info "No files staged for commit"
    exit 0
fi

echo "Staged files:"
echo "$staged_files" | sed 's/^/  /'
echo

# Validation flags
validation_failed=false

# 1. Validate shell scripts
echo "Validating shell scripts..."
shell_scripts=$(echo "$staged_files" | grep -E '\.(sh|zsh|bash)$' || true)

if [[ -n "$shell_scripts" ]]; then
    while IFS= read -r script; do
        if [[ -f "$script" ]]; then
            # Check syntax
            if bash -n "$script" 2>/dev/null; then
                print_success "$script syntax OK"
            else
                print_error "$script has syntax errors"
                validation_failed=true
            fi
            
            # Check for shellcheck if available
            if command -v shellcheck &> /dev/null; then
                if shellcheck -x --severity=warning "$script" 2>/dev/null; then
                    print_success "$script passed shellcheck"
                else
                    print_warning "$script has shellcheck warnings"
                fi
            fi
        fi
    done <<< "$shell_scripts"
else
    print_info "No shell scripts to validate"
fi

# 2. Validate markdown files
echo
echo "Validating markdown files..."
markdown_files=$(echo "$staged_files" | grep -E '\.md$' || true)

if [[ -n "$markdown_files" ]]; then
    if command -v markdownlint-cli2 &> /dev/null; then
        while IFS= read -r md_file; do
            if [[ -f "$md_file" ]]; then
                if markdownlint-cli2 "$md_file" 2>/dev/null; then
                    print_success "$md_file passed markdown lint"
                else
                    print_error "$md_file has markdown lint issues"
                    validation_failed=true
                fi
            fi
        done <<< "$markdown_files"
    else
        print_warning "markdownlint-cli2 not available, skipping markdown validation"
    fi
else
    print_info "No markdown files to validate"
fi

# 3. Validate JSON files
echo
echo "Validating JSON files..."
json_files=$(echo "$staged_files" | grep -E '\.(json|jsonc)$' || true)

if [[ -n "$json_files" ]]; then
    while IFS= read -r json_file; do
        if [[ -f "$json_file" ]]; then
            # Handle JSONC files (JSON with comments)
            if [[ "$json_file" == *.jsonc ]]; then
                if command -v jq &> /dev/null; then
                    if jq -r '.' "$json_file" > /dev/null 2>&1; then
                        print_success "$json_file is valid JSONC"
                    else
                        print_error "$json_file has invalid JSONC syntax"
                        validation_failed=true
                    fi
                else
                    print_warning "jq not available, skipping JSONC validation for $json_file"
                fi
            else
                if python3 -m json.tool "$json_file" > /dev/null 2>&1; then
                    print_success "$json_file is valid JSON"
                else
                    print_error "$json_file has invalid JSON syntax"
                    validation_failed=true
                fi
            fi
        fi
    done <<< "$json_files"
else
    print_info "No JSON files to validate"
fi

# 4. Check for sensitive files
echo
echo "Checking for sensitive files..."
sensitive_patterns=(
    "\.env$"
    "\.env\."
    "id_rsa$"
    "id_ed25519$"
    "\.pem$"
    "\.key$"
    "\.p12$"
    "\.pfx$"
    "password"
    "secret"
    "token"
)

for pattern in "${sensitive_patterns[@]}"; do
    matches=$(echo "$staged_files" | grep -iE "$pattern" || true)
    if [[ -n "$matches" ]]; then
        print_warning "Potentially sensitive files detected:"
        echo "$matches" | sed 's/^/  /'
        
        echo
        read -p "Are you sure you want to commit these files? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            print_error "Commit cancelled due to sensitive files"
            exit 1
        fi
    fi
done

# 5. Validate configuration files
echo
echo "Validating configuration files..."

# Check tmux configuration
tmux_configs=$(echo "$staged_files" | grep -E '\.tmux\.conf$|tmux\.conf$' || true)
if [[ -n "$tmux_configs" ]]; then
    while IFS= read -r tmux_file; do
        if [[ -f "$tmux_file" ]]; then
            if tmux -f "$tmux_file" list-keys > /dev/null 2>&1; then
                print_success "$tmux_file tmux config is valid"
            else
                print_error "$tmux_file has invalid tmux syntax"
                validation_failed=true
            fi
        fi
    done <<< "$tmux_configs"
fi

# Check git configuration
git_configs=$(echo "$staged_files" | grep -E '\.gitconfig$|\.gitignore' || true)
if [[ -n "$git_configs" ]]; then
    print_info "Git configuration files detected - manual review recommended"
fi

# 6. Check file sizes
echo
echo "Checking file sizes..."
large_files=$(echo "$staged_files" | while IFS= read -r file; do
    if [[ -f "$file" ]]; then
        size=$(stat -f%z "$file" 2>/dev/null || echo 0)
        if [[ $size -gt 1048576 ]]; then  # 1MB
            echo "$file ($(( size / 1024 ))KB)"
        fi
    fi
done)

if [[ -n "$large_files" ]]; then
    print_warning "Large files detected:"
    echo "$large_files" | sed 's/^/  /'
    print_info "Consider using Git LFS for binary assets"
fi

# 7. Validate Lua files (for Neovim config)
lua_files=$(echo "$staged_files" | grep -E '\.lua$' || true)
if [[ -n "$lua_files" ]] && command -v lua &> /dev/null; then
    echo
    echo "Validating Lua files..."
    while IFS= read -r lua_file; do
        if [[ -f "$lua_file" ]]; then
            if lua -l "$lua_file" -e "" 2>/dev/null; then
                print_success "$lua_file Lua syntax OK"
            else
                print_error "$lua_file has Lua syntax errors"
                validation_failed=true
            fi
        fi
    done <<< "$lua_files"
fi

# Final result
echo
if [[ "$validation_failed" == true ]]; then
    print_error "Pre-commit validation failed"
    print_info "Fix the issues above and try again"
    exit 1
else
    print_success "All validations passed"
    print_info "Proceeding with commit"
fi
EOF

    chmod +x "$hook_file"
    print_success "Pre-commit hook installed"
}

# Install commit-msg hook
install_commit_msg_hook() {
    print_header "Installing Commit Message Hook"
    
    local hook_file="$HOOKS_DIR/commit-msg"
    
cat > "$hook_file" << 'EOF'
#!/bin/bash
# Commit message validation hook

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_success() { echo -e "${GREEN}✓${NC} $1"; }
print_warning() { echo -e "${YELLOW}⚠${NC} $1"; }
print_error() { echo -e "${RED}✗${NC} $1"; }

commit_msg_file="$1"
commit_msg=$(cat "$commit_msg_file")

echo "Validating commit message..."

# Skip validation for merge commits
if [[ "$commit_msg" =~ ^Merge ]]; then
    print_success "Merge commit detected, skipping validation"
    exit 0
fi

# Skip validation for revert commits
if [[ "$commit_msg" =~ ^Revert ]]; then
    print_success "Revert commit detected, skipping validation"
    exit 0
fi

# Check for conventional commit format (with emoji)
emoji_pattern="^[🎉✨🐛📚🔧⚡🎨♻️🔥💚👷📝⬆️🔖🚨🌐💄🍱♿💬🗃️🔊🔇📱🏗️⚙️🔩💫🗑️🚑️💥🔒️🔐📦️🏷️🔀📄⚗️🏁🩹🧐⚰️🧪👔💡🍻💬🔍️⚡️🚚🔧🔨][[:space:]]*(feat|fix|docs|style|refactor|perf|test|build|ci|chore|revert)(\(.+\))?: .+"
if [[ "$commit_msg" =~ $emoji_pattern ]]; then
    print_success "Commit message follows conventional emoji format"
    exit 0
fi

# Check for conventional commit format (without emoji)
conventional_pattern="^(feat|fix|docs|style|refactor|perf|test|build|ci|chore|revert)(\(.+\))?: .+"
if [[ "$commit_msg" =~ $conventional_pattern ]]; then
    print_success "Commit message follows conventional format"
    exit 0
fi

# Validate basic requirements
validation_failed=false

# Check minimum length
if [[ ${#commit_msg} -lt 10 ]]; then
    print_error "Commit message too short (minimum 10 characters)"
    validation_failed=true
fi

# Check maximum line length for first line
first_line=$(echo "$commit_msg" | head -n1)
if [[ ${#first_line} -gt 72 ]]; then
    print_warning "First line is longer than 72 characters (${#first_line})"
fi

# Check for imperative mood indicators
if [[ "$first_line" =~ (ed|ing)$ ]]; then
    print_warning "Use imperative mood (e.g., 'Add' not 'Added' or 'Adding')"
fi

# Check for proper capitalization
if [[ ! "$first_line" =~ ^[A-Z🎉✨🐛📚🔧⚡🎨♻️🔥💚👷📝⬆️🔖🚨🌐💄🍱♿💬🗃️🔊🔇📱🏗️⚙️🔩💫🗑️🚑️💥🔒️🔐📦️🏷️🔀📄⚗️🏁🩹🧐⚰️🧪👔💡🍻💬🔍️⚡️🚚🔧🔨] ]]; then
    print_warning "First line should start with a capital letter or emoji"
fi

# Check for period at end of first line
if [[ "$first_line" =~ \.$ ]]; then
    print_warning "Don't end the first line with a period"
fi

if [[ "$validation_failed" == true ]]; then
    echo
    print_error "Commit message validation failed"
    echo
    echo "Expected format examples:"
    echo "  🎉 feat: add new user authentication system"
    echo "  🐛 fix(api): resolve null pointer exception in user service"
    echo "  📚 docs: update installation guide"
    echo "  🔧 chore: update dependencies"
    echo
    echo "Your message:"
    echo "$commit_msg"
    exit 1
else
    print_success "Commit message is acceptable"
fi
EOF

    chmod +x "$hook_file"
    print_success "Commit message hook installed"
}

# Install prepare-commit-msg hook
install_prepare_commit_msg_hook() {
    print_header "Installing Prepare Commit Message Hook"
    
    local hook_file="$HOOKS_DIR/prepare-commit-msg"
    
cat > "$hook_file" << 'EOF'
#!/bin/bash
# Prepare commit message hook

commit_msg_file="$1"
commit_source="$2"
commit_sha="$3"

# Only modify the message for regular commits (not merge, squash, etc.)
if [[ "$commit_source" == "message" ]] || [[ "$commit_source" == "template" ]] || [[ -z "$commit_source" ]]; then
    # Add helpful template if message is empty or default
    if [[ ! -s "$commit_msg_file" ]] || grep -q "^# Please enter the commit message" "$commit_msg_file"; then
        cat > "$commit_msg_file" << 'TEMPLATE'
# Commit message template
# 
# Format: <emoji> <type>(<scope>): <description>
#
# Types:
#   🎉 feat:     A new feature
#   🐛 fix:      A bug fix
#   📚 docs:     Documentation only changes
#   🎨 style:    Changes that do not affect the meaning of the code
#   ♻️  refactor: A code change that neither fixes a bug nor adds a feature
#   ⚡ perf:     A code change that improves performance
#   🧪 test:     Adding missing tests or correcting existing tests
#   🏗️  build:    Changes that affect the build system or external dependencies
#   👷 ci:       Changes to our CI configuration files and scripts
#   🔧 chore:    Other changes that don't modify src or test files
#   🔥 remove:   Remove code or files
#   🚑️ hotfix:   Critical hotfix
#
# Examples:
#   🎉 feat(auth): add OAuth2 integration
#   🐛 fix(api): resolve timeout issue in user endpoint
#   📚 docs: update README with new installation steps
#   🔧 chore: update dependencies to latest versions

TEMPLATE
    fi
fi

# Add branch name to commit message if on feature branch
current_branch=$(git symbolic-ref --short HEAD 2>/dev/null || echo "")

if [[ -n "$current_branch" ]] && [[ "$current_branch" != "main" ]] && [[ "$current_branch" != "master" ]]; then
    # Check if branch name is not already in the commit message
    if ! grep -q "$current_branch" "$commit_msg_file"; then
        # Add branch info to the commit message
        temp_file=$(mktemp)
        echo "# Branch: $current_branch" > "$temp_file"
        cat "$commit_msg_file" >> "$temp_file"
        mv "$temp_file" "$commit_msg_file"
    fi
fi
EOF

    chmod +x "$hook_file"
    print_success "Prepare commit message hook installed"
}

# Install post-commit hook
install_post_commit_hook() {
    print_header "Installing Post-Commit Hook"
    
    local hook_file="$HOOKS_DIR/post-commit"
    
cat > "$hook_file" << 'EOF'
#!/bin/bash
# Post-commit hook for additional actions

# Colors
GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m'

print_success() { echo -e "${GREEN}✓${NC} $1"; }
print_info() { echo -e "${CYAN}ℹ${NC} $1"; }

echo
print_success "Commit completed successfully!"

# Get commit info
commit_hash=$(git rev-parse --short HEAD)
commit_msg=$(git log -1 --pretty=%s)

print_info "Commit: $commit_hash"
print_info "Message: $commit_msg"

# Run health check if available (in background to avoid slowing down commits)
repo_root=$(git rev-parse --show-toplevel)
if [[ -x "$repo_root/bin/health-check.sh" ]]; then
    print_info "Running health check in background..."
    nohup "$repo_root/bin/health-check.sh" --quiet > /dev/null 2>&1 &
fi

# Check if auto-sync is set up and suggest running it
if [[ -x "$repo_root/bin/auto-sync.sh" ]]; then
    sync_status=$("$repo_root/bin/auto-sync.sh" status 2>/dev/null | grep "Next sync" || echo "")
    if [[ -n "$sync_status" ]]; then
        print_info "$sync_status"
    fi
fi

print_info "Use 'git push' to share your changes"
EOF

    chmod +x "$hook_file"
    print_success "Post-commit hook installed"
}

# Install pre-push hook
install_pre_push_hook() {
    print_header "Installing Pre-Push Hook"
    
    local hook_file="$HOOKS_DIR/pre-push"
    
cat > "$hook_file" << 'EOF'
#!/bin/bash
# Pre-push hook for additional validation

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_success() { echo -e "${GREEN}✓${NC} $1"; }
print_warning() { echo -e "${YELLOW}⚠${NC} $1"; }
print_error() { echo -e "${RED}✗${NC} $1"; }
print_info() { echo -e "${BLUE}ℹ${NC} $1"; }

echo -e "${BLUE}Pre-push validation${NC}"
echo "==================="

remote="$1"
url="$2"

# Get commits being pushed
while IFS= read -r line; do
    local_ref=$(echo "$line" | cut -d' ' -f1)
    local_sha=$(echo "$line" | cut -d' ' -f2)
    remote_ref=$(echo "$line" | cut -d' ' -f3)
    remote_sha=$(echo "$line" | cut -d' ' -f4)
    
    if [[ "$local_sha" == "0000000000000000000000000000000000000000" ]]; then
        print_info "Deleting remote branch $remote_ref"
        continue
    fi
    
    if [[ "$remote_sha" == "0000000000000000000000000000000000000000" ]]; then
        print_info "Creating new remote branch $remote_ref"
        # For new branches, check the last 10 commits
        commit_range="HEAD~10..HEAD"
    else
        # For existing branches, check commits between remote and local
        commit_range="$remote_sha..$local_sha"
    fi
    
    # Check for commits with sensitive content
    echo "Checking commits in range: $commit_range"
    
    # Look for potentially sensitive patterns in commit messages
    sensitive_commits=$(git log --oneline "$commit_range" | grep -iE "(password|secret|key|token|api_key)" || true)
    if [[ -n "$sensitive_commits" ]]; then
        print_warning "Potentially sensitive information in commit messages:"
        echo "$sensitive_commits"
        echo
        read -p "Continue with push? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            print_error "Push cancelled"
            exit 1
        fi
    fi
    
    # Check for large files in commits
    large_files=$(git diff --name-only "$commit_range" | while IFS= read -r file; do
        if [[ -f "$file" ]]; then
            size=$(stat -f%z "$file" 2>/dev/null || echo 0)
            if [[ $size -gt 10485760 ]]; then  # 10MB
                echo "$file ($(( size / 1024 / 1024 ))MB)"
            fi
        fi
    done)
    
    if [[ -n "$large_files" ]]; then
        print_warning "Large files detected in commits:"
        echo "$large_files" | sed 's/^/  /'
        print_info "Consider using Git LFS for large binary files"
        echo
        read -p "Continue with push? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            print_error "Push cancelled"
            exit 1
        fi
    fi
    
done

print_success "Pre-push validation completed"
EOF

    chmod +x "$hook_file"
    print_success "Pre-push hook installed"
}

# Test hooks
test_hooks() {
    print_header "Testing Git Hooks"
    
    # Test pre-commit hook
    if [[ -x "$HOOKS_DIR/pre-commit" ]]; then
        print_info "Testing pre-commit hook (dry run)..."
        
        # Create a temporary test file
        echo "echo 'test'" > test-hook.sh
        git add test-hook.sh
        
        if "$HOOKS_DIR/pre-commit"; then
            print_success "Pre-commit hook test passed"
        else
            print_warning "Pre-commit hook test failed"
        fi
        
        # Clean up
        git reset HEAD test-hook.sh
        rm -f test-hook.sh
    fi
    
    # Test commit-msg hook
    if [[ -x "$HOOKS_DIR/commit-msg" ]]; then
        print_info "Testing commit-msg hook..."
        
        # Test with good message
        echo "🎉 feat: add new feature" > /tmp/test-commit-msg
        if "$HOOKS_DIR/commit-msg" /tmp/test-commit-msg; then
            print_success "Commit message hook test passed"
        else
            print_warning "Commit message hook test failed"
        fi
        
        rm -f /tmp/test-commit-msg
    fi
}

# Show hook status
show_status() {
    print_header "Git Hooks Status"
    
    local hooks=("pre-commit" "commit-msg" "prepare-commit-msg" "post-commit" "pre-push")
    
    for hook in "${hooks[@]}"; do
        local hook_file="$HOOKS_DIR/$hook"
        if [[ -x "$hook_file" ]]; then
            print_success "$hook hook installed"
        else
            print_warning "$hook hook not installed"
        fi
    done
    
    echo
    print_info "Hook files location: $HOOKS_DIR"
}

# Remove hooks
remove_hooks() {
    print_header "Removing Git Hooks"
    
    local hooks=("pre-commit" "commit-msg" "prepare-commit-msg" "post-commit" "pre-push")
    
    for hook in "${hooks[@]}"; do
        local hook_file="$HOOKS_DIR/$hook"
        if [[ -f "$hook_file" ]]; then
            rm -f "$hook_file"
            print_success "Removed $hook hook"
        fi
    done
}

# Show help
show_help() {
    cat << EOF
Git Hooks Setup Script

Usage: $0 [command]

Commands:
    install         Install all git hooks (default)
    test           Test installed hooks
    status         Show hook installation status
    remove         Remove all installed hooks
    help           Show this help message

Hooks installed:
    pre-commit     Validates shell scripts, markdown, JSON, and configurations
    commit-msg     Validates commit message format and conventions
    prepare-commit-msg  Provides commit message template and branch info
    post-commit    Runs health checks and provides helpful information
    pre-push       Validates commits before pushing to remote

The hooks enforce:
    • Shell script syntax validation with shellcheck
    • Markdown linting with markdownlint-cli2
    • JSON/JSONC syntax validation
    • Configuration file validation (tmux, etc.)
    • Conventional commit message format with emoji support
    • Detection of sensitive files and large binaries
    • Helpful commit templates and branch information

Examples:
    $0                 # Install all hooks
    $0 install         # Install all hooks
    $0 test           # Test hooks functionality
    $0 status         # Check which hooks are installed
    $0 remove         # Remove all hooks
EOF
}

# Main function
main() {
    local command="${1:-install}"
    
    case "$command" in
        "install")
            check_git_repo
            install_pre_commit_hook
            install_commit_msg_hook
            install_prepare_commit_msg_hook
            install_post_commit_hook
            install_pre_push_hook
            show_status
            echo
            print_success "All git hooks installed successfully!"
            print_info "The hooks will now validate your commits and provide helpful templates"
            ;;
        "test")
            check_git_repo
            test_hooks
            ;;
        "status")
            check_git_repo
            show_status
            ;;
        "remove")
            check_git_repo
            remove_hooks
            ;;
        "help"|"-h"|"--help")
            show_help
            ;;
        *)
            print_error "Unknown command: $command"
            show_help
            exit 1
            ;;
    esac
}

main "$@"