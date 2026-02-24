#!/usr/bin/env bash
set -euo pipefail

# Auto-Sync Script
# Periodically updates submodules and commits changes automatically

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

# Configuration
DRY_RUN=false
FORCE_SYNC=false
AUTO_COMMIT=true
AUTO_PUSH=false
CHECK_INTERVAL=7  # days

# Get repository root
REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
# shellcheck source=bin/utils.sh
source "$REPO_ROOT/bin/utils.sh"

# XDG paths for logs and state
SYNC_LOG="$(get_xdg_path STATE)/dotfiles/sync.log"
LAST_SYNC_FILE="$(get_xdg_path STATE)/dotfiles/last-sync"
ensure_dir "$SYNC_LOG"

# Logging function
log_action() {
    echo "$(date): $1" >> "$SYNC_LOG"
}

# Check if sync is needed
needs_sync() {
    if [[ "$FORCE_SYNC" == true ]]; then
        return 0
    fi
    
    if [[ ! -f "$LAST_SYNC_FILE" ]]; then
        return 0
    fi
    
    local last_sync
    last_sync=$(cat "$LAST_SYNC_FILE")
    local now
    now=$(date +%s)
    local days_since=$(( (now - last_sync) / 86400 ))
    
    [[ $days_since -ge $CHECK_INTERVAL ]]
}

# Update submodules and check for changes
update_submodules() {
    print_header "Updating Submodules"
    
    if [[ "$DRY_RUN" == true ]]; then
        print_info "DRY RUN: Would update all submodules"
        git submodule status
        return 0
    fi
    
    # Update submodules to latest versions
    if git submodule update --remote --merge; then
        print_success "Submodules updated successfully"
        log_action "Submodules updated"
    else
        print_error "Failed to update submodules"
        log_action "ERROR: Submodule update failed"
        return 1
    fi
    
    # Check for changes
    # Use array to properly handle multiple submodule paths
    local submodule_paths
    mapfile -t submodule_paths < <(git submodule status | awk '{print $2}')
    if git diff --quiet HEAD -- "${submodule_paths[@]}" 2>/dev/null; then
        print_info "No submodule updates available"
        return 1
    else
        print_success "Submodule updates found"
        return 0
    fi
}

