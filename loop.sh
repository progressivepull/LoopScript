#!/bin/bash

action=$1
flag=$2



if [[ "$action" == "create" ]]; then
    echo "Running create"

    # If -f is present, shift arguments
	# Usage:
	#  loop create -f 1 10 'QUESTIONS_NO_*'
    if [[ "$flag" == "-f" ]]; then
	    echo "Flag -f"
        start=$3
        end=$4
        pattern=$5
		
		# Check inputs
		if [[ -z "$start" || -z "$end" || -z "$pattern" ]]; then
			echo "Usage: $0 create [-f] <start> <end> <pattern>"
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



	fi

  
fi
