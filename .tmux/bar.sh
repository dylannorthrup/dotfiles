#!/bin/sh
# Create new window, split vertically, then split both panes vertically, then 
# kill pane 1 to make the C-n and C-p work as expected
tmux neww -n "$(~/bin/random_line.rb ~/.tmux/window_names)"
tmux splitw -v -p 50 -t 0
tmux splitw -h -p 50 -t 0
tmux splitw -h -p 50 -t 1
tmux kill-pane -t 1
tmux select-pane -t :.+
