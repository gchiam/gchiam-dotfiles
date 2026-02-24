#!/usr/bin/env bash
set -euo pipefail

# Unified Test Runner for Dotfiles
# Runs all BATS tests in the tests/ directory

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

print_header() {
    echo -e "
${BLUE}=== $1 ===${NC}"
}

# Get repository root
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

# Check if BATS is installed
if ! command -v bats &> /dev/null; then
    echo -e "${RED}Error: BATS is not installed.${NC}"
    echo "Please install it via Homebrew: brew install bats-core"
    exit 1
fi

print_header "Running Shell Script Unit Tests"

# Run all .bats files in tests/ excluding libs and helpers
# We use find to get all .bats files and run them
find tests -name "*.bats" -not -path "tests/libs/*" -not -path "tests/helpers/*" | sort | while read -r test_file; do
    echo -e "Running ${BLUE}${test_file}${NC}..."
    if bats "$test_file"; then
        echo -e "${GREEN}✓ ${test_file} passed${NC}"
    else
        echo -e "${RED}✗ ${test_file} failed${NC}"
        exit 1
    fi
done

echo -e "
${GREEN}✅ All tests passed successfully!${NC}"
