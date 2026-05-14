#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/colors.sh"

action=$1
flag=$2


show_help() {
    echo -e "${BLUE}Usage:${RESET}"
    echo -e "  ${CYAN}loop.sh${RESET} create -f <start> <end> '<pattern>'"
    echo ""
    echo -e "  ${CYAN}loop.sh${RESET} delete -s <name>"
    echo "      Delete <name>.md and <name>_media in all directories."
    echo -e ""
    echo -e "  ${CYAN}loop.sh${RESET} delete -d <folder>"
    echo -e "      Delete a folder."
    echo ""
    echo -e "  ${CYAN}loop.sh${RESET} delete ... --dry"
    echo -e "      Show what WOULD be deleted (no changes)."
    echo ""
    echo -e "  ${CYAN}loop.sh${RESET} status"
    echo -e "      Show .md and _media files found in the project."
    echo ""
    echo -e "  ${CYAN}loop.sh${RESET} clean"
    echo -e "      SAFE MODE: Show everything that would be deleted recursively."
    echo -e "      (Deletion lines are commented out.)"
    echo ""
    echo -e "  ${CYAN}loop.sh${RESET} convert -s <file>"
    echo -e "  ${CYAN}loop.sh${RESET} convert -m"
    echo -e "  ${CYAN}loop.sh${RESET} move"
    echo -e "  ${CYAN}loop.sh${RESET} help"
    echo ""
}

# HELP

# Check if the action is set to "help" or if the action variable is empty
if [[ "$action" == "help" || -z "$action" ]]; then
    # Call the function that displays the script's usage and manual
    show_help
	# Terminate the script successfully after displaying help information
    exit 0
fi


# ─────────────────────────────────────────────
# CREATE
# ─────────────────────────────────────────────

# Check if the requested action is "create"
if [[ "$action" == "create" ]]; then


	# Check if the flag provided is "-f" (indicates folder creation with a range)
	if [[ "$flag" == "-f" ]]; then

		# Assign positional arguments:
		# $3 = start of range
		# $4 = end of range
		# $5 = folder name pattern (e.g., dir_*)
		start=$3
		end=$4
		pattern=$5

		# Loop from start to end (inclusive)
		for ((i=start; i<=end; i++)); do

			# Replace '*' in the pattern with the current number (i)
			# Example: dir_* → dir_1, dir_2, etc.
			folder="${pattern//\*/$i}"

			# Create the directory (and parent directories if needed)
			mkdir -p "$folder"

			# Print a colored confirmation message
			echo -e "${GREEN}Created:${RESET} $folder"
		done
	fi

fi



# ─────────────────────────────────────────────
# DELETE
# ─────────────────────────────────────────────
if [[ "$action" == "delete" ]]; then

	# Check all passed arguments for the "--dry" flag
	# If found, enable dry-run mode (no actual deletion will occur)

    dry_run=false
    for arg in "$@"; do
        if [[ "$arg" == "--dry" ]]; then dry_run=true; fi
    done

    # DELETE FOLDER logic (triggered when flag is "-d")
    if [[ "$flag" == "-d" ]]; then
	
	    # $3 is expected to be the folder name/path to delete
        folder="$3"

        # If dry-run is enabled, only show what would happen and exit
        if [[ "$dry_run" == true ]]; then
            echo -e "${YELLOW}[DRY] Would delete folder:${RESET} $folder"
            exit 0
        fi
		
		
	    # Check if the folder actually exists
        if [[ -d "$folder" ]]; then
		
		    if [[ "$dry_run" == false ]]; then
				rm -r "$folder"
			fi	
				
			# Confirm deletion to the user
            echo -e "${GREEN}Deleted folder:${RESET} $folder"
        else
		    
			# Handle case where folder does not exist
            echo -e "${RED}Folder not found:${RESET} $folder"
        fi
		# Exit after handling delete operation
        exit 0
    fi

	# Check if the flag argument matches "-s"
	if [[ "$flag" == "-s" ]]; then
		# Print a blue header message to the terminal
		echo -e "${BLUE} DELETE SPECIFIC NAME ACROSS ALL DIRECTORIES"
		# Assign the third script argument to the variable 'name'
		name="$3"
		# Enable recursive globbing (**) and ensure empty matches don't return the literal string
		shopt -s globstar nullglob

		# Loop through every directory and subdirectory in the current path
		for dir in **/; do
			# Define the target markdown file path
			md="${dir}${name}.md"
			# Define the target media folder path
			media="${dir}${name}_media"

			# Check if the target markdown file exists and is a regular file
			if [[ -f "$md" ]]; then
				# If dry_run is set, only print what would be deleted
				if [[ "$dry_run" == true ]]; then
					echo -e "${YELLOW}[DRY] Would delete:${RESET} $md"
				else
					# Force delete the markdown file and notify the user
					rm -f "$md"
					echo -e "${GREEN}Deleted:${RESET} $md"
				fi
			fi

			# Check if the target media directory exists
			if [[ -d "$media" ]]; then
				# If dry_run is set, only print what directory would be deleted
				if [[ "$dry_run" == true ]]; then
					echo -e "${YELLOW}[DRY] Would delete:${RESET} $media"
				else
					# Recursively delete the media directory and notify the user
					rm -rf "$media"
					echo -e "${GREEN}Deleted:${RESET} $media"
				fi
			fi
		done

		# Terminate the script successfully
		exit 0
	fi

    echo "Usage: loop.sh delete -s <name> | -d <folder> [--dry]"
    exit 1
