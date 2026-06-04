#!/bin/bash

# Test directory
TEST_DIR="test-undo"

echo "Preparing test environment: $TEST_DIR"
rm -rf "$TEST_DIR"
mkdir -p "$TEST_DIR"

# Copy test .docx files into test-undo
cp "test-files/PROBLEM_1.docx" "$TEST_DIR/"
cp "test-files/PROBLEM_2.docx" "$TEST_DIR/"

echo "Copied test files:"
ls -1 "$TEST_DIR"

echo ""
echo "Creating folders and moving .docx files inside them"
echo "---------------------------------------------------"

(
    cd "$TEST_DIR" || exit

    # Create folders
    mkdir PROBLEM_1
    mkdir PROBLEM_2

    # Move .docx files into their folders
    mv PROBLEM_1.docx PROBLEM_1/
    mv PROBLEM_2.docx PROBLEM_2/

    echo "Folder structure prepared:"
)
