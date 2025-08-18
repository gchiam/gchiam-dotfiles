# vim: set ft=zsh:
# Work-Specific Functions
# Custom functions for work environments and productivity

# Work environment setup
work-setup() {
    echo "Setting up work environment..."
    
    # Set work-specific environment variables
    export WORK_MODE=true
    export ENVIRONMENT=${1:-development}
    
    # Work-specific PATH additions
    # export PATH="/work/tools/bin:$PATH"
    
    # Work-specific aliases (if different from default)
    # alias kubectl='kubectl --context=work-cluster'
    
    echo "✓ Work environment configured for $ENVIRONMENT"
}

# Quick work project switcher
work-project() {
    local project="$1"
    case "$project" in
        main|m)
            # cd ~/work/main-project
            echo "Switched to main project (customize path)"
            ;;
        api|a)
            # cd ~/work/api-project
            echo "Switched to API project (customize path)"
            ;;
        frontend|fe|f)
            # cd ~/work/frontend-project
            echo "Switched to frontend project (customize path)"
            ;;
        *)
            echo "Available projects: main|api|frontend"
            echo "Usage: work-project <project>"
            ;;
    esac
}

# Work time tracking
work-time() {
    local action="$1"
    local time_file="$HOME/.work-time.log"
    
    case "$action" in
        start|in)
            echo "$(date '+%Y-%m-%d %H:%M:%S') - Work started" >> "$time_file"
            echo "✓ Work time started at $(date '+%H:%M')"
            ;;
        end|out)
            echo "$(date '+%Y-%m-%d %H:%M:%S') - Work ended" >> "$time_file"
            echo "✓ Work time ended at $(date '+%H:%M')"
            ;;
        break)
            echo "$(date '+%Y-%m-%d %H:%M:%S') - Break started" >> "$time_file"
            echo "✓ Break started at $(date '+%H:%M')"
            ;;
        resume)
            echo "$(date '+%Y-%m-%d %H:%M:%S') - Break ended" >> "$time_file"
            echo "✓ Back to work at $(date '+%H:%M')"
            ;;
        log)
            if [[ -f "$time_file" ]]; then
                echo "Recent work time entries:"
                tail -"${2:-10}" "$time_file"
            else
                echo "No work time log found"
            fi
            ;;
        *)
            echo "Usage: work-time {start|end|break|resume|log [lines]}"
            ;;
    esac
}

# Work meeting helper
work-meeting() {
    local action="$1"
    case "$action" in
        start)
            echo "📞 Meeting started at $(date '+%H:%M')"
            # Set status to busy
            # Mute notifications if needed
            ;;
        end)
            echo "✓ Meeting ended at $(date '+%H:%M')"
            # Restore normal status
            ;;
        notes)
            local notes_file="$HOME/work-meeting-notes-$(date '+%Y-%m-%d').md"
            ${EDITOR:-vim} "$notes_file"
            ;;
        *)
            echo "Usage: work-meeting {start|end|notes}"
            ;;
    esac
}

# Work deployment helper
work-deploy() {
    local environment="$1"
    local confirmation
    
    case "$environment" in
        dev|development)
            echo "Deploying to development environment..."
            # Add deployment commands here
            ;;
        staging|stage)
            echo "⚠️  Deploying to staging environment"
            echo -n "Are you sure? [y/N] "
            read -r confirmation
            if [[ "$confirmation" =~ ^[Yy]$ ]]; then
                echo "Deploying to staging..."
                # Add staging deployment commands here
            else
                echo "Deployment cancelled"
            fi
            ;;
        prod|production)
            echo "🚨 PRODUCTION DEPLOYMENT"
            echo -n "Are you absolutely sure? Type 'DEPLOY' to confirm: "
            read -r confirmation
            if [[ "$confirmation" == "DEPLOY" ]]; then
                echo "Deploying to production..."
                # Add production deployment commands here
            else
                echo "Production deployment cancelled"
            fi
            ;;
        *)
            echo "Usage: work-deploy {dev|staging|prod}"
            echo "Available environments:"
            echo "  dev        - Development environment"
            echo "  staging    - Staging environment"
            echo "  prod       - Production environment (requires confirmation)"
            ;;
    esac
}

# Work VPN connection helper
work-vpn() {
    local action="$1"
    case "$action" in
        connect|on)
            echo "Connecting to work VPN..."
            # Add VPN connection command here
            # networksetup -connectpppoeservice "Work VPN"
            ;;
        disconnect|off)
            echo "Disconnecting from work VPN..."
            # Add VPN disconnection command here
            # networksetup -disconnectpppoeservice "Work VPN"
            ;;
        status)
            echo "Checking VPN status..."
            # Add VPN status check here
            ;;
        *)
            echo "Usage: work-vpn {connect|disconnect|status}"
            ;;
    esac
}

# Work environment cleanup
work-cleanup() {
    echo "Cleaning up work environment..."
    
    # Clear sensitive environment variables
    unset WORK_API_KEY
    unset WORK_SECRET
    
    # Clear work-specific history entries if needed
    # history -d $(history | grep "sensitive-command" | cut -d' ' -f2)
    
    echo "✓ Work environment cleaned up"
}

# Work-specific functions loaded - customize for your environment
