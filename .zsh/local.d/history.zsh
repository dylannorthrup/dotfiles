# History stuff


export SAVEHIST=100000
export HISTSIZE=200000
export HIST_STAMPS="%F %T"

unsetopt histignorealldups  # Keep duplicate commands. Useful for post-mortems
setopt appendhistory        # Append history to HIST file instead of replacing it.
unsetopt sharehistory       # Import history when shell starts (mutually exclusive with appendhistory)
setopt histnofunctions      # Don't save function definitions
setopt histnostore          # Don't save `history` commands
setopt histreduceblanks     # Remove superfluous blnaks from command lines before saving
setopt histfcntllock        # Use system `fcntl` call to lock HIST file when writing to it
