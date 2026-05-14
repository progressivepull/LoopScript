#!/bin/bash

# deleting_files_and_folders.sh
# Test script for: loop.sh delete -s, -m, -d (safe and isolated)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOOP_SCRIPT="$SCRIPT_DIR/../loop.sh"

# Source colors.sh from parent (LoopScript/)
source "$SCRIPT_DIR/../colors.sh"

TEST_DIR="test_deleting_files_and_folders"

action=$1

select_menu() {
echo -e "${BLUE}Select the test you want to run:${RESET}"
echo -e "${CYAN}1${RESET}) delete -s target"
echo -e "${CYAN}2${RESET}) delete -d DELETE_ME"
}

echo -e "${MAGENTA} Running deletion tests... ${RESET}"
echo ""

# Reset test directory
rm -rf "$TEST_DIR"
mkdir "$TEST_DIR"
cd "$TEST_DIR" || exit

# ─────────────────────────────────────────────
# SETUP TEST STRUCTURE
# ─────────────────────────────────────────────
echo -e "${BLUE}Setting up test environment...${RESET}"
mkdir PROBLEM_1 PROBLEM_2

# Files for -s test
echo "sample" > PROBLEM_1/target.md
mkdir PROBLEM_1/target_media

echo "sample" > PROBLEM_2/target.md
mkdir PROBLEM_2/target_media


# Folder for -d test
mkdir DELETE_ME

echo "Environment ready."
echo ""

# ─────────────────────────────────────────────
# TEST 1: delete -s target
# ─────────────────────────────────────────────

if [[ "$action" == "1" ]]; then
	echo -e "${BLUE} TEST 1: ${RESET} delete -s target"
	echo "Current directory: $PWD"
	echo ""
	echo ""

	"$LOOP_SCRIPT" delete -s target

	echo ""
	echo "Checking results..."

	check_target() {
		local dir="$1"
		
		if [[ ! -f "$dir/target.md" && ! -d "$dir/target_media" ]]; then
			echo -e "${GREEN} ✔ PASS:${RESET} $dir target files removed ${RESET}"
		else
			echo -e "${RED} ✘ FAIL:${RESET} $dir target files still exist ${RESET}"
		fi
	}

	check_target "PROBLEM_1"
	check_target "PROBLEM_2"

	echo ""

fi

# ─────────────────────────────────────────────
# TEST 2: delete -d DELETE_ME
# ─────────────────────────────────────────────

if [[ "$action" == "2" ]]; then
	echo "TEST 2: delete -d DELETE_ME"
	$LOOP_SCRIPT delete -d DELETE_ME

	echo ""
	echo "Checking results..."

	if [[ ! -d DELETE_ME ]]; then
		echo  -e "${GREEN} ✔ PASS:${RESET} DELETE_ME folder removed"
	else
		echo  -e "${RED}✘ FAIL:${RESET} DELETE_ME folder still exists"
	fi

	echo ""

	echo "All deletion tests completed."
	echo "Test directory located at: $TEST_DIR/"
fi

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