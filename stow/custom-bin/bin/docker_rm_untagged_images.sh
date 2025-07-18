#!/bin/bash
# Remove all untagged/dangling Docker images

# Display usage information
usage() {
    echo "Usage: $0 [OPTIONS]"
    echo "Remove all untagged/dangling Docker images"
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

# Get list of dangling images
DANGLING_IMAGES=$(docker images -q --filter "dangling=true" 2>/dev/null)

if [[ -z "$DANGLING_IMAGES" ]]; then
    echo "No dangling images found."
    exit 0
fi

# Count images
IMAGE_COUNT=$(echo "$DANGLING_IMAGES" | wc -l | tr -d ' ')

# Show what will be removed
echo "Found $IMAGE_COUNT dangling image(s):"
docker images --filter "dangling=true" --format "table {{.ID}}\t{{.Repository}}\t{{.Tag}}\t{{.Size}}\t{{.CreatedSince}}"

# Confirm removal unless force flag is used
if [[ "$FORCE" != true ]]; then
    echo ""
    read -p "Remove these images? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Cancelled."
        exit 0
    fi
fi

# Remove images
echo "Removing dangling images..."
# shellcheck disable=SC2086 # We want word splitting for image IDs
if docker rmi $DANGLING_IMAGES; then
    echo "Successfully removed $IMAGE_COUNT dangling image(s)."
else
    echo "Error: Failed to remove some images" >&2
    exit 1
fi
