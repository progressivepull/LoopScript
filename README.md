# LoopScript

# Reference
## Pandoc
* [Pandoc Official Website](https://pandoc.org/)

``` bash
pandoc -t gfm --extract-media . "main.docx" -o main.md
```

## Microsoft Word Code Style
* [MS Word Create style for code snippet box  | Leon Renner | YouTube](https://www.youtube.com/watch?v=busnzKKSOxU)

---
# loop.sh

## 📦 Installation
Make the script executable:

``` bash
chmod +x loop.sh
```
Run it:

``` bash
./loop.sh help
```

## 📁 Folder Creation

Create a range of folders using a pattern:

``` bash
./loop.sh create -f <start> <end> '<pattern>'
```
Example:

``` bash
./loop.sh create -f 1 5 'PROBLEM_*'
```
Creates:

```
PROBLEM_1
PROBLEM_2
PROBLEM_3
PROBLEM_4
PROBLEM_5
```


## 🗑️ Deleting Files and Folders

All delete commands support dry‑run mode:

``` bash
--dry
```

### Delete a specific name everywhere

Deletes:

* <name>.md
* <name>_media/

``` bash
./loop.sh delete -s <name>
```
### Delete inside each PROBLEM_X directory

``` bash
./loop.sh delete -m
```
### Delete a folder
``` bash
./loop.sh delete -d <folder>
```

### Example dry‑run

``` bash
./loop.sh delete -s PROBLEM_3 --dry
```

## 🔄 Converting Documents

### Convert a single .docx file

``` bash
./loop.sh convert -s <file_name>
```

### Convert all .docx files recursively

``` bash
./loop.sh convert -m
```

Each .docx produces:

* <name>.md
* <name>_media/
  
## 📦 Move Files Into Matching Folders
Moves any file into a folder with the same base name:

``` bash
./loop.sh move
```
Example:

``` bash
notes.txt → notes/notes.txt
```

## 📊 Project Status
Scan the entire project for .md files and _media folders:

``` bash
./loop.sh status
```  

## 🧹 Clean (Safe Mode)
Lists everything that would be deleted:

``` bash
./loop.sh clean
```
This mode is non‑destructive.
Deletion lines are commented out in the script for safety.