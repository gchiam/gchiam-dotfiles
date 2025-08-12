#!/opt/homebrew/bin/bash
set -e

# Repository Optimization Script
# Optimizes repository structure with Git LFS for binary assets
# and prepares for submodule migration

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

# Check if Git LFS is available
check_git_lfs() {
    if ! command -v git-lfs &> /dev/null; then
        print_warning "Git LFS not found. Installing..."
        if command -v brew &> /dev/null; then
            brew install git-lfs
            print_success "Installed Git LFS via Homebrew"
        else
            print_error "Please install Git LFS manually: https://git-lfs.github.io/"
            exit 1
        fi
    else
        print_success "Git LFS is available"
    fi
}

# Initialize Git LFS
setup_git_lfs() {
    print_header "Setting up Git LFS"
    
    # Only install Git LFS hooks if not already installed
    if [[ ! -f .git/hooks/pre-push ]] || ! grep -q "git-lfs" .git/hooks/pre-push 2>/dev/null; then
        git lfs install --local
        print_success "Installed Git LFS hooks"
    else
        print_info "Git LFS hooks already installed"
    fi
    
    # Create .gitattributes for binary files
    cat > .gitattributes << 'EOF'
# Git LFS configuration for binary assets

# Images
*.png filter=lfs diff=lfs merge=lfs -text
*.jpg filter=lfs diff=lfs merge=lfs -text
*.jpeg filter=lfs diff=lfs merge=lfs -text
*.gif filter=lfs diff=lfs merge=lfs -text
*.webp filter=lfs diff=lfs merge=lfs -text
*.svg filter=lfs diff=lfs merge=lfs -text
*.ico filter=lfs diff=lfs merge=lfs -text

# Fonts
*.ttf filter=lfs diff=lfs merge=lfs -text
*.otf filter=lfs diff=lfs merge=lfs -text
*.woff filter=lfs diff=lfs merge=lfs -text
*.woff2 filter=lfs diff=lfs merge=lfs -text

# Archives
*.zip filter=lfs diff=lfs merge=lfs -text
*.tar.gz filter=lfs diff=lfs merge=lfs -text
*.tar.bz2 filter=lfs diff=lfs merge=lfs -text

# Audio/Video (if any)
*.mp3 filter=lfs diff=lfs merge=lfs -text
*.mp4 filter=lfs diff=lfs merge=lfs -text
*.mov filter=lfs diff=lfs merge=lfs -text

# Large text files that might be generated
*.log filter=lfs diff=lfs merge=lfs -text
*.dump filter=lfs diff=lfs merge=lfs -text
EOF
    
    print_success "Created .gitattributes for Git LFS"
}

