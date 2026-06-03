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