# requirus 1 2022-07-25 "1.0.0"

## NAME
requirus \- command, entity, directory, file controller helper tool.

## SYNOPSIS
requirus [{-c|-e|-d|-f|-r|-o|-v|-h}] [{command|file|directory}]

## DESCRIPTION
easily check the requirements together, files, directories, commands for all.

## OPTIONS

### -c, --command [command] [command]..
check the commands required for the program to run.

### -e, --entity [file or directory] [file or directory]..
entity actually means a file or directory, 
use this option if you don't know what format the thing you are going to check is.

### -d, --directory [directory] [directory]..
check the needed directories.

### -f, --files [file] [file]..
check the needed files.

### -r, --require [option]
the require option is Indicates the exit status of the program,
if this option is needed, it returns 1, but if this value is optional, then it returns 0.

### -o, --output [option]
By default, only error outputs are displayed on the screen, 
but you can change this with the output property.
You can show both cases with **both** value,
show only existing data with **positive** or show only non-existent data with **negative**.

### -v, --version
show's current version of requirus.

### -h, --help
show's this helper text.

## BUGS
No known bugs.

## AUTHOR
Written by lazypwny751 for pnm linux.

source: **https://github.com/pnmlinux/requirus**