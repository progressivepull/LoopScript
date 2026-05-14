#!/bin/bash

# clean_safe_mode.sh
# Test script for: loop.sh clean (SAFE MODE)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOOP_SCRIPT="$SCRIPT_DIR/../loop.sh"

# Source colors.sh from parent (LoopScript/)
source "$SCRIPT_DIR/../colors.sh"

TEST_DIR="test_clean_safe_mode"

echo "Running test: clean (safe mode)"
echo ""

# Reset test directory
rm -rf "$TEST_DIR"
mkdir "$TEST_DIR"
cd "$TEST_DIR" || exit

# ─────────────────────────────────────────────
# SETUP TEST STRUCTURE
# ─────────────────────────────────────────────
echo -e "${BLUE}Setting up test environment...${RESET}"

mkdir A B C

# Create .md files
echo "sample" > A/file1.md
echo "sample" > B/file2.md

# Create _media folders
mkdir A/file1_media
mkdir C/extra_media

echo -e "${MAGENTA}Environment ready.${RESET}"
echo ""

# ─────────────────────────────────────────────
# RUN CLEAN COMMAND
# ─────────────────────────────────────────────
echo "Running: loop.sh clean"
CLEAN_OUTPUT=$($LOOP_SCRIPT clean)

echo ""
echo "Checking results..."
echo ""

PASS=true

# Check .md files appear in output
if echo "$CLEAN_OUTPUT" | grep -q "A/file1.md"; then
    echo -e "${GREEN}✔ PASS:${RESET} A/file1.md listed"
else
    echo -e "${RED}✘ FAIL:${RESET} A/file1.md missing from clean output"
    PASS=false
fi

if echo "$CLEAN_OUTPUT" | grep -q "B/file2.md"; then
    echo -e "${GREEN}✔ PASS:${RESET} B/file2.md listed"
else
    echo -e "${RED}✘ FAIL:${RESET} B/file2.md missing from clean output"
    PASS=false
fi

# Check _media folders appear in output
if echo "$CLEAN_OUTPUT" | grep -q "A/file1_media"; then
    echo -e "${GREEN}✔ PASS:${RESET} A/file1_media listed"
else
    echo -e "${RED}✘ FAIL:${RESET} A/file1_media missing from clean output"
    PASS=false
fi

if echo "$CLEAN_OUTPUT" | grep -q "C/extra_media"; then
    echo -e "${GREEN}✔ PASS:${RESET} C/extra_media listed"
else
    echo -e "${RED}✘ FAIL:${RESET} C/extra_media missing from clean output"
    PASS=false
fi

# Ensure nothing was actually deleted
if [[ -f A/file1.md && -f B/file2.md && -d A/file1_media && -d C/extra_media ]]; then
    echo -e "${GREEN}✔ PASS:${RESET} No files were deleted (safe mode confirmed)"
else
    echo -e "${RED}✘ FAIL:${RESET} Some files were unexpectedly deleted"
    PASS=false
fi

echo ""
if [[ "$PASS" == true ]]; then
    echo -e "🎉 All clean (safe mode) tests ${GREEN}PASSED${RESET}!"
else
    echo -e "❌ Some clean (safe mode) tests ${RED}FAILED${RESET}."
fi

echo ""
echo "Test directory located at: $TEST_DIR/"