# Migrate existing binary files to LFS
migrate_to_lfs() {
    print_header "Migrating Binary Files to Git LFS"
    
    # Find binary files that should be in LFS
    local binary_files=()
    while IFS= read -r -d '' file; do
        binary_files+=("$file")
    done < <(find external -type f \( -name "*.webp" -o -name "*.png" -o -name "*.jpg" -o -name "*.jpeg" -o -name "*.gif" \) -print0 2>/dev/null || true)
    
    if [[ ${#binary_files[@]} -eq 0 ]]; then
        print_info "No binary files found to migrate"
        return 0
    fi
    
    print_info "Found ${#binary_files[@]} binary files to migrate to LFS"
    
    # Show files that will be migrated
    for file in "${binary_files[@]}"; do
        local size=$(du -h "$file" | cut -f1)
        echo "  - $file ($size)"
    done
    
    echo
    read -p "Migrate these files to Git LFS? (y/N): " -n 1 -r
    echo
    
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_info "Skipping LFS migration"
        return 0
    fi
    
    # Migrate files to LFS
    for file in "${binary_files[@]}"; do
        if git lfs track "$file" 2>/dev/null; then
            print_success "Tracked $file with LFS"
        else
            print_warning "Failed to track $file with LFS"
        fi
    done
    
    # Add the .gitattributes changes
    git add .gitattributes
    
    print_success "Binary files migrated to Git LFS"
}

# Create submodule preparation script
create_submodule_script() {
    print_header "Creating Submodule Migration Script"
    
    cat > bin/migrate-to-submodules.sh << 'EOF'
#!/opt/homebrew/bin/bash
set -e

# Submodule Migration Script
# Converts external dependencies to Git submodules

# Colors (only if terminal supports them)
if [[ -t 1 ]] && command -v tput &> /dev/null && [[ $(tput colors 2>/dev/null || echo 0) -ge 8 ]]; then
    RED='\033[0;31m'
    GREEN='\033[0;32m'
    YELLOW='\033[1;33m'
    BLUE='\033[0;34m'
    NC='\033[0m'
else
    RED=''
    GREEN=''
    YELLOW=''
    BLUE=''
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

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

# Submodule configurations
declare -A SUBMODULES=(
    ["external/catppuccin/alacritty"]="https://github.com/catppuccin/alacritty.git"
    ["external/catppuccin/bat"]="https://github.com/catppuccin/bat.git"
    ["external/catppuccin/delta"]="https://github.com/catppuccin/delta.git"
    ["external/catppuccin/gh-dash"]="https://github.com/catppuccin/gh-dash.git"
    ["external/catppuccin/k9s"]="https://github.com/catppuccin/k9s.git"
    ["external/catppuccin/zsh-fsh"]="https://github.com/catppuccin/zsh-fast-syntax-highlighting.git"
    ["external/tmux-plugins/tpm"]="https://github.com/tmux-plugins/tpm.git"
)

migrate_to_submodules() {
    print_header "Migrating External Dependencies to Submodules"
    
    print_warning "This operation will:"
    echo "  - Remove existing external directories"
    echo "  - Add them as Git submodules"  
    echo "  - Require internet connection to clone repositories"
    echo
    
    read -p "Continue with submodule migration? (y/N): " -n 1 -r
    echo
    
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_info "Submodule migration cancelled"
        exit 0
    fi
    
    # Create backup of current external directory
    local backup_dir="external-backup-$(date +%Y%m%d-%H%M%S)"
    cp -r external "$backup_dir"
    print_success "Created backup: $backup_dir"
    
    # Remove existing directories and add as submodules
    for path in "${!SUBMODULES[@]}"; do
        local url="${SUBMODULES[$path]}"
        
        if [[ -d "$path" ]]; then
            print_info "Migrating $path to submodule..."
            
            # Remove existing directory from git
            git rm -r "$path" 2>/dev/null || true
            rm -rf "$path"
            
            # Add as submodule
            if git submodule add "$url" "$path"; then
                print_success "Added $path as submodule"
            else
                print_warning "Failed to add $path as submodule"
            fi
        else
            print_warning "$path does not exist, skipping"
        fi
    done
    
    # Initialize and update submodules
    git submodule update --init --recursive
    
    print_success "Submodule migration completed"
    print_info "Backup available at: $backup_dir"
    print_info "Run 'git submodule update --remote' to update submodules"
}

# Show current external dependencies
show_dependencies() {
    print_header "Current External Dependencies"
    
    echo "Directories that could become submodules:"
    for path in "${!SUBMODULES[@]}"; do
        if [[ -d "$path" ]]; then
            local size=$(du -sh "$path" | cut -f1)
            echo "  - $path ($size) -> ${SUBMODULES[$path]}"
        else
            echo "  - $path (missing) -> ${SUBMODULES[$path]}"
        fi
    done
}

case "${1:-}" in
    "migrate")
        migrate_to_submodules
        ;;
    "show"|"list")
        show_dependencies
        ;;
    *)
        echo "Usage: $0 {migrate|show}"
        echo ""
        echo "Commands:"
        echo "  migrate  Convert external dependencies to submodules"
        echo "  show     Show current external dependencies"
        ;;
esac
EOF
    
    chmod +x bin/migrate-to-submodules.sh
    print_success "Created submodule migration script"
}

