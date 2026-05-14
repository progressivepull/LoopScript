#!/bin/bash

# project_status.sh
# Test script for: loop.sh status

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOOP_SCRIPT="$SCRIPT_DIR/../loop.sh"

# Source colors.sh from parent (LoopScript/)
source "$SCRIPT_DIR/../colors.sh"

TEST_DIR="test_project_status"

echo -e "${BLUE}Running test: project status${RESET}"
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
# RUN STATUS COMMAND
# ─────────────────────────────────────────────
echo "Running: loop.sh status"
STATUS_OUTPUT=$($LOOP_SCRIPT status)

echo "--------- STATUS OUTPUT ---------"
echo "${STATUS_OUTPUT}"
echo "---------------------------------"

echo ""
echo "Checking results..."
echo ""

PASS=true

# Check .md files
if echo "$STATUS_OUTPUT" | grep -q "A/file1.md"; then
    echo -e "${GREEN}✔ PASS:${RESET} A/file1.md detected"
else
    echo -e "${RED}✘ FAIL:${RESET} A/file1.md missing from status output"
    PASS=false
fi

if echo "$STATUS_OUTPUT" | grep -q "B/file2.md"; then
    echo -e "${GREEN}✔ PASS:${RESET} B/file2.md detected"
else
    echo -e "${RED}✘ FAIL:${RESET} B/file2.md missing from status output"
    PASS=false
fi

# Check _media folders
if echo "$STATUS_OUTPUT" | grep -q "A/file1_media"; then
    echo -e "${GREEN}✔ PASS:${RESET} A/file1_media detected"
else
    echo -e "${RED}✘ FAIL:${RESET} A/file1_media missing from status output"
    PASS=false
fi

if echo "$STATUS_OUTPUT" | grep -q "C/extra_media"; then
    echo -e "${GREEN}✔ PASS:${RESET} C/extra_media detected"
else
    echo -e "${RED}✘ FAIL:${RESET} C/extra_media missing from status output"
    PASS=false
fi

echo ""
if [[ "$PASS" == true ]]; then
    echo -e "🎉 All project status tests ${GREEN}PASSED!${RESET}"
else
    echo -e "❌ Some project status tests ${RED}FAILED.${RESET}"
fi

echo ""
echo "Test directory located at: $TEST_DIR/"