fi


# ─────────────────────────────────────────────
# STATUS
# ─────────────────────────────────────────────
# Check if the action is "status"
if [[ "$action" == "status" ]]; then
    # Print message in blue color
    echo -e "${BLUE}Scanning project...${RESET}"

    # Enable recursive globbing (**)
    # and avoid errors if no files match
    shopt -s globstar nullglob

    # List all Markdown (.md) files
    echo -e "${GREEN}.md files:${RESET}"
    for f in **/*.md; do
        echo "  $f"
    done

    echo ""

    # List all directories ending with "_media"
    echo -e "${GREEN}_media folders:${RESET}"
    for d in **/*_media; do
        # Check if it's a directory before printing
        [[ -d "$d" ]] && echo "  $d"
    done

    # Exit script successfully
    exit 0
fi


# ─────────────────────────────────────────────
# CLEAN (SAFE MODE)
# ─────────────────────────────────────────────
# Check if the action is "clean"
if [[ "$action" == "clean" ]]; then
    # Inform user this is a safe (dry-run) mode
    echo -e "${YELLOW}SAFE CLEAN MODE — NO FILES WILL BE DELETED${RESET}"
    echo -e "${YELLOW}Delete lines are commented out in this script.${RESET}"
    echo ""

    # Enable recursive globbing and ignore non-matching patterns
    shopt -s globstar nullglob

    # Loop through all Markdown (.md) files
    for f in **/*.md; do
        # Show what would be deleted (dry run)
        echo -e "${YELLOW}[DRY] Would delete:${RESET} $f"
        # Actual delete command (disabled for safety)
        # rm "$f"
    done

    # Loop through all folders ending with "_media"
    for d in **/*_media; do
        # Ensure it's a directory
        if [[ -d "$d" ]]; then
            # Show what would be deleted (dry run)
            echo -e "${YELLOW}[DRY] Would delete:${RESET} $d"
            # Actual delete command (disabled for safety)
            # rm -r "$d"
        fi
    done

    # Exit script successfully
    exit 0
fi


# ─────────────────────────────────────────────
# CONVERT
# ─────────────────────────────────────────────
# Check if the action is "convert"
if [[ "$action" == "convert" ]]; then

    # -------- SINGLE FILE MODE (-s) --------
    if [[ "$flag" == "-s" ]]; then
        # Get filename (without extension) from argument
        file="$3"

        # Check if the .docx file exists
        if [[ ! -f "${file}.docx" ]]; then
            echo -e "${RED}Error:${RESET} ${file}.docx not found"
            exit 1
        fi

        # Convert .docx to Markdown (GitHub Flavored Markdown)
        # Extract images/media into current directory
        pandoc -t gfm --extract-media . "${file}.docx" -o "${file}.md"

        # Print success message
        echo -e "${GREEN}Converted:${RESET} ${file}.docx → ${file}.md"
        exit 0
    fi

    # -------- MULTIPLE FILES MODE (-m) --------
    if [[ "$flag" == "-m" ]]; then
        # Enable recursive globbing and ignore empty matches
        shopt -s globstar nullglob

        # Collect all .docx files in current directory and subdirectories
        docx_files=( **/*.docx )

        # Loop through each .docx file
        for f in "${docx_files[@]}"; do
            # Get directory path
            dir=$(dirname "$f")

            # Get filename only
            file=$(basename "$f")

            # Remove .docx extension
            base="${file%.docx}"

            # Define media folder name
            media="${base}_media"

            # Run conversion inside the file's directory
            (
                cd "$dir" || exit

                # Convert to Markdown with:
                # - GitHub Flavored Markdown
                # - Extract media into a separate folder
                # - No line wrapping
                pandoc --from=docx --to=gfm --extract-media="$media" --wrap=none "$file" -o "${base}.md"
            )

            # Print success message
            echo -e "${GREEN}Converted:${RESET} $f → $dir/${base}.md"
        done

        exit 0
    fi

    # -------- INVALID USAGE --------
    echo "Usage: loop.sh convert -s <file> | -m"
    exit 1
fi


# ─────────────────────────────────────────────
# MOVE
# ─────────────────────────────────────────────
# Check if the action is "move"
if [[ "$action" == "move" ]]; then
    # Ignore patterns that match nothing (prevents errors)
    shopt -s nullglob

    # Loop through all items in the current directory
    for file in *; do
        # Skip if it's a directory
        [[ -d "$file" ]] && continue

        # Get filename without extension
        base="${file%.*}"

        # Check if a directory with the same base name exists
        if [[ -d "$base" ]]; then
            # Move the file into that directory
            mv "$file" "$base/"

            # Print confirmation message
            echo -e "${GREEN}Moved:${RESET} $file → $base/"
        fi
    done

    # Exit script successfully
    exit 0
fi