# Analyze repository size and structure
analyze_repository() {
    print_header "Repository Analysis"
    
    echo "Current repository structure:"
    echo "├── Total size: $(du -sh . | cut -f1)"
    echo "├── External dependencies: $(du -sh external | cut -f1)"
    echo "├── Stow configurations: $(du -sh stow | cut -f1)"
    echo "├── Documentation: $(du -sh docs | cut -f1)"
    echo "├── Scripts: $(du -sh bin | cut -f1)"
    # Calculate other size by subtracting known directories (BSD du compatible)
    local total_kb=$(du -sk . | cut -f1)
    local external_kb=$(du -sk external 2>/dev/null | cut -f1 || echo 0)
    local stow_kb=$(du -sk stow 2>/dev/null | cut -f1 || echo 0)
    local docs_kb=$(du -sk docs 2>/dev/null | cut -f1 || echo 0)
    local bin_kb=$(du -sk bin 2>/dev/null | cut -f1 || echo 0)
    local other_kb=$((total_kb - external_kb - stow_kb - docs_kb - bin_kb))
    local other_mb=$((other_kb / 1024))
    echo "└── Other: ${other_mb}MB"
    
    echo
    echo "Binary assets:"
    local binary_count=0
    local binary_size=0
    
    while IFS= read -r line; do
        if [[ -n "$line" ]]; then
            binary_count=$((binary_count + 1))
            local size_kb=$(echo "$line" | awk '{print $1}' | sed 's/K//')
            binary_size=$((binary_size + size_kb))
        fi
    done < <(find external -type f \( -name "*.webp" -o -name "*.png" -o -name "*.jpg" -o -name "*.jpeg" \) -exec du -k {} \; 2>/dev/null || true)
    
    echo "  - Count: $binary_count files"
    echo "  - Total size: $((binary_size / 1024))MB"
    
    if [[ $binary_count -gt 0 ]]; then
        print_info "These files would benefit from Git LFS"
    fi
}

# Clean up repository
cleanup_repository() {
    print_header "Repository Cleanup"
    
    # Remove .DS_Store files
    find . -name ".DS_Store" -type f -delete 2>/dev/null || true
    print_success "Removed .DS_Store files"
    
    # Clean up empty directories
    find . -type d -empty -delete 2>/dev/null || true
    print_success "Removed empty directories"
    
    # Update .gitignore with additional patterns
    if ! grep -q "# Repository optimization" .gitignore 2>/dev/null; then
        cat >> .gitignore << 'EOF'

# Repository optimization
external-backup-*/
*.orig
*.rej
.DS_Store
*~
.*.swp
.*.swo
EOF
        print_success "Updated .gitignore with optimization patterns"
    fi
}

# Show help
show_help() {
    cat << EOF
Repository Optimization Script

Usage: $0 [options]

Options:
  -h, --help          Show this help message
  --analyze           Analyze repository size and structure
  --lfs               Set up Git LFS for binary files
  --migrate-lfs       Migrate existing binary files to LFS
  --submodules        Create submodule migration script
  --cleanup           Clean up repository
  --all               Run all optimizations

This script optimizes the repository structure by:
1. Setting up Git LFS for binary assets
2. Preparing submodule migration scripts
3. Analyzing repository structure
4. Cleaning up unnecessary files
EOF
}

# Main function
main() {
    local run_analyze=false
    local run_lfs=false
    local run_migrate_lfs=false
    local run_submodules=false
    local run_cleanup=false
    
    case "${1:-}" in
        "--analyze")
            run_analyze=true
            ;;
        "--lfs")
            run_lfs=true
            ;;
        "--migrate-lfs")
            run_migrate_lfs=true
            ;;
        "--submodules")
            run_submodules=true
            ;;
        "--cleanup")
            run_cleanup=true
            ;;
        "--all")
            run_analyze=true
            run_lfs=true
            run_migrate_lfs=true
            run_submodules=true
            run_cleanup=true
            ;;
        "-h"|"--help")
            show_help
            exit 0
            ;;
        "")
            # Interactive mode
            run_analyze=true
            run_lfs=true
            run_submodules=true
            run_cleanup=true
            ;;
        *)
            print_error "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
    
    echo -e "${BLUE}Repository Optimization${NC}"
    echo "========================"
    
    if [[ "$run_analyze" == true ]]; then
        analyze_repository
    fi
    
    if [[ "$run_lfs" == true ]]; then
        check_git_lfs
        setup_git_lfs
    fi
    
    if [[ "$run_migrate_lfs" == true ]]; then
        migrate_to_lfs
    fi
    
    if [[ "$run_submodules" == true ]]; then
        create_submodule_script
    fi
    
    if [[ "$run_cleanup" == true ]]; then
        cleanup_repository
    fi
    
    print_success "Repository optimization completed!"
    print_info "Next steps:"
    echo "  1. Review and commit .gitattributes changes"
    echo "  2. Consider running bin/migrate-to-submodules.sh"
    echo "  3. Test LFS functionality with binary files"
}

main "$@"