#!/bin/sh
# Create new window, split horizontally, then split left pane vertically
tmux neww -n "$(~/bin/random_line.rb ~/.tmux/window_names)"
tmux splitw -h -p 50 -t 0
tmux splitw -v -p 50 -t 1
tmux splitw -v -p 50 -t 0
tmux select-layout tiled
tmux select-pane -t 0
