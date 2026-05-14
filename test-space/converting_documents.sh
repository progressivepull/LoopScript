#!/bin/bash

# converting_documents.sh
# Test script for: loop.sh convert -s and -m

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOOP_SCRIPT="$SCRIPT_DIR/../loop.sh"

TEST_DIR="test_converting_documents"

action=$1

select_menu() {
echo -e "${BLUE}Select the test you want to run:${RESET}"
echo -e "${CYAN}1${RESET}) convert -s sample"
echo -e "${CYAN}2${RESET}) convert -m (recursive)"
}

echo -e "${BLUE}Running test: converting documents${RESET}"
echo ""

# Reset test directory
rm -rf "$TEST_DIR"
mkdir "$TEST_DIR"
cd "$TEST_DIR" || exit

# ─────────────────────────────────────────────
# SETUP TEST STRUCTURE
# ─────────────────────────────────────────────
echo -e "${BLUE}Setting up test environment...${RESET}"

mkdir A B

# Create fake .docx files (pandoc requires real files, so we create minimal valid ZIP containers)
echo "PK" > A/sample.docx
echo "PK" > B/another.docx

echo -e "${MAGENTA}Environment ready.${RESET}"
echo ""

# ─────────────────────────────────────────────
# TEST 1: convert -s sample
# ─────────────────────────────────────────────

if [[ "$action" == "1" ]]; then

	echo "TEST 1: convert -s sample"
	$LOOP_SCRIPT convert -s A/sample

	echo ""
	echo "Checking results..."

	PASS=true

	if [[ -f A/sample.md ]]; then
		echo -e "${GREEN} ✔ PASS:${RESET} sample.md created"
	else
		echo -e "${RED}✘ FAIL:${RESET} sample.md missing"
		PASS=false
	fi

	if [[ -d A/sample_media ]]; then
		echo -e "${GREEN} ✔ PASS:${RESET} sample_media folder created"
	else
		echo -e "${RED}✘ FAIL:${RESET} sample_media missing"
		PASS=false
	fi

	echo ""
fi

# ─────────────────────────────────────────────
# TEST 2: convert -m (recursive)
# ─────────────────────────────────────────────

if [[ "$action" == "2" ]]; then
	echo "TEST 2: convert -m"
	$LOOP_SCRIPT convert -m

	echo ""
	echo "Checking results..."

	if [[ -f B/another.md ]]; then
		echo -e "${GREEN} ✔ PASS:${RESET} another.md created"
	else
		echo -e "${RED}✘ FAIL:${RESET} another.md missing"
		PASS=false
	fi

	if [[ -d B/another_media ]]; then
		echo -e "${GREEN} ✔ PASS:${RESET} another_media folder created"
	else
		echo -e "${RED}✘ FAIL:${RESET} another_media missing"
		PASS=false
	fi

	echo ""
fi

# ─────────────────────────────────────────────
# FINAL RESULT
# ─────────────────────────────────────────────
if [[ "$PASS" == true ]]; then
    echo -e "🎉 All convert tests ${GREEN}PASSED!${RESET}"
else
    echo -e "❌ Some convert tests ${RED}FAILED.${RESET}"
fi

echo ""
echo "Test directory located at: $TEST_DIR/"

# Check if an argument was provided
if [ -z "$1" ]; then
    echo "No number provided as argument."
	select_menu
    exit 1
fi

# Check if the argument is a number
if ! [[ "$1" =~ ^[0-9]+$ ]]; then
    echo "Argument must be a number."
	select_menu
    exit 1
fi