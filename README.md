# **loop.sh — Multi‑Tool Project Automation Script**

loop.sh is a flexible ``` bash automation utility designed to streamline
project‑wide tasks such as creating folders, converting .docx files,
moving files, replacing text, inserting content, and cleaning up
Markdown‑based projects.

It supports **recursive operations**, **dry‑run safety**, **colored
output**, and **pattern‑based folder generation**.

# **🚀 Features**

- **Create** folders (pattern‑based or mirrored from filenames)

- **Delete** files or folders (with optional --dry)

- **Convert** .docx → .md (single or recursive)

- **Move** files into matching folders

- **Replace** text across Markdown files

- **Insert** text at top/bottom or dynamic folder‑based insertion

- **Status** scan of Markdown + media folders

- **Undo**: restore .docx files and remove folders

- **All**: run a full automated pipeline

- **Help** menu with full usage instructions

# **📦 Requirements**

- **bash 4+**

- **[Pandoc](https://pandoc.org/)**  (for .docx → .md conversion)

- colors.sh in the same directory

# **📘 Usage Overview**

``` bash
loop.sh <action> <flag> [arguments]
```

Run:

``` bash
loop.sh help
```

to display the full help menu.

# **🧱 Commands**

**1. 📁 Create Folders**

**Pattern‑based sequential folders**

``` bash
loop.sh create -f <start> <end> '<pattern>'
```

Example:

``` bash
loop.sh create -f 1 5 'chapter_*'
```

Creates:


Code
``` 
chapter_1
chapter_2
chapter_3
chapter_4
chapter_5
```

**Mirror filenames into folders**

Creates a folder for each file (ignores directories):

``` bash
loop.sh create -m
```

Example directory:

Code
```
alpha.txt
beta.md
gamma.json
```

Produces:

Code
```
alpha
beta
gamma
```

**2. 🗑️ Delete Files or Folders**

**Delete a folder**

``` bash
loop.sh delete -d <folder>
```

**Delete \<name\>.md and \<name\>\_media everywhere**

``` bash
loop.sh delete -s <name>
```

**Dry‑run mode**

``` bash
loop.sh delete -d <folder> --dry

loop.sh delete -s <name> --dry
```

**3. 📊 Status Scan**

List all Markdown files and \_media directories:

``` bash
loop.sh status
```

**4. 🔄 Convert .docx → .md**

**Convert a single file**

``` bash

loop.sh convert -s <filename>
```

Converts:

Code
```
filename.docx → filename.md
```

**Convert all .docx files recursively**

``` bash
loop.sh convert -m
```

Each file gets its own \<name\>\_media folder.

**5. 📦 Move Files Into Matching Folders**

Moves any file into a folder with the same base name:

``` bash
loop.sh move
```

Example:

Code
```
notes.md → notes/notes.md
```

**6. ✏️ Replace Text in Markdown Files**

Recursively replace text in all .md files:

``` bash
loop.sh replace -m <old_text> <new_text>
```

**7. ➕ Insert Text Into Markdown Files**

**Insert at top**

``` bash
loop.sh insert -t "<text>"
```

**Insert at bottom**

``` bash
loop.sh insert -b "<text>"
```

**Dynamic Insert (folder name at top + README link at bottom)**

*(This feature exists in the script but was missing from your Markdown)*

``` bash
loop.sh insert -d
```

This performs:

- Adds \# \<Folder Name\> at the top

- Appends a README link at the bottom

**8. 🔁 ALL — Full Automation Pipeline**

Runs a full sequence:

1.  Create folders for each file

2.  Move files into matching folders

3.  Convert all .docx files

4.  Insert dynamic headers/footers

``` bash
loop.sh all
```

**9. ⏪ UNDO — Restore .docx Files and Remove Folders**

Moves .docx files back to the parent directory, then deletes the
folders:

``` bash
loop.sh undo
```

Dry‑run:

``` bash
loop.sh undo --dry
```

# **🧩 File Structure Example**

Code
```
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
```

# **🛡️ Safety Notes**

- --dry mode available for delete and undo operations

- Recursive operations use globstar + nullglob

- Script prints colored confirmations for every action

# **📄 License**

This script is free to use, modify, and integrate into your workflow.
