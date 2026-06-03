#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOOP_SCRIPT="$SCRIPT_DIR/../loop.sh"

# Load colors
source "$SCRIPT_DIR/../colors.sh"

# Test script for: loop.sh create -m
TEST_DIR="test_create_m"

echo -e "${MAGENTA}Running create -m test...${RESET}"
echo ""

# Reset test directory
rm -rf "$TEST_DIR"
mkdir "$TEST_DIR"
cd "$TEST_DIR" || exit

# Create sample files
echo "alpha content" > alpha.txt
echo "beta content"  > beta.md
echo "gamma content" > gamma.json

echo "Created sample files:"
ls -1
echo ""

# Run the command
echo "Running: create -m"
$LOOP_SCRIPT create -m
echo ""

echo "Checking results..."
echo ""

PASS=true

for name in alpha beta gamma; do
    if [[ -d "$name" ]]; then
        echo -e "${GREEN}✔ PASS:${RESET} folder '$name' exists"
    else
        echo -e "✘ ${RED}FAIL:${RESET} folder '$name' missing"
        PASS=false
    fi
done

echo ""
if [[ "$PASS" == true ]]; then
    echo -e "🎉 create -m test ${GREEN}PASSED!${RESET}"
else
    echo -e "❌ create -m test ${RED}FAILED.${RESET}"
fi

echo ""
echo "Test directory located at: $TEST_DIR/"
