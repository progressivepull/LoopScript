**loop.sh — Multi‑Tool Project Automation Script**

loop.sh is a flexible Bash automation utility designed to streamline
repetitive project‑wide tasks such as creating folders, converting .docx
files, moving files, replacing text, inserting content, and cleaning up
Markdown‑based projects.

It supports **recursive operations**, **dry‑run safety**, **colored
output**, and **pattern‑based folder generation**.

**🚀 Features**

- **Create** sequentially numbered folders using patterns

- **Delete** files or folders (with optional --dry mode)

- **Convert** .docx → .md (single or recursive) using Pandoc

- **Move** files into matching folders automatically

- **Replace** text across all Markdown files

- **Insert** text at the top or bottom of Markdown files

- **Status** scan of all .md and \_media directories

- **Help** menu with full usage instructions

**📦 Requirements**

- **Bash 4+**

- **Pandoc** (for .docx → .md conversion)

- colors.sh file in the same directory (provides ANSI color variables)

**📘 Usage Overview**

Code

loop.sh \<action\> \<flag\> \[arguments\]

Run loop.sh help at any time to display the full help menu.

**🧱 Commands**

**1. 📁 Create Folders**

Create sequentially numbered folders using a wildcard pattern:

Code

loop.sh create -f \<start\> \<end\> '\<pattern\>'

Example:

Code

loop.sh create -f 1 5 'chapter\_\*'

Creates:

Code

chapter_1/

chapter_2/

chapter_3/

chapter_4/

chapter_5/

**2. 🗑️ Delete Files or Folders**

**Delete a folder:**

Code

loop.sh delete -d \<folder\>

**Delete \<name\>.md and \<name\>\_media everywhere:**

Code

loop.sh delete -s \<name\>

**Dry‑run mode (no changes):**

Code

loop.sh delete -s \<name\> --dry

loop.sh delete -d \<folder\> --dry

**3. 📊 Status Scan**

List all Markdown files and \_media directories:

Code

loop.sh status

**4. 🔄 Convert .docx → .md**

**Convert a single file:**

Code

loop.sh convert -s \<filename\>

Converts:

Code

filename.docx → filename.md

**Convert all .docx files recursively:**

Code

loop.sh convert -m

Each file gets its own \<name\>\_media folder.

**5. 📦 Move Files Into Matching Folders**

Moves any file into a folder with the same base name:

Code

loop.sh move

Example:

Code

notes.md → notes/notes.md

**6. ✏️ Replace Text in Markdown Files**

Recursively replace text in all .md files:

Code

loop.sh replace -m \<old_text\> \<new_text\>

**7. ➕ Insert Text Into Markdown Files**

**Insert at top:**

Code

loop.sh insert -t "\<text\>"

**Insert at bottom:**

Code

loop.sh insert -b "\<text\>"

**🧩 File Structure Example**

Code

project/

│

├── loop.sh

├── colors.sh

├── chapter_1/

│ ├── notes.md

│ └── notes_media/

│

├── chapter_2/

│ └── ...

└── report.docx

**🛡️ Safety Notes**

- --dry mode is available for delete operations

- Recursive operations use globstar and nullglob to avoid errors

- Script prints colored confirmations for every action

**📄 License**

This script is free to use, modify, and integrate into your own
workflow.
