#!/bin/bash

# Test directory
TEST_DIR="test-undo"

echo "Running UNDO test inside $TEST_DIR"
echo "----------------------------------"

(
    cd "$TEST_DIR" || exit

    echo "[1/2] Running undo"
    loop.sh undo

    echo ""
    echo "[2/2] Final directory structure:"
)
