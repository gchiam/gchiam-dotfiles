#!/usr/bin/env bash
set -euo pipefail

# Unified Test Runner for Dotfiles
# Runs every BATS file under tests/, then reports all failures.
# Exits non-zero if any test file failed.

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

TESTS_DIR="tests"

# Check if BATS is installed
if ! command -v bats &> /dev/null; then
    echo -e "${RED}Error: BATS is not installed.${NC}"
    echo "Please install it via Homebrew: brew install bats-core"
    exit 1
fi

# List test files, excluding vendored libraries and helpers
list_test_files() {
    find "$TESTS_DIR" -name "*.bats" \
        -not -path "$TESTS_DIR/libs/*" \
        -not -path "$TESTS_DIR/helpers/*" | sort
}

print_header "Running Shell Script Unit Tests"

total=0
failed_files=()

while IFS= read -r test_file; do
    total=$((total + 1))
    echo -e "Running ${BLUE}${test_file}${NC}..."
    if bats "$test_file"; then
        echo -e "${GREEN}✓ ${test_file} passed${NC}"
    else
        echo -e "${RED}✗ ${test_file} failed${NC}"
        failed_files+=("$test_file")
    fi
done < <(list_test_files)

if [[ $total -eq 0 ]]; then
    echo -e "${RED}Error: no test files found in ${TESTS_DIR}${NC}"
    exit 1
fi

if [[ ${#failed_files[@]} -gt 0 ]]; then
    print_header "Summary"
    echo -e "${RED}${#failed_files[@]} of ${total} test files failed:${NC}"
    printf '  - %s\n' "${failed_files[@]}"
    exit 1
fi

echo -e "
${GREEN}✅ All ${total} test files passed successfully!${NC}"
