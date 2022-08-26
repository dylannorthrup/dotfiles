#!/bin/sh
# Create new window, split horizontally, then split left pane vertically
tmux neww -n "$(~/bin/random_line.rb ~/.tmux/window_names)"
# Split horizontally
tmux splitw -v -p 17 -t 0
tmux splitw -v -p 20 -t 0
tmux splitw -v -p 25 -t 0
tmux splitw -v -p 33 -t 0
tmux splitw -v -p 50 -t 0
# Do this from the bottom up so we don't disturb the lower window numbers
tmux splitw -h -p 50 -t 5
tmux splitw -h -p 50 -t 4
tmux splitw -h -p 50 -t 3
tmux splitw -h -p 50 -t 2
tmux splitw -h -p 50 -t 1
tmux splitw -h -p 50 -t 0
tmux select-pane -t 0
tmux setw synchronize-panes on
