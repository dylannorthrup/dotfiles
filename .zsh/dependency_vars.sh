# These are variables or settings that the files under ~/.zsh/local.d depend on.
# I do them here, once, so I don't have to do them elsewhere many times. I can
# also guarantee that this runs before they do.
export UNAME_KERNEL=$(uname -s)
