#!/bin/bash

action=$1
flag=$2

if [[ "$action" == "create" ]]; then
    echo "Running create"

    if [[ "$flag" == "-f" ]]; then
        echo "Flag -f"
        start=$3
        end=$4
        pattern=$5

        if [[ -z "$start" || -z "$end" || -z "$pattern" ]]; then
            echo "Usage: $0 create [-f] <start> <end> <pattern>"
            exit 1
        fi

        if ! [[ "$start" =~ ^[0-9]+$ && "$end" =~ ^[0-9]+$ ]]; then
            echo "Error: start and end must be integers"
            exit 1
        fi

        if (( start > end )); then
            echo "Error: start must be <= end"
            exit 1
        fi

        for ((i=start; i<=end; i++)); do
            folder_name="${pattern//\*/$i}"
            mkdir -p "$folder_name"
            echo "Created: $folder_name"
        done
    fi
fi


if [[ "$action" == "delete" ]]; then
    echo "Running delete"

    filename="$2"   

    if [[ -z "$filename" ]]; then
        echo "Usage: $0 delete <filename>"
        exit 1
    fi

    if [[ -e "$filename" ]]; then
        rm "$filename"
        echo "Deleted $filename"
    else
        echo "$filename does not exist"
    fi
fi
