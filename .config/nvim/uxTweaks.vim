" Personal tweaks
set autoread            " Automatically read in changes to a file if it's been changed outside of vi
set background=dark     " I use a black background for terminals
set backspace=indent,eol,start
set complete-=i
set display+=lastline   " Display as much as possible of the last line
set expandtab           " Change tabs to spaces
set formatoptions=q     " Format comments with 'gq'
set formatoptions+=j    " When joining lines, delete comment character
set formatoptions+=l    " Do not split lines
set history=1000        " Remember 1000 search patterns
set hlsearch            " Highlight search items
set laststatus=2
set noincsearch         " No incremental searcheing
set nomodeline          " Don't show mode line
set nrformats-=octal
set ruler               " Show line, col (and % if possible) on status line
set scrolloff=1         " Keep 1 line above/below the cursor when scrolling up or down
set sidescrolloff=5     " Keep 5 columns to the left/right of the cursor when :nowrap is set
set smarttab
set ssop-=options       " Do not restore any options when using :mksess
set tabpagemax=50       " Allow up to 50 active tabs
set viminfo^=!          " Save and restore global variables starting with Uppercase Letters in viminfo
set vop-=options        " Do not restore any options when using :mkview
set wildmenu

if has('autocmd')
  filetype plugin indent on
endif

if has('syntax') && !exists('g:syntax_on')
  syntax enable
endif

if &listchars ==# 'eol:$'
  set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
endif

if !has('nvim') && &ttimeoutlen == -1
  set ttimeout
  set ttimeoutlen=100
endif
