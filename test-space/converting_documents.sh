#!/bin/bash

# converting_documents.sh
# Test script for: loop.sh convert -s and -m

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOOP_SCRIPT="$SCRIPT_DIR/../loop.sh"

# Source colors.sh from parent (LoopScript/)
source "$SCRIPT_DIR/../colors.sh"

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

mkdir single many many/PROBLEM_1 many/PROBLEM_2

cp "$SCRIPT_DIR/test-files/single.docx" "single/single.docx"
cp "$SCRIPT_DIR/test-files/PROBLEM_1.docx" "many/PROBLEM_1/PROBLEM_1.docx"
cp "$SCRIPT_DIR/test-files/PROBLEM_2.docx" "many/PROBLEM_2/PROBLEM_2.docx"


echo -e "${MAGENTA}Environment ready.${RESET}"
echo ""

# ─────────────────────────────────────────────
# TEST 1: convert -s sample
# ─────────────────────────────────────────────

if [[ "$action" == "1" ]]; then

	echo "TEST 1: convert -s single"
	
	cd "$SCRIPT_DIR/$TEST_DIR/single"

	$LOOP_SCRIPT convert -s single

	echo ""
	echo "Checking results..."
	
	PASS=true

	if [[ -f single.md ]]; then
		echo -e "${GREEN} ✔ PASS:${RESET} single.md created"
	else
		echo -e "${RED}✘ FAIL:${RESET} single.md missing"
		PASS=false
	fi
	
	if [[ -f media/image1.png ]]; then
		echo -e "${GREEN} ✔ PASS:${RESET} media/image1.png created"
	else
		echo -e "${RED}✘ FAIL:${RESET} media/image1.png missing"
		PASS=false
	fi
fi

# ─────────────────────────────────────────────
# TEST 2: convert -m (recursive)
# ─────────────────────────────────────────────

if [[ "$action" == "2" ]]; then
	echo "TEST 2: convert -m"
	
	cd "$SCRIPT_DIR/$TEST_DIR/many"
	
	$LOOP_SCRIPT convert -m
	
	echo ""
	echo "Checking results..."
	
	PASS=true

	if [[ -f PROBLEM_1/PROBLEM_1.md ]]; then
		echo -e "${GREEN} ✔ PASS:${RESET} PROBLEM_1/PROBLEM_1.md created"
	else
		echo -e "${RED}✘ FAIL:${RESET} PROBLEM_1/PROBLEM_1.md missing"
		PASS=false
	fi
	
		if [[ -f PROBLEM_1/PROBLEM_1_media/media/image1.png ]]; then
		echo -e "${GREEN} ✔ PASS:${RESET} PROBLEM_1/PROBLEM_1_media/media/image1.png created"
	else
		echo -e "${RED}✘ FAIL:${RESET} PROBLEM_1/PROBLEM_1_media/media/image1.png missing"
		PASS=false
	fi
	
		if [[ -f PROBLEM_2/PROBLEM_2.md ]]; then
		echo -e "${GREEN} ✔ PASS:${RESET} PROBLEM_2/PROBLEM_2.md created"
	else
		echo -e "${RED}✘ FAIL:${RESET} PROBLEM_2/PROBLEM_2.md missing"
		PASS=false
	fi
	
		if [[ -f PROBLEM_2/PROBLEM_2_media/media/image1.png ]]; then
		echo -e "${GREEN} ✔ PASS:${RESET} PROBLEM_2/PROBLEM_2_media/media/image1.png created"
	else
		echo -e "${RED}✘ FAIL:${RESET} PROBLEM_2/PROBLEM_2_media/media/image1.png missing"
		PASS=false
	fi
	
fi

# ─────────────────────────────────────────────
# FINAL RESULT
# ─────────────────────────────────────────────
if [[ "$action" == "1" || "$action" == "2" ]]; then

	if [[ "$PASS" == true ]]; then
		echo -e "🎉 All convert tests ${GREEN}PASSED!${RESET}"
	else
		echo -e "❌ Some convert tests ${RED}FAILED.${RESET}"
	fi
	
	echo ""
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