#!/usr/bin/env bash

#######################################################################
# pomodoro.sh
#
# Pomodoro technique counter for study sessions.
# > https://en.wikipedia.org/wiki/Pomodoro_Technique
#
# Copyright (C) 2017-2018 Brainfuck
#
#
# GNU GENERAL PUBLIC LICENSE
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
#######################################################################


# set command: https://ss64.com/bash/set.html
# i.e. exit immediately from program if errors occurs
set -eo pipefail

# Program information
readonly program_name="pomodoro"
readonly version="0.2.0"
readonly author="Brainfuck"

# Arguments, arguments num
readonly args="$*"
readonly argnum="$#"

# Output colors
export red=$'\e[0;91m'
export green=$'\e[0;92m'
export blue=$'\e[0;94m'
export bold_blue=$'\e[1;94m'
export white=$'\e[0;97m'
export endc=$'\e[0m'

# Pomodoros and pauses time settings
readonly session_time=1500
readonly pause_time=300
readonly longpause_time=900

# File paths:
# done_list = file to write the pomodoros completed
# image = image shown with notify-d
readonly done_list="/tmp/pomodoros.txt"
readonly image="$HOME/.local/share/pomodoro/fs.png"
readonly notice_sound="$HOME/.local/share/pomodoro/alarm.wav"


# Exit from program if user type Ctrl+c
trap ctrl_c INT
ctrl_c() {
    printf "\\n%s\\n" "Ctrl+c... exit!"
    exit 0
}


# Display date and time, format: "YYYY-MM-DD H:M:S"
date_format() {
    date "+%Y-%m-%d %T"
}


# Show program version
show_version() {
    printf "%s\\n" "$program_name $version"
    printf "%s\\n" "Copyright (C) 2017-2018 Brainfuck"
    printf "%s\\n" \
           "License GPLv3+: GNU GPL version 3 or later <https://gnu.org/licenses/gpl.html>."
    printf "%s\\n" \
           "This is free software: you are free to change and redistribute it."
    printf "%s\\n" \
           "There is NO WARRANTY, to the extent permitted by law."
    exit 0
}


# Display banner when program start
banner() {
    printf "${bold_blue}
===================================
                     _
 ___ ___ _____ ___ _| |___ ___ ___
| . | . |     | . | . | . |  _| . |
|  _|___|_|_|_|___|___|___|_| |___|
|_|

===================================

Version: $version
Author: $author
${endc}\\n"
}


# Write pomodoros completed to done list
add_to_list() {
    printf "%s\\n" "[*] pomodoro++ - $(date_format)" >>"$done_list"
}


# Delete pomodoros list
del_from_list() {
    if [ -f "$done_list" ]; then
        rm "$done_list"
        printf "${green}%s${endc}\\n" "[i] pomodoros list deleted"
        exit 0
    else
        printf "${green}%s${endc}\\n" "[i] pomodoros list already empty"
        exit 0
    fi
}


# Show pomodoros completed
show_completed() {
    if [[ ! -f "$done_list" ]]; then
        printf "${green}%s${endc}\\n" "[i] No pomodoros have been completed"
        exit 0
    else
        less -FX "$done_list"
    fi
}


# Display the info shown on terminal and with notify-d
# dependency: libnotify; https://developer.gnome.org/libnotify
display_info() {
    local msg_1="[ POMODORO STARTED ]"
    local msg_2="[ PAUSE ]"
    local msg_3="[ LONG PAUSE ]"
    local msg_4="[ POMODOROS SESSION COMPLETED ]"

    case "$1" in
        start)
            # notify-send -t, --expire-time=TIME, -i, --icon=ICON [MSG]
            notify-send -t 10000 -i "$image" "$msg_1"
            printf "${white}%s${endc}\\n" "$msg_1"
            printf "${bold_blue}%s${endc} ${green}%s${endc}\\n" "==>" "GO GO GO! ..."
        ;;
        pause)
            notify-send -t 10000 -i "$image" "$msg_2"
            printf "\\n${white}%s${endc}\\n\\n" "$msg_2"
        ;;
        long_pause)
            notify-send -t 10000 -i "$image" "$msg_3"
            printf "\\n${white}%s${endc}\\n\\n" "$msg_3"
        ;;
        end_session)
            notify-send -t 10000 -i "$image" "$msg_4"
            printf "${bold_blue}%s${endc}\\n" "$msg_4"
            printf "\\n${white}%s${endc}\\n\\n" "A day without learning is a day wasted"
        ;;
    esac
}


# Play notice sound at start/stop of pomodoros, try first with `aplay`
# command then fall back to `paplay` if aplay doesn't exist,
# do nothing if the sound can not be played.
# aplay = Alsa
# paplay = PulseAudio
play_sound() {
    if ! aplay --quiet "$notice_sound" 2>/dev/null; then
        paplay "$notice_sound" 2>/dev/null;
    else
        :
    fi
}


# Check the user input
check_input(){
    # when the option `-p, --pomodoros` is passed,
    # only an integer of 1 to 100 is valid
    if [[ ! "${pomodoros}" =~ ^([1-9]|1[0-9]|2[0-9]|100)$ ]]; then
        printf "${red}%s${endc}\\n" "Error: enter an integer of 1 to 100!"
        exit 1
    fi
}


# Start program
main() {
	banner
    check_input

	# begin pomodoros cycle
    count_cycle=0
	for ((c = 1; c <= "$pomodoros"; c++)); do
        count_cycle="$((count_cycle + 1))"

        # start 25 min pomodoro session
        display_info "start"
        play_sound
		sleep "$session_time"

        # add pomodoro to list at the end of session
        add_to_list

        # make long pause (15 min) after 4 pomodoros
        if [[ "$count_cycle" = 4 ]]; then
            display_info "long_pause"
            play_sound
            count_cycle=0
            sleep "$longpause_time"
        else
        # short pause (5 min) after each pomodoro
            display_info "pause"
            play_sound
            sleep "$pause_time"
        fi
	done

    # end session and show pomodoros done
    display_info "end_session"
    less -FX "$done_list"

	exit 0
}


# Show help menù
usage() {
cat << EOF
$program_name $version
Pomodoro technique counter for study sessions.

Usage: $program_name [option]

Options:
-h, --help           Show this help menù
-p, --pomodoros [n]  Number of pomodoros
-l, --list           Show completed pomodoros
-d, --delete         Delete pomodoros list
-v, --version        Show program version
EOF
}


# Parse command line options
# thanks to dgoguerra for this 'getopt handmade' implementation
# https://gist.github.com/dgoguerra/9206418
if [ "$#" == "0" ]; then
    usage
    exit 1
fi

while [ "$#" -gt 0 ]; do
    case "$1" in
        -h | --help)
            usage
            exit 0
            ;;
        -v | --version)
            show_version
            exit 0
            ;;
        -p | --pomodoros)
            pomodoros="$2"
            main
            shift
            ;;
        -l | --list)
            show_completed
            ;;
        -d | --delete)
            del_from_list
            ;;
        -- | -* | *)
            printf "${red}%s${endc}\\n" "Error: invalid option '$1' !" >&2
            printf "%s\\n" "Try '$program_name --help' for more information."
            exit 1
            ;;
        esac
        shift
done
