#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/colors.sh"

action=$1
flag=$2


show_help() {
    echo -e "${BLUE}Usage:${RESET}"
    echo -e "  ${CYAN}loop.sh${RESET} create -f <start> <end> '<pattern>'"
	echo -e "      ${RED}Wildcard matches characters, while script creates sequentially numbered folders using ranges and customizable naming patterns.${RESET}"
    echo -e ""
    echo -e "  ${CYAN}loop.sh${RESET} delete -s <name>"
    echo -e "      ${RED}Delete <name>.md and <name>_media in all directories.${RESET}"
    echo -e ""
    echo -e "  ${CYAN}loop.sh${RESET} delete -d <folder>"
    echo -e "      ${RED}Delete a folder.${RESET}"
    echo -e ""
    echo -e "  ${CYAN}loop.sh${RESET} delete ... --dry"
    echo -e "      ${RED}Show what WOULD be deleted (no changes).${RESET}"
    echo -e ""
    echo -e "  ${CYAN}loop.sh${RESET} status"
    echo -e "      ${RED}Show .md and _media files found in the project.${RESET}"
    echo -e ""
	echo -e "  ${CYAN}loop.sh${RESET} convert -s <file>"
	echo -e "      ${RED}Convert one .docx file into Markdown with extracted media files.${RESET}"
    echo -e ""
	echo -e "  ${CYAN}loop.sh${RESET} convert -m"
	echo -e "      ${RED}Convert all .docx files recursively into Markdown with separate media folders.${RESET}"
	echo -e ""
    echo -e "  ${CYAN}loop.sh${RESET} move"
	echo -e "      ${RED}Move files into matching folders with the same filename base automatically.${RESET}"
	echo -e ""
	echo -e "  ${CYAN}loop.sh${RESET} replace -m <old_text> <new_text>"
	echo -e "      ${RED}Replace matching text recursively inside all Markdown files in the project.${RESET}"
	echo -e ""
	echo -e "  ${CYAN}loop.sh${RESET} insert -t <text>"
	echo -e "      ${RED}Insert a line of text at the top of all Markdown files recursively.${RESET}"
	echo -e ""
	echo -e "  ${CYAN}loop.sh${RESET} insert -b <text>"
	echo -e "      ${RED}Append a line of text to the bottom of all Markdown files recursively.${RESET}"
	echo -e ""
    echo -e "  ${CYAN}loop.sh${RESET} help"
	echo -e "      ${RED}Display available commands, options, examples, and script usage information.${RESET}"
    echo -e ""
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

# ─────────────────────────────────────────────
# REPLACE
# ─────────────────────────────────────────────

# Check if the requested action is "replace"
if [[ "$action" == "replace" ]]; then

    # Check if the provided flag is "-m"
    # "-m" means replace text in multiple Markdown files
    if [[ "$flag" == "-m" ]]; then

        # Assign positional arguments:
        # $3 = text to search for
        # $4 = replacement text
        old="$3"
        new="$4"

        # Enable recursive globbing:
        # **/*.md searches all Markdown files recursively
        # nullglob prevents errors if no files match
        shopt -s globstar nullglob

        # Loop through all Markdown files
        for f in **/*.md; do

            # Replace all occurrences of old text with new text
            # -i edits the file directly
            # g = global replacement on each line
            sed -i "s/${old}/${new}/g" "$f"

            # Print colored confirmation message
            echo -e "${GREEN}Updated:${RESET} $f"
        done

        # Exit script successfully
        exit 0
    fi

    # Show usage message if arguments are invalid
    echo "Usage: loop.sh replace -m <old_text> <new_text>"
    exit 1
fi

# ─────────────────────────────────────────────
# INSERT
# ─────────────────────────────────────────────

# Check if the requested action is "insert"
if [[ "$action" == "insert" ]]; then

    # -------- TOP MODE (-t) --------
    # Add text to the top of all Markdown files
    if [[ "$flag" == "-t" ]]; then

        # $3 = text to insert
        text="$3"

        # Enable recursive globbing
        shopt -s globstar nullglob

        # Loop through all Markdown files
        for f in **/*.md; do

            # Create temporary file
            tmp=$(mktemp)

            # Write new text first
            echo "$text" > "$tmp"

            # Append original file content
            cat "$f" >> "$tmp"

            # Replace original file
            mv "$tmp" "$f"

            # Print confirmation message
            echo -e "${GREEN}Inserted at top:${RESET} $f"
        done

        exit 0
    fi

    # -------- BOTTOM MODE (-b) --------
    # Add text to the bottom of all Markdown files
    if [[ "$flag" == "-b" ]]; then

        # $3 = text to insert
        text="$3"

        # Enable recursive globbing
        shopt -s globstar nullglob

        # Loop through all Markdown files
        for f in **/*.md; do

            # Append text to end of file
            echo "$text" >> "$f"

            # Print confirmation message
            echo -e "${GREEN}Inserted at bottom:${RESET} $f"
        done

        exit 0
    fi

    # Invalid usage message
    echo "Usage: loop.sh insert -t <text> | -b <text>"
    exit 1
fi

# ─────────────────────────────────────────────
# ALL — Dynamic full‑pipeline automation
# ─────────────────────────────────────────────
if [[ "$action" == "all" ]]; then
    echo -e "${BLUE}Running ALL actions in sequence...${RESET}"

    # Read all file names (non-directories)
    shopt -s nullglob
    files=( * )

    echo -e "${CYAN}[1/9] CREATE — creating folders for each file${RESET}"
    for f in "${files[@]}"; do
        [[ -d "$f" ]] && continue   # skip directories
        base="${f%.*}"
        mkdir -p "$base"
        echo -e "${GREEN}Created:${RESET} $base"
    done

    echo -e "${CYAN}[2/9] DELETE -s — deleting matching .md and _media${RESET}"
    for f in "${files[@]}"; do
        [[ -d "$f" ]] && continue
        base="${f%.*}"
        ./loop.sh delete -s "$base"
    done

    echo -e "${CYAN}[3/9] DELETE -d — deleting empty folders named 'old'${RESET}"
    # Example: delete folder named "old" if exists
    [[ -d "old" ]] && ./loop.sh delete -d "old"

    echo -e "${CYAN}[4/9] STATUS — scanning project${RESET}"
    ./loop.sh status

    echo -e "${CYAN}[5/9] CONVERT -m — converting all .docx files${RESET}"
    ./loop.sh convert -m

    echo -e "${CYAN}[6/9] MOVE — moving files into matching folders${RESET}"
    ./loop.sh move

    echo -e "${CYAN}[7/9] REPLACE -m — replacing text in all Markdown files${RESET}"
    ./loop.sh replace -m "OLD_TEXT" "NEW_TEXT"

    echo -e "${CYAN}[8/9] INSERT -t — inserting text at top of all Markdown files${RESET}"
    ./loop.sh insert -t "Inserted at top"

    echo -e "${CYAN}[9/9] INSERT -b — inserting text at bottom of all Markdown files${RESET}"
    ./loop.sh insert -b "Inserted at bottom"

    echo -e "${GREEN}ALL actions completed.${RESET}"
    exit 0
fi
