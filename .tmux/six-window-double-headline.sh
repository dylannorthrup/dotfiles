#!/bin/sh
# Create new window, adds panes until we have six, then
# uses a specific layout
tmux neww -n "$(~/bin/random_line.rb ~/.tmux/window_names)"
tmux splitw -v -p 50 -t 0
tmux splitw -v -p 50 -t 0
tmux splitw -h -p 50 -t 2
tmux splitw -v -p 50 -t 2
tmux splitw -v -p 50 -t 4
tmux select-pane -t :.+

#tmux select-layout '3693,236x109,0,0[236x27,0,0,178,236x26,0,28,183,236x54,0,55{118x54,0,55[118x27,0,55,179,118x26,0,83,181],117x54,119,55[117x27,119,55,180,117x26,119,83,182]}]]'
