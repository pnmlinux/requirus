#!/bin/bash

#    requirement helper tool for scripts and programs - requirus
#    Copyright (C) 2022  lazypwny751
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <https://www.gnu.org/licenses/>.

# TODO:
#   check base:
#       check if debian, arch, fedora, opensuse.
#
#   command not found handler: 
#       add call package feature using curl with https://command-not-found.com.
#
#   check command via base:
#       check commands against base system.
#
#   is hash: (require: sha256sum)
#       check if the hash value matches.
#
#   export as json:
#       check if exists that command and if not export any json file format.
#
#   improvements in output.
#   librarise the tool.

# Variables
export CWD="${PWD}"
export tab="$(printf '\t')"
export REQUIRELEVEL="needed" OUTPUT="negative" requirusver="1.0.0" status="true" command=() file=() directory=() entity=()

# Colors
export reset='\033[0m'           # Reset
export red='\033[0;31m'          # Red
export green='\033[0;32m'        # Green
export yellow='\033[0;33m'       # Yellow
export blue='\033[0;34m'         # Blue

# Parse arguments
while [[ "${#}" -gt 0 ]] ; do
    case "${1}" in
        --[cC][oO][mM][mM][aA][nN][dD]|-[cC])
            shift
            if [[ -n "${1}" ]] ; then
                while [[ "${#}" -gt 0 ]] ; do
                    case "${1}" in
                        --*|-*)
                            break
                        ;;
                        *)
                            export command+=("${1}")
                            shift
                        ;;
                    esac
                done
            fi
        ;;
        --[eE][nN][tT][iI][tT][yY]|-[eE)
            shift
            if [[ -n "${1}" ]] ; then
                while [[ "${#}" -gt 0 ]] ; do
                    case "${1}" in
                        --*|-*)
                            break
                        ;;
                        *)
                            export entity+=("${1}")
                            shift
                        ;;
                    esac
                done
            fi
        ;;
        --[dD][iI][rR][eE][cC][tT][oO][rR][yY]|-[dD])
            shift
            if [[ -n "${1}" ]] ; then
                while [[ "${#}" -gt 0 ]] ; do
                    case "${1}" in
                        --*|-*)
                            break
                        ;;
                        *)
                            export directory+=("${1}")
                            shift
                        ;;
                    esac
                done
            fi
        ;;
        --[fF][iI][lL][eE]|-[fF])
            shift
            if [[ -n "${1}" ]] ; then
                while [[ "${#}" -gt 0 ]] ; do
                    case "${1}" in
                        --*|-*)
                            break
                        ;;
                        *)
                            export file+=("${1}")
                            shift
                        ;;
                    esac
                done
            fi
        ;;
        --[rR][eE][qQ][uU][iI][rR][eE]|-[rR])
            shift
            if [[ -n "${1}" ]] ; then
                case "${1}" in
                    [nN][eE][eE][dD][eE][dD]|[rR][eE][qQ][uU][iI][rR][eE][dD])
                        export REQUIRELEVEL="needed"
                    ;;
                    [oO][pP][tT][iI][oO][nN][aA][lL])
                        export REQUIRELEVEL="optional"
                    ;;
                esac
                shift
            fi
        ;;
        --[oO][uU][tT][pP][uU][tT]|-[oO])
            shift
            if [[ -n "${1}" ]] ; then
                case "${1}" in
                    [bB][oO][tT][hH])
                        export OUTPUT="both"
                    ;;
                    [pP][sS][iI][tT][iI][vV][eE])
                        export OUTPUT="positive"
                    ;;
                    [nN][eE][gG][aA][tT][iI][vV][eE])
                        export OUTPUT="negative"
                    ;;
                esac
                shift
            fi
        ;;
        --[vV][eE][rR][sS][iI][oO][nN]|-[vV])
            export DO="version"
            shift
        ;;
        --[hH][eE][lL][pP]|-[hH])
            export DO="help"
            shift
        ;;
        *)
            shift
        ;;
    esac
done

# Main
if [[ "${DO}" = "version" ]] ; then
    echo "${requirusver}"
elif [[ "${DO}" = "help" ]] ; then
    cat <<HELP
