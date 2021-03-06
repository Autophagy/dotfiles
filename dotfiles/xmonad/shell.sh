#!/bin/bash

CMD=urxvt
CWD=''

# Get window ID
ID=$(xdpyinfo | grep focus | cut -f4 -d " ")

# Get PID of process whose window this is
PID=$(xprop -id "$ID" | grep -m 1 PID | cut -d " " -f 3)

# Get last child process (shell, vim, etc)
if [ -n "$PID" ]; then
  TREE=$(pstree -lpA "$PID" | tail -n 1)
  PID=$(echo "$TREE" | awk -F'---' '{print $NF}' | sed -re 's/[^0-9]//g')

  # If we find the working directory, run the command in that directory
  if [ -e "/proc/$PID/cwd" ]; then
    CWD=$(readlink "/proc/$PID/cwd")
  fi
fi
if [ -n "${CWD}" ] && [ "${CWD}" != "/usr/bin" ]; then
  $CMD -cd "$CWD"
else
  $CMD
fi
