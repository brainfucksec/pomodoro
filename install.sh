#!/bin/sh

# pomodoro installation file
#
# install - install a program, script, or datafile
#
# Copyright (C) 2017-2022 brainf+ck
#
# This script is compatible with the BSD install script, but was written
# from scratch.  It can only install one file at a time, a restriction
# shared with many OS's install programs.


set -euo pipefail

PROG_NAME="pomodoro"
VERSION="0.4.2"
PROG_DIR="$HOME/bin"
DATA_DIR="$HOME/.local/share"


mkdir -pv "$PROG_DIR"
mkdir -pv "$DATA_DIR/$PROG_NAME"
install -Dm644 -v lib/* "$DATA_DIR/$PROG_NAME"
install -Dm755 -v pomodoro.sh "$PROG_DIR/$PROG_NAME"