${0##*/} ${requirusver}

There are 8 flags for ${0##*/}:
${tab}-c, --command [command] [command]..
${tab}${tab}check the commands required for the program to run.

${tab}-e, --entity [file or directory] [file or directory]..
${tab}${tab}entity  actually  means  a file or directory, use this option if you don't know what format the thing you are going to check is.

${tab}-d, --directory [directory] [directory]..
${tab}${tab}check the needed directories.

${tab}-f, --files [file] [file]..
${tab}${tab}check the needed files.

${tab}-r, --require [option]
${tab}${tab}the require option is Indicates the exit status of the program,
${tab}${tab}if this option is needed, it returns 1, but if this value is optional, then it returns 0.

${tab}-o, --output [option]
${tab}${tab}By  default,  only error outputs are displayed on the screen, 
${tab}${tab}but you can change this with the output property. You can show both cases with both value,
${tab}${tab}show only existing data with positive or show only non-existent data with negative.

${tab}-v, --version
${tab}${tab}show's current version of requirus.

${tab}-h, --help
${tab}${tab}show's this helper text.

26.07.2022, pnm team - lazypwny751
HELP
else
    # command
    if [[ -n "${command[@]}" ]] ; then
        for i in ${command[@]} ; do
            if command -v "${i}" &> /dev/null ; then
                if [[ "${OUTPUT}" = "both" ]] || [[ "${OUTPUT}" = "positive" ]] ; then
                    echo -e "\t${green}=>${reset} command:   ${blue}${i}${reset} found."
                fi
            else
                if [[ "${OUTPUT}" = "both" ]] || [[ "${OUTPUT}" = "negative" ]] ; then
                    echo -e "\t${red}=>${reset} command:   ${yellow}${i}${reset} not found."
                    [[ "${status}" != "false" ]] && export status="false"
                fi
            fi
        done
    fi

    # entity
    if [[ -n "${entity[@]}" ]] ; then
        for i in ${entity[@]} ; do
            if [[ -e "${i}" ]] ; then
                if [[ "${OUTPUT}" = "both" ]] || [[ "${OUTPUT}" = "positive" ]] ; then
                    echo -e "\t${green}=>${reset} entity:    ${blue}${i}${reset} exists."
                fi
            else
                if [[ "${OUTPUT}" = "both" ]] || [[ "${OUTPUT}" = "negative" ]] ; then
                    echo -e "\t${red}=>${reset} entity:    ${yellow}${i}${reset} doesn't exists."
                    [[ "${status}" != "false" ]] && export status="false"
                fi
            fi
        done
    fi

    # directory
    if [[ -n "${directory[@]}" ]] ; then
        for i in ${directory[@]} ; do
            if [[ -d "${i}" ]] ; then
                if [[ "${OUTPUT}" = "both" ]] || [[ "${OUTPUT}" = "positive" ]] ; then
                    echo -e "\t${green}=>${reset} directory: ${blue}${i}${reset} exists."
                fi
            else
                if [[ "${OUTPUT}" = "both" ]] || [[ "${OUTPUT}" = "negative" ]] ; then
                    echo -e "\t${red}=>${reset} directory: ${yellow}${i}${reset} doesn't exists."
                    [[ "${status}" != "false" ]] && export status="false"
                fi
            fi
        done
    fi

    # file
    if [[ -n "${file[@]}" ]] ; then
        for i in ${file[@]} ; do
            if [[ -f "${i}" ]] ; then
                if [[ "${OUTPUT}" = "both" ]] || [[ "${OUTPUT}" = "positive" ]] ; then
                    echo -e "\t${green}=>${reset} file:      ${blue}${i}${reset} exists."
                fi
            else
                if [[ "${OUTPUT}" = "both" ]] || [[ "${OUTPUT}" = "negative" ]] ; then
                    echo -e "\t${red}=>${reset} file:      ${yellow}${i}${reset} doesn't exists."
                    [[ "${status}" != "false" ]] && export status="false"
                fi
            fi
        done
    fi

    # check require level and return
    if [[ "${REQUIRELEVEL}" = "needed" ]] && [[ "${status}" = "false" ]] ; then
        exit 1
    fi
fi