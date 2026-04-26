#!/bin/bash

action=$1

# Usage: ./loop create 1 10 'QUESTIONS_NO_*'
if [[ "$action" == "create" ]]; then
    echo "Running 'create'"

    start=$2
    end=$3
    pattern=$4

    # Check inputs
    if [[ -z "$start" || -z "$end" || -z "$pattern" ]]; then
        echo "Usage: $0 create <start> <end> <pattern>"
        exit 1
    fi

    # Validate numbers
    if ! [[ "$start" =~ ^[0-9]+$ && "$end" =~ ^[0-9]+$ ]]; then
        echo "Error: start and end must be integers"
        exit 1
    fi

    if (( start > end )); then
        echo "Error: start must be <= end"
        exit 1
    fi

    # Loop and create folders
    for ((i=start; i<=end; i++)); do
        folder_name="${pattern//\*/$i}"
        mkdir -p "$folder_name"
        echo "Created: $folder_name"
    done

else
    echo "Invalid action: $action"
    echo "Usage: $0 create <start> <end> <pattern>"
    exit 1
fi

