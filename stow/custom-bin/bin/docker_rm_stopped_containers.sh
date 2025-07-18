#!/bin/bash
# Remove all stopped/exited Docker containers

# Display usage information
usage() {
    echo "Usage: $0 [OPTIONS]"
    echo "Remove all stopped/exited Docker containers"
    echo ""
    echo "Options:"
    echo "  -h, --help     Show this help message"
    echo "  -f, --force    Force removal without confirmation"
    echo ""
}

# Parse command line arguments
FORCE=false
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            usage
            exit 0
            ;;
        -f|--force)
            FORCE=true
            shift
            ;;
        *)
            echo "Unknown option: $1" >&2
            usage >&2
            exit 1
            ;;
    esac
done

# Check if Docker is available
if ! command -v docker >/dev/null 2>&1; then
    echo "Error: Docker is not installed or not in PATH" >&2
    exit 1
fi

# Check if Docker daemon is running
if ! docker info >/dev/null 2>&1; then
    echo "Error: Docker daemon is not running" >&2
    exit 1
fi

# Get list of stopped containers
STOPPED_CONTAINERS=$(docker ps -a -q -f "status=exited" 2>/dev/null)

if [[ -z "$STOPPED_CONTAINERS" ]]; then
    echo "No stopped containers found."
    exit 0
fi

# Count containers
CONTAINER_COUNT=$(echo "$STOPPED_CONTAINERS" | wc -l | tr -d ' ')

# Show what will be removed
echo "Found $CONTAINER_COUNT stopped container(s):"
docker ps -a --filter "status=exited" --format "table {{.ID}}\t{{.Image}}\t{{.Names}}\t{{.Status}}"

# Confirm removal unless force flag is used
if [[ "$FORCE" != true ]]; then
    echo ""
    read -p "Remove these containers? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Cancelled."
        exit 0
    fi
fi

# Remove containers
echo "Removing stopped containers..."
if docker rm $STOPPED_CONTAINERS; then
    echo "Successfully removed $CONTAINER_COUNT stopped container(s)."
else
    echo "Error: Failed to remove some containers" >&2
    exit 1
fi
