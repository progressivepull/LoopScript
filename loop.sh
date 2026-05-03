#!/bin/bash

# ─────────────────────────────────────────────
# COLOR SETUP
# ─────────────────────────────────────────────
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
RESET="\e[0m"

action=$1
flag=$2

show_help() {
    echo -e "${BLUE}Usage:${RESET}"
    echo "  loop.sh create -f <start> <end> '<pattern>'"
    echo ""
    echo "  loop.sh delete -s <name>"
    echo "      Delete <name>.md and <name>_media in all directories."
    echo ""
    echo "  loop.sh delete -m"
    echo "      For each PROBLEM_X directory, delete PROBLEM_X.md and PROBLEM_X_media."
    echo ""
    echo "  loop.sh delete -d <folder>"
    echo "      Delete a folder."
    echo ""
    echo "  loop.sh delete ... --dry"
    echo "      Show what WOULD be deleted (no changes)."
    echo ""
    echo "  loop.sh status"
    echo "      Show .md and _media files found in the project."
    echo ""
    echo "  loop.sh clean"
    echo "      SAFE MODE: Show everything that would be deleted recursively."
    echo "      (Deletion lines are commented out.)"
    echo ""
    echo "  loop.sh convert -s <file>"
    echo "  loop.sh convert -m"
    echo "  loop.sh move"
    echo "  loop.sh help"
    echo ""
}

# HELP
if [[ "$action" == "help" || -z "$action" ]]; then
    show_help
    exit 0
fi


# ─────────────────────────────────────────────
# CREATE
# ─────────────────────────────────────────────
if [[ "$action" == "create" ]]; then
    if [[ "$flag" == "-f" ]]; then
        start=$3
        end=$4
        pattern=$5

        for ((i=start; i<=end; i++)); do
            folder="${pattern//\*/$i}"
            mkdir -p "$folder"
            echo -e "${GREEN}Created:${RESET} $folder"
        done
    fi
fi


# ─────────────────────────────────────────────
# DELETE
# ─────────────────────────────────────────────
if [[ "$action" == "delete" ]]; then

    dry_run=false
    for arg in "$@"; do
        if [[ "$arg" == "--dry" ]]; then dry_run=true; fi
    done

    # DELETE FOLDER
    if [[ "$flag" == "-d" ]]; then
        folder="$3"

        if [[ "$dry_run" == true ]]; then
            echo -e "${YELLOW}[DRY] Would delete folder:${RESET} $folder"
            exit 0
        fi

        if [[ -d "$folder" ]]; then
            # rm -r "$folder"
            echo -e "${GREEN}Deleted folder:${RESET} $folder"
        else
            echo -e "${RED}Folder not found:${RESET} $folder"
        fi
        exit 0
    fi

    # DELETE SPECIFIC NAME ACROSS ALL DIRECTORIES
    if [[ "$flag" == "-s" ]]; then
	    echo -e "${BLUE} DELETE SPECIFIC NAME ACROSS ALL DIRECTORIES"
        name="$3"
        shopt -s globstar nullglob

        for dir in **/; do
            md="${dir}${name}.md"
            media="${dir}${name}_media"

            if [[ -f "$md" ]]; then
                if [[ "$dry_run" == true ]]; then
                    echo -e "${YELLOW}[DRY] Would delete:${RESET} $md"
                else
                    # rm "$md"
                    echo -e "${GREEN}Deleted:${RESET} $md"
                fi
            fi

            if [[ -d "$media" ]]; then
                if [[ "$dry_run" == true ]]; then
                    echo -e "${YELLOW}[DRY] Would delete:${RESET} $media"
                else
                    # rm -r "$media"
                    echo -e "${GREEN}Deleted:${RESET} $media"
                fi
            fi
        done

        exit 0
    fi

    # DELETE MODE FOR PROBLEM_X
    if [[ "$flag" == "-m" ]]; then
        for d in PROBLEM_*; do
            [[ ! -d "$d" ]] && continue

            md="${d}/${d}.md"
            media="${d}/${d}_media"

            if [[ -f "$md" ]]; then
                if [[ "$dry_run" == true ]]; then
                    echo -e "${YELLOW}[DRY] Would delete:${RESET} $md"
                else
                    # rm "$md"
                    echo -e "${GREEN}Deleted:${RESET} $md"
                fi
            fi

            if [[ -d "$media" ]]; then
                if [[ "$dry_run" == true ]]; then
                    echo -e "${YELLOW}[DRY] Would delete:${RESET} $media"
                else
                    # rm -r "$media"
                    echo -e "${GREEN}Deleted:${RESET} $media"
                fi
            fi
        done

        exit 0
    fi

    echo "Usage: loop.sh delete -s <name> | -m | -d <folder> [--dry]"
    exit 1
