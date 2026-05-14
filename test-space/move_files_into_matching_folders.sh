#!/bin/bash

# move_files_into_matching_folders.sh
# Test script for: loop.sh move

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOOP_SCRIPT="$SCRIPT_DIR/../loop.sh"

# Source colors.sh from parent (LoopScript/)
source "$SCRIPT_DIR/../colors.sh"

TEST_DIR="test_move_files_into_matching_folders"

echo -e "${BLUE}Running test: move files into matching folders${RESET}"
echo ""

# Reset test directory
rm -rf "$TEST_DIR"
mkdir "$TEST_DIR"
cd "$TEST_DIR" || exit

# ─────────────────────────────────────────────
# SETUP TEST STRUCTURE
# ─────────────────────────────────────────────
echo -e "${BLUE}Setting up test environment...${RESET}"

# Matching folders
mkdir fileA fileB fileC

# Files that SHOULD be moved
echo "data" > fileA.txt
echo "data" > fileB.md
echo "data" > fileC.docx

# Files that should NOT be moved
echo "data" > unmatched.txt
mkdir random_folder

echo -e "${MAGENTA}Environment ready.${RESET}"
echo ""

# ─────────────────────────────────────────────
# RUN MOVE COMMAND
# ─────────────────────────────────────────────
echo "Running: loop.sh move"
$LOOP_SCRIPT move

echo ""
echo "Checking results..."
echo ""

PASS=true

# Check moved files
if [[ -f fileA/fileA.txt ]]; then
    echo -e "${GREEN}✔ PASS:${RESET} fileA.txt moved correctly"
else
    echo -e "${RED}✘ FAIL:${RESET} fileA.txt not moved"
    PASS=false
fi

if [[ -f fileB/fileB.md ]]; then
    echo -e "${GREEN}✔ PASS:${RESET} fileB.md moved correctly"
else
    echo -e "${RED}✘ FAIL:${RESET} fileB.md not moved"
    PASS=false
fi

if [[ -f fileC/fileC.docx ]]; then
    echo -e "${GREEN}✔ PASS:${RESET} fileC.docx moved correctly"
else
    echo -e "${RED}✘ FAIL:${RESET} fileC.docx not moved"
    PASS=false
fi

# Check files that should NOT be moved
if [[ -f unmatched.txt ]]; then
    echo -e "${GREEN}✔ PASS:${RESET} unmatched.txt correctly left in place"
else
    echo -e "${RED}✘ FAIL:${RESET} unmatched.txt was moved incorrectly"
    PASS=false
fi

echo ""

# ─────────────────────────────────────────────
# FINAL RESULT
# ─────────────────────────────────────────────
if [[ "$PASS" == true ]]; then
    echo -e "🎉 All move tests ${GREEN}PASSED!${RESET}"
else
    echo -e "❌ Some move tests ${RED}FAILED.${RESET}"
fi

echo ""
echo "Test directory located at: $TEST_DIR/"
