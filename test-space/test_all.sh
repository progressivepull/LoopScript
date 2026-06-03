#!/bin/bash

# Test directory
TEST_DIR="test-all"

echo "Preparing test environment: $TEST_DIR"
rm -rf "$TEST_DIR"
mkdir -p "$TEST_DIR"

# Copy test .docx files into test-all
cp PROBLEM_1.docx "$TEST_DIR/"
cp PROBLEM_2.docx "$TEST_DIR/"

echo "Copied test files:"
ls -1 "$TEST_DIR"

echo ""
echo "Running ALL pipeline inside $TEST_DIR"
echo "--------------------------------------"


(
    cd "$TEST_DIR" || exit
    loop.sh all
)

echo ""
echo "Final directory structure:"
echo "--------------------------------------"
tree "$TEST_DIR"