fi


# ─────────────────────────────────────────────
# STATUS
# ─────────────────────────────────────────────
if [[ "$action" == "status" ]]; then
    echo -e "${BLUE}Scanning project...${RESET}"
    shopt -s globstar nullglob

    echo -e "${GREEN}.md files:${RESET}"
    for f in **/*.md; do
        echo "  $f"
    done

    echo ""
    echo -e "${GREEN}_media folders:${RESET}"
    for d in **/*_media; do
        [[ -d "$d" ]] && echo "  $d"
    done

    exit 0
fi


# ─────────────────────────────────────────────
# CLEAN (SAFE MODE)
# ─────────────────────────────────────────────
if [[ "$action" == "clean" ]]; then
    echo -e "${YELLOW}SAFE CLEAN MODE — NO FILES WILL BE DELETED${RESET}"
    echo -e "${YELLOW}Delete lines are commented out in this script.${RESET}"
    echo ""

    shopt -s globstar nullglob

    for f in **/*.md; do
        echo -e "${YELLOW}[DRY] Would delete:${RESET} $f"
        # rm "$f"
    done

    for d in **/*_media; do
        if [[ -d "$d" ]]; then
            echo -e "${YELLOW}[DRY] Would delete:${RESET} $d"
            # rm -r "$d"
        fi
    done

    exit 0
fi


# ─────────────────────────────────────────────
# CONVERT
# ─────────────────────────────────────────────
if [[ "$action" == "convert" ]]; then

    if [[ "$flag" == "-s" ]]; then
        file="$3"
        if [[ ! -f "${file}.docx" ]]; then
            echo -e "${RED}Error:${RESET} ${file}.docx not found"
            exit 1
        fi

        pandoc -t gfm --extract-media . "${file}.docx" -o "${file}.md"
        echo -e "${GREEN}Converted:${RESET} ${file}.docx → ${file}.md"
        exit 0
    fi

    if [[ "$flag" == "-m" ]]; then
        shopt -s globstar nullglob
        docx_files=( **/*.docx )

        for f in "${docx_files[@]}"; do
            dir=$(dirname "$f")
            file=$(basename "$f")
            base="${file%.docx}"
            media="${base}_media"

            (
                cd "$dir" || exit
                pandoc --from=docx --to=gfm --extract-media="$media" --wrap=none "$file" -o "${base}.md"
            )

            echo -e "${GREEN}Converted:${RESET} $f → $dir/${base}.md"
        done

        exit 0
    fi

    echo "Usage: loop.sh convert -s <file> | -m"
    exit 1
fi


# ─────────────────────────────────────────────
# MOVE
# ─────────────────────────────────────────────
if [[ "$action" == "move" ]]; then
    shopt -s nullglob
    for file in *; do
        [[ -d "$file" ]] && continue
        base="${file%.*}"
        if [[ -d "$base" ]]; then
            mv "$file" "$base/"
            echo -e "${GREEN}Moved:${RESET} $file → $base/"
        fi
    done
    exit 0
fi
