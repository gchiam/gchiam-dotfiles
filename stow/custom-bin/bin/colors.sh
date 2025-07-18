#!/bin/bash
# Display 256-color terminal palette with customizable columns

# Display usage information
usage() {
    echo "Usage: $0 [COLUMNS]"
    echo "Display terminal 256-color palette"
    echo ""
    echo "Arguments:"
    echo "  COLUMNS        Number of columns to display (default: 8, max: 16)"
    echo ""
    echo "Options:"
    echo "  -h, --help     Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0             Display colors in 8 columns"
    echo "  $0 16          Display colors in 16 columns"
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            usage
            exit 0
            ;;
        -*)
            echo "Unknown option: $1" >&2
            usage >&2
            exit 1
            ;;
        *)
            break
            ;;
    esac
done

# Set default break value
BREAK=8

# Validate and set break value if provided
if [[ -n "$1" ]]; then
    if [[ "$1" =~ ^[0-9]+$ ]]; then
        if [[ "$1" -gt 0 && "$1" -le 16 ]]; then
            BREAK=$1
        else
            echo "Error: COLUMNS must be between 1 and 16" >&2
            exit 1
        fi
    else
        echo "Error: COLUMNS must be a positive integer" >&2
        exit 1
    fi
fi

# Display color palette
echo "Terminal 256-color palette (${BREAK} columns):"
echo ""

for i in {0..255}; do
    printf "\x1b[38;5;${i}mcolour${i}\x1b[0m"
    
    # Add padding for alignment
    if [[ $i -lt 10 ]]; then
        printf "   \t"
    elif [[ $i -lt 100 ]]; then
        printf "  \t"
    else
        printf " \t"
    fi
    
    # Add newline at break points
    if [[ $(( (i + 1) % BREAK )) -eq 0 ]]; then
        printf "\n"
    fi
done

# Add final newline if needed
if [[ $(( 256 % BREAK )) -ne 0 ]]; then
    printf "\n"
fi

echo ""
