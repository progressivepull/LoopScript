#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOOP_SCRIPT="$SCRIPT_DIR/../loop.sh"

# Source colors.sh from parent (LoopScript/)
source "$SCRIPT_DIR/../colors.sh"

# folder_create.sh
# Test script for: loop.sh create -f <start> <end> '<pattern>'

TEST_DIR="test_folder_creation"
LOOP_SCRIPT="/C/Users/whwtb/Documents/WorkSpaces/LoopScript/loop.sh"

echo -e "${MAGENTA}Running folder creation test...${RESET}"
echo ""

# Create a clean test directory
rm -rf "$TEST_DIR"
mkdir "$TEST_DIR"
cd "$TEST_DIR" || exit

# Run the folder creation command
echo "Creating folders PROBLEM_1 to PROBLEM_5..."
$LOOP_SCRIPT create -f 1 5 "PROBLEM_*"

echo ""
echo "Checking results..."
echo ""

# Track results
PASS=true

for i in {1..5}; do
    folder="PROBLEM_$i"
    if [[ -d "$folder" ]]; then
        echo -e "${GREEN}✔ PASS:${RESET} $folder exists"
    else
        echo -e "✘ ${RED}FAIL:${RESET} $folder missing"
        PASS=false
    fi
done

echo ""
if [[ "$PASS" == true ]]; then
    echo -e "🎉 All folder creation tests ${GREEN}PASSED!${RESET}"
else
    echo -e "❌ Some folder creation tests ${RED}FAILED.${RESET}"
fi

echo ""
echo "Test directory located at: $TEST_DIR/"
