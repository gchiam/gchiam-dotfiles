#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
BREW_DIR="$REPO_ROOT/brew"
OUTPUT="${1:-$HOME/.Brewfile}"

# Colors
BOLD='\033[1m'
DIM='\033[2m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
RED='\033[0;31m'
NC='\033[0m'

usage() {
    echo -e "${BOLD}Usage:${NC} $0 [output-file] [--profile <profile>[,<profile>...]]"
    echo ""
    echo -e "${BOLD}Generates a Brewfile by concatenating brew/ fragments.${NC}"
    echo ""
    echo -e "${BOLD}Profiles:${NC}"
    echo -e "  ${CYAN}minimal${NC}   base only"
    echo -e "  ${CYAN}personal${NC}  base + dev + ui  (default)"
    echo -e "  ${CYAN}work${NC}      base + dev + ui + work"
    echo -e "  ${CYAN}all${NC}       base + dev + ui + work (all fragments)"
    echo ""
    echo -e "${DIM}Multiple profiles can be combined: --profile personal,work${NC}"
    echo -e "${DIM}Output defaults to ~/.Brewfile${NC}"
    exit 1
}

PROFILE="personal"

# Parse args
while [[ $# -gt 0 ]]; do
    case "$1" in
        --profile)
            PROFILE="$2"
            shift 2
            ;;
        --help|-h)
            usage
            ;;
        -*)
            echo "Unknown option: $1" >&2
            usage
            ;;
        *)
            OUTPUT="$1"
            shift
            ;;
    esac
done

# Resolve fragments from one or more comma-separated profiles, deduplicating
# while preserving order: base, dev, ui, work
seen=""
fragments=()

add_fragment() {
    local f="$1"
    if [[ "$seen" != *"|$f|"* ]]; then
        seen="$seen|$f|"
        fragments+=("$f")
    fi
}

IFS=',' read -ra profiles <<< "$PROFILE"
for profile in "${profiles[@]}"; do
    case "$profile" in
        minimal)
            add_fragment base
            ;;
        personal)
            add_fragment base
            add_fragment dev
            add_fragment ui
            ;;
        work)
            add_fragment base
            add_fragment dev
            add_fragment ui
            add_fragment work
            ;;
        all)
            add_fragment base
            add_fragment dev
            add_fragment ui
            add_fragment work
            ;;
        *)
            echo -e "${RED}✗ Unknown profile: $profile${NC}" >&2
            usage
            ;;
    esac
done

echo -e "\n🍺 ${BOLD}Generating Brewfile${NC}"
echo -e "   ${DIM}Profile(s):${NC} ${CYAN}$PROFILE${NC}"
echo -e "   ${DIM}Output:${NC}     ${CYAN}$OUTPUT${NC}"
echo -e "\n📦 ${BOLD}Fragments:${NC}"

true > "$OUTPUT"

for fragment in "${fragments[@]}"; do
    file="$BREW_DIR/$fragment.brew"
    if [[ -f "$file" ]]; then
        echo -e "   ${GREEN}✓${NC} $fragment.brew"
        cat "$file" >> "$OUTPUT"
        echo "" >> "$OUTPUT"
    else
        echo -e "   ${YELLOW}⚠${NC} $fragment.brew ${DIM}(not found, skipping)${NC}" >&2
    fi
done

echo -e "\n${GREEN}✓ Done!${NC} Install with:"
echo -e "   ${BOLD}brew bundle --file=$OUTPUT${NC}\n"
