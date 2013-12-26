#!/bin/sh
# Create new window
tmux neww -n "$(~/bin/random_line.rb ~/.tmux/window_names)"
