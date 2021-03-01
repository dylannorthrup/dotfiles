#!/bin/sh
# Create new window, split horizontally, then split left pane vertically
#
# To get the appropriate line noise to use as an argument, set up the window
# layout you want, then do `tmux list-windows` in a shell and copy whatever
# line noise you see for your window after '[layout '
tmux select-layout '12c4,236x107,0,0[236x26,0,0{117x26,0,0,114,118x26,118,0,118},236x26,0,27{117x26,0,27,117,118x26,118,27,119},236x26,0,54{117x26,0,54,115,118x26,118,54,120},236x26,0,81{117x26,0,81,116,118x26,118,81,121}]'
