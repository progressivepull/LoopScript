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
Pratice Command
```
$ mkdir FOLDER_CREATION

$ cd FOLDER_CREATION

$ ./loop.sh create -f 1 5 'PROBLEM_*'
Created: PROBLEM_1
Created: PROBLEM_2
Created: PROBLEM_3
Created: PROBLEM_4
Created: PROBLEM_5
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

Pratice Command
```
$ mkdir SPECIFIC_DELETE
$ cd SPECIFIC_DELETE
$ touch x.md
$ mkdir x_media
$ loop.sh delete -s x

