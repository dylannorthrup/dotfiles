# Aliases and functions for working with network services

alias dig='dig +nocomments'

# rsync options:
# a: Archive mode. Implies the following:
#    r: recursive
#    l: copy symlinks as symlinks
#    p: preserve permissions
#    t: preserve times
#    g: preserve groups
#    o: preserve owners
#    D: preserve device and special files
# v: verbose
# z: compress
# i: output change-summary for all updates
# O: omit directories when preserving times
# h: human-readable numbers
# --progress: show progress during transfer
alias rep='rsync -avz -i -O -h --info=progress2,name1,stats2 --progress --exclude .DS_Store'
alias nrep='rsync -avnz -i -O -h --info=progress2,name1,stats2 --progress --exclude .DS_Store'

# Handy rsync options if you're looking here
# c: Skip based on checksum (time intensive for bigger files)
# --executability: preserve executability
# x: don't cross filesystem boundaries
# --delete: delete extraneous files on target
# I: don't skip files that match size and time
# --size-only: skip files that match in size
# --exclude=PATTERN: Exclude files matching pattern (eg. "--exclude='*.mp4'")
# --stats: give file transfer stats
# 8: do not escape high-bit characters in output
# --bwlimit=KBPS: Limit transfer speed
# 4: prefer IPv4
