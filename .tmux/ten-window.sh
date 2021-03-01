#!/bin/sh
# Create new window, split horizontally, then split left pane vertically
tmux neww -n "$(~/bin/random_line.rb ~/.tmux/window_names)"
# Split horizontally
tmux splitw -h -p 50 -t 0
# Do all this on pane 1 so it retains the same pane number
tmux splitw -v -p 20 -t 1
tmux splitw -v -p 25 -t 1
tmux splitw -v -p 33 -t 1
tmux splitw -v -p 50 -t 1
# Now do the same thing on pane 0
tmux splitw -v -p 20 -t 0
tmux splitw -v -p 25 -t 0
tmux splitw -v -p 33 -t 0
tmux splitw -v -p 50 -t 0
tmux select-pane -t 0
tmux setw synchronize-panes on
