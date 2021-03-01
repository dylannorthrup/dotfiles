#!/bin/sh
# Create new window, split horizontally, then split left pane vertically
tmux neww -n "$(~/bin/random_line.rb ~/.tmux/window_names)"
tmux splitw -v -p 50 -t 0
tmux splitw -v -p 50 -t 1
tmux splitw -v -p 50 -t 0
tmux splitw -h -p 50 -t 0
tmux splitw -h -p 50 -t 2
tmux splitw -h -p 50 -t 4
tmux splitw -h -p 50 -t 6
tmux select-pane -t 0
tmux setw synchronize-panes on
# Old way that splits so movement goes vertically
#tmux splitw -h -p 50 -t 0
#tmux splitw -v -p 50 -t 0
#tmux splitw -v -p 50 -t 0
#tmux splitw -v -p 50 -t 2
#tmux splitw -v -p 50 -t 4
#tmux splitw -v -p 50 -t 4
#tmux splitw -v -p 50 -t 6