# Show what would be updated
show_updates() {
    print_header "Available Updates"
    
    local updated_modules=()
    while IFS= read -r line; do
        if [[ $line == +* ]]; then
            local module_path
            module_path=$(echo "$line" | awk '{print $2}')
            local new_commit
            new_commit=$(echo "$line" | awk '{print $1}' | sed 's/^+//')
            updated_modules+=("$module_path")
            
            # Get old commit from git
            local old_commit
            old_commit=$(git ls-tree HEAD "$module_path" | awk '{print $3}')
            
            echo "  $module_path:"
            echo "    Old: $old_commit"
            echo "    New: $new_commit"
            
            # Show commit messages between versions
            if [[ -d "$module_path" ]]; then
                local commits
                commits=$(cd "$module_path" && git log --oneline "$old_commit..$new_commit" 2>/dev/null | head -5)
                if [[ -n "$commits" ]]; then
                    echo "    Changes:"
                    while IFS= read -r line; do echo "      $line"; done <<< "$commits"
                fi
            fi
        fi
    done < <(git submodule status)
    
    if [[ ${#updated_modules[@]} -eq 0 ]]; then
        print_info "No updates available"
        return 1
    fi
    
    return 0
}

# Create update commit
commit_updates() {
    print_header "Committing Updates"
    
    if [[ "$DRY_RUN" == true ]]; then
        print_info "DRY RUN: Would commit submodule updates"
        return 0
    fi
    
    # Get list of updated submodules
    local updated_modules=()
    local update_summary=""
    
    while IFS= read -r line; do
        if [[ $line == +* ]]; then
            local module_path
            module_path=$(echo "$line" | awk '{print $2}')
            local module_name
            module_name=$(basename "$module_path")
            updated_modules+=("$module_name")
        fi
    done < <(git submodule status)
    
    if [[ ${#updated_modules[@]} -eq 0 ]]; then
        print_warning "No submodule changes to commit"
        return 1
    fi
    
    # Create commit message
    if [[ ${#updated_modules[@]} -eq 1 ]]; then
        update_summary="Update ${updated_modules[0]} submodule"
    elif [[ ${#updated_modules[@]} -le 3 ]]; then
        update_summary="Update $(IFS=', '; echo "${updated_modules[*]}") submodules"
    else
        update_summary="Update ${#updated_modules[@]} submodules"
    fi
    
    # Stage submodule changes
    for module in $(git submodule status | awk '{print $2}'); do
        git add "$module"
    done
    
    # Create commit
    git commit -m "$(cat <<EOF
⬆️ chore(auto): $update_summary

Automated submodule updates:
$(for module in "${updated_modules[@]}"; do echo "- $module"; done)

Generated by auto-sync script on $(date)

🤖 Generated with [Claude Code](https://claude.ai/code)

Co-Authored-By: Claude <noreply@anthropic.com>
EOF
)"
    
    print_success "Updates committed successfully"
    log_action "Committed updates: ${updated_modules[*]}"
    
    # Update last sync timestamp
    date +%s > "$LAST_SYNC_FILE"
}

# Push changes to remote
push_updates() {
    print_header "Pushing Updates"
    
    if [[ "$DRY_RUN" == true ]]; then
        print_info "DRY RUN: Would push to remote"
        return 0
    fi
    
    if [[ "$AUTO_PUSH" != true ]]; then
        print_info "Auto-push disabled, skipping remote push"
        print_info "Push manually with: git push"
        return 0
    fi
    
    # Check if we have a remote configured
    if ! git remote | grep -q origin; then
        print_warning "No remote 'origin' configured, skipping push"
        return 0
    fi
    
    # Push to remote
    if git push origin main; then
        print_success "Changes pushed to remote"
        log_action "Changes pushed to remote"
    else
        print_warning "Failed to push to remote"
        log_action "WARNING: Push to remote failed"
    fi
}

# Check repository health
check_repo_health() {
    print_header "Repository Health Check"
    
    # Check if we're in a git repository
    if ! git rev-parse --git-dir &> /dev/null; then
        print_error "Not in a git repository"
        return 1
    fi
    
    # Check for uncommitted changes
    if ! git diff --quiet; then
        print_warning "Repository has uncommitted changes"
        if [[ "$AUTO_COMMIT" != true ]]; then
            print_error "Cannot proceed with auto-sync"
            return 1
        fi
    fi
    
    # Check for untracked files
    if [[ -n $(git ls-files --others --exclude-standard) ]]; then
        print_warning "Repository has untracked files"
    fi
    
    # Check if submodules are properly initialized
    if ! git submodule status | head -1 | grep -q "^[[:space:]]"; then
        print_warning "Some submodules may not be properly initialized"
        print_info "Run: git submodule update --init --recursive"
    fi
    
    print_success "Repository health check complete"
}

# Generate sync report
generate_report() {
    print_header "Sync Report"
    
    local report_file
    report_file="sync-report-$(date +%Y%m%d-%H%M%S).txt"
    
    {
        echo "Auto-Sync Report"
        echo "Generated: $(date)"
        echo "================"
        echo
        echo "Configuration:"
        echo "  Check Interval: $CHECK_INTERVAL days"
        echo "  Auto Commit: $AUTO_COMMIT"
        echo "  Auto Push: $AUTO_PUSH"
        echo "  Repository: $REPO_ROOT"
        echo
        echo "Submodule Status:"
        git submodule status
        echo
        echo "Recent Sync History:"
        tail -10 "$SYNC_LOG" 2>/dev/null || echo "No sync history available"
    } > "$report_file"
    
    print_success "Sync report saved: $report_file"
}

# Schedule sync via cron/launchd
setup_automation() {
    print_header "Setting Up Automated Sync"
    
    local script_path
    script_path="$(realpath "$0")"
    
    # macOS launchd configuration
    local plist_file="$HOME/Library/LaunchAgents/com.gchiam.dotfiles-sync.plist"
    
    cat > "$plist_file" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.gchiam.dotfiles-sync</string>
    <key>ProgramArguments</key>
    <array>
        <string>$script_path</string>
        <string>--auto</string>
    </array>
    <key>WorkingDirectory</key>
    <string>$REPO_ROOT</string>
    <key>StartInterval</key>
    <integer>$(( CHECK_INTERVAL * 86400 ))</integer>
    <key>RunAtLoad</key>
    <false/>
    <key>StandardOutPath</key>
    <string>$(get_xdg_path STATE)/dotfiles/sync-stdout.log</string>
    <key>StandardErrorPath</key>
    <string>$(get_xdg_path STATE)/dotfiles/sync-stderr.log</string>
    <key>EnvironmentVariables</key>
    <dict>
        <key>PATH</key>
        <string>/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin</string>
    </dict>
</dict>
</plist>
EOF
    
    # Load the launch agent
    if launchctl load "$plist_file" 2>/dev/null; then
        print_success "Automated sync scheduled via launchd"
        print_info "Check status with: launchctl list | grep dotfiles-sync"
    else
        print_warning "Failed to load launch agent, using cron fallback"
        
        # Fallback to cron
        local cron_entry="0 9 * * $(( CHECK_INTERVAL == 7 ? 1 : '*' )) cd $REPO_ROOT && $script_path --auto"
        
        if (crontab -l 2>/dev/null; echo "$cron_entry") | crontab -; then
            print_success "Automated sync scheduled via cron"
        else
            print_error "Failed to setup automated sync"
        fi
    fi
}

# Remove automation
remove_automation() {
    print_header "Removing Automated Sync"
    
    # Remove launchd agent
    local plist_file="$HOME/Library/LaunchAgents/com.gchiam.dotfiles-sync.plist"
    if [[ -f "$plist_file" ]]; then
        launchctl unload "$plist_file" 2>/dev/null || true
        rm -f "$plist_file"
        print_success "Removed launchd agent"
    fi
    
    # Remove from cron
    if crontab -l 2>/dev/null | grep -v "auto-sync.sh" | crontab -; then
        print_success "Removed cron entries"
    fi
}

# Show sync status
show_status() {
    print_header "Auto-Sync Status"
    
    if [[ -f "$LAST_SYNC_FILE" ]]; then
        local last_sync
        last_sync=$(cat "$LAST_SYNC_FILE")
        local last_sync_date
        last_sync_date=$(date -r "$last_sync" 2>/dev/null || echo "Unknown")
        local days_since=$(( ($(date +%s) - last_sync) / 86400 ))
        
        echo "Last sync: $last_sync_date ($days_since days ago)"
    else
        echo "Never synced"
    fi
    
    echo "Next sync: $(if needs_sync; then echo "Now"; else echo "In $(( CHECK_INTERVAL - days_since )) days"; fi)"
    echo "Check interval: $CHECK_INTERVAL days"
    echo "Auto commit: $AUTO_COMMIT"
    echo "Auto push: $AUTO_PUSH"
    echo "Sync log: $SYNC_LOG"
    
    # Check automation status
    if [[ -f "$HOME/Library/LaunchAgents/com.gchiam.dotfiles-sync.plist" ]]; then
        echo "Automation: Enabled (launchd)"
    elif crontab -l 2>/dev/null | grep -q "auto-sync.sh"; then
        echo "Automation: Enabled (cron)"
    else
        echo "Automation: Disabled"
    fi
    
    # Show recent activity
    if [[ -f "$SYNC_LOG" ]]; then
        echo
        echo "Recent activity:"
        tail -5 "$SYNC_LOG"
    fi
}

# Show help
show_help() {
    cat << EOF
Auto-Sync Script for Dotfiles Repository

Usage: $0 [options] [command]

Commands:
    sync                 Run sync process (check, update, commit)
    status               Show current sync status
    setup-automation     Setup automated sync via launchd/cron
    remove-automation    Remove automated sync
    report               Generate detailed sync report
    health               Check repository health

Options:
    --dry-run           Show what would be done without making changes
    --force             Force sync even if not due
    --no-commit         Don't auto-commit changes
    --auto-push         Automatically push changes to remote
    --interval DAYS     Set check interval (default: $CHECK_INTERVAL days)
    --auto              Run in automated mode (used by scheduler)
    -h, --help          Show this help message

Examples:
    $0 sync                     # Run manual sync
    $0 --dry-run sync          # Preview what would be synced
    $0 --force --auto-push sync # Force sync and push to remote
    $0 setup-automation        # Enable automated syncing
    $0 status                  # Check sync status

Configuration:
    Sync log: $SYNC_LOG
    Last sync: $LAST_SYNC_FILE
    Check interval: $CHECK_INTERVAL days
EOF
}

# Main function
main() {
    local command="sync"
    
    # Parse options
    while [[ $# -gt 0 ]]; do
        case $1 in
            --dry-run)
                DRY_RUN=true
                shift
                ;;
            --force)
                FORCE_SYNC=true
                shift
                ;;
            --no-commit)
                AUTO_COMMIT=false
                shift
                ;;
            --auto-push)
                AUTO_PUSH=true
                shift
                ;;
            --interval)
                CHECK_INTERVAL="$2"
                shift 2
                ;;
            --auto)
                # Automated mode - less verbose output
                AUTO_COMMIT=true
                shift
                ;;
            sync|status|setup-automation|remove-automation|report|health)
                command="$1"
                shift
                ;;
            -h|--help)
                show_help
                exit 0
                ;;
            *)
                print_error "Unknown option: $1"
                show_help
                exit 1
                ;;
        esac
    done
    
    # Change to repository root
    cd "$REPO_ROOT"
    
    echo -e "${BLUE}Auto-Sync for Dotfiles${NC}"
    echo "======================"
    
    case "$command" in
        "sync")
            if ! needs_sync && [[ "$FORCE_SYNC" != true ]]; then
                print_info "Sync not needed (last sync was recent)"
                print_info "Use --force to sync anyway"
                exit 0
            fi
            
            check_repo_health || exit 1
            
            if update_submodules; then
                show_updates
                
                if [[ "$AUTO_COMMIT" == true ]]; then
                    commit_updates
                    push_updates
                else
                    print_info "Auto-commit disabled, changes staged but not committed"
                fi
            else
                print_info "No updates available"
            fi
            ;;
        "status")
            show_status
            ;;
        "setup-automation")
            setup_automation
            ;;
        "remove-automation")
            remove_automation
            ;;
        "report")
            generate_report
            ;;
        "health")
            check_repo_health
            ;;
        *)
            print_error "Unknown command: $command"
            show_help
            exit 1
            ;;
    esac
    
    print_success "Auto-sync completed"
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    main "$@"
fi