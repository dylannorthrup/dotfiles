#!/usr/bin/zsh
# shellcheck shell=bash
# History stuff


export HISTSIZE=200000
export SAVEHIST=1000000000
export HISTFILESIZE=1000000000
export HIST_STAMPS="%F %T"

unsetopt histignorealldups  # Keep duplicate commands. Useful for post-mortems
unsetopt histnofunctions    # Save function definitions
unsetopt sharehistory       # Import history when shell starts (mutually exclusive with appendhistory)
setopt appendhistory        # Append history to HIST file instead of replacing it.
setopt extendedhistory      # Records the timestamp of each command in HIST file
setopt histfcntllock        # Use system `fcntl` call to lock HIST file when writing to it
setopt histnostore          # Don't save `history` commands
setopt histreduceblanks     # Remove superfluous blnaks from command lines before saving
# Make this start history at the first entry. Otherwise, it only goes back 16 commands which is . . .
# . . . sub-optimal
alias history='history -E 1'
