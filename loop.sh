#!/bin/bash

action=$1
flag=$2

show_help() {
    echo ""
    echo "Usage:"
    echo "  loop.sh create -f <start> <end> '<pattern>'"
    echo "      Create folders by replacing * in the pattern with numbers."
    echo ""
    echo "  loop.sh delete <file1> [file2 ...]"
    echo "      Delete one or more files."
    echo ""
    echo "  loop.sh delete -d <folder>"
    echo "      Delete a folder."
    echo ""
    echo "  loop.sh convert -s <file_name>"
    echo "      Convert <file_name>.docx → <file_name>.md using pandoc."
    echo ""
    echo "  loop.sh convert -m"
    echo "      Convert ALL .docx files (recursively) to .md using pandoc."
    echo ""
    echo "  loop.sh move"
    echo "      Move files into folders with matching names (e.g., file.txt → file/)."
    echo ""
    echo "  loop.sh help"
    echo "      Show this help menu."
    echo ""
}



# HELP
if [[ "$action" == "help" || -z "$action" ]]; then
    show_help
    exit 0
fi

# CREATE
if [[ "$action" == "create" ]]; then
    echo "Running create"

    if [[ "$flag" == "-f" ]]; then
        echo "Flag -f"
        start=$3
        end=$4
        pattern=$5

        if [[ -z "$start" || -z "$end" || -z "$pattern" ]]; then
            echo "Usage: loop.sh create -f <start> <end> '<pattern>'"
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

# DELETE
if [[ "$action" == "delete" ]]; then
    echo "Running delete"

    # Delete folder mode
    if [[ "$flag" == "-d" ]]; then
        folder="$3"

        if [[ -z "$folder" ]]; then
            echo "Usage: loop.sh delete -d <folder>"
            exit 1
        fi

        if [[ -d "$folder" ]]; then
            rm -r "$folder"
            echo "Deleted folder: $folder"
        else
            echo "Folder '$folder' does not exist"
        fi

        exit 0
    fi

    # Delete multiple files
    shift 1  # remove "delete"
    if [[ $# -eq 0 ]]; then
        echo "Usage: loop.sh delete <file1> [file2 ...]"
        exit 1
    fi

    for file in "$@"; do
        if [[ -e "$file" ]]; then
            rm "$file"
            echo "Deleted file: $file"
        else
            echo "File '$file' does not exist"
        fi
    done
fi

# CONVERT
if [[ "$action" == "convert" ]]; then
    echo "Running convert"

    # Convert a single file
    if [[ "$flag" == "-s" ]]; then
        file="$3"

        if [[ -z "$file" ]]; then
            echo "Usage: loop.sh convert -s <file_name>"
            exit 1
        fi

        if [[ ! -f "${file}.docx" ]]; then
            echo "Error: ${file}.docx not found"
            exit 1
        fi

        pandoc -t gfm --extract-media . "${file}.docx" -o "${file}.md"
        echo "Converted ${file}.docx → ${file}.md"
        exit 0
    fi

    # Convert ALL .docx files in all folders
    if [[ "$flag" == "-m" ]]; then
    echo "Converting all .docx files..."

    shopt -s globstar nullglob
    docx_files=( **/*.docx )

    if [[ ${#docx_files[@]} -eq 0 ]]; then
        echo "No .docx files found."
        exit 1
    fi

    for f in "${docx_files[@]}"; do
        base="${f%.docx}"

        # Media folder: PROBLEM_1_media
        media_dir="${base}_media"

        # Convert with HTML image tags + custom media folder
        pandoc \
            --from=docx \
            --to=gfm \
            --extract-media="${media_dir}" \
            --wrap=none \
            "$f" -o "${base}.md"

        echo "Converted $f → ${base}.md"
        echo "Media extracted to: ${media_dir}/"
    done

    exit 0
    fi

    echo "Usage:"
    echo "  loop.sh convert -s <file_name>"
    echo "  loop.sh convert -m"
    exit 1
fi

# MOVE
if [[ "$action" == "move" ]]; then
    echo "Running move"

    shopt -s nullglob

    for file in *; do
        # Skip directories
        [[ -d "$file" ]] && continue

        base="${file%.*}"   # remove extension

        if [[ -d "$base" ]]; then
            echo "Moving '$file' → '$base/'"
            mv "$file" "$base/"
        fi
    done

    exit 0
fi
