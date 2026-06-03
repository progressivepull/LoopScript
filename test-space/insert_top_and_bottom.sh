#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOOP_SCRIPT="$SCRIPT_DIR/../loop.sh"

# Load colors
source "$SCRIPT_DIR/../colors.sh"

# test_insert_logic.sh
# Verifies folder name at top and README link at bottom

TEST_DIR="test_insert_results"

echo -e "${MAGENTA}Running Insert Logic Test...${RESET}"

# Reset test directory
rm -rf "$TEST_DIR"
mkdir "$TEST_DIR"
cd "$TEST_DIR" || exit

# 1. Setup: Create dummy folders and markdown files
mkdir -p "Folder_A" "Folder_B"
echo "Original content A" > "Folder_A/note.md"
echo "Original content B" > "Folder_B/info.md"

# 2. Run the dynamic insert logic (Assuming it's part of the 'all' action or a specific flag)
echo "Processing files..."
$LOOP_SCRIPT insert -d

echo ""
echo "Checking results..."
echo ""

PASS=true

for folder in "Folder_A" "Folder_B"; do
    file=$(ls $folder/*.md)
    
    # Check Top Line (Folder Name)
    header=$(head -n 1 "$file")
    if [[ "$header" == "# $folder" ]]; then
        echo -e "${GREEN}✔ PASS:${RESET} $file has correct header (# $folder)"
    else
        echo -e "✘ ${RED}FAIL:${RESET} $file header is: $header"
        PASS=false
    fi

    # Check Bottom Line (README Link)
    footer=$(tail -n 1 "$file")
    if [[ "$footer" == "./../../README.md" ]]; then
        echo -e "${GREEN}✔ PASS:${RESET} $file has correct README link"
    else
        echo -e "✘ ${RED}FAIL:${RESET} $file footer is: $footer"
        PASS=false
    fi
done

echo ""
if [[ "$PASS" == true ]]; then
    echo -e "🎉 Insert tests ${GREEN}PASSED!${RESET}"
else
    echo -e "❌ Insert tests ${RED}FAILED.${RESET}"
fi
 
