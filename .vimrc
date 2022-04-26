" execute pathogen#infect('bundle/{}')
execute pathogen#infect()
let g:terraform_fmt_on_save=1

let g:vitality_fix_cursor = 1
let g:vitality_normal_cursor = 2
let g:vitality_insert_cursor = 2
let g:vitality_fix_focus = 0
let g:vitality_always_assume_iterm = 1

" Included from https://github.com/tpope/vim-sensible/blob/master/plugin/sensible.vim with minor edits
" sensible.vim - Defaults everyone can agree on
" Maintainer:   Tim Pope <http://tpo.pe/>
" Version:      1.2

if exists('g:loaded_sensible') || &compatible
  finish
else
  let g:loaded_sensible = 'yes'
endif

if has('autocmd')
  filetype plugin indent on
endif
if has('syntax') && !exists('g:syntax_on')
  syntax enable
endif

" Use :help 'option' to see the documentation for the given option.

"set autoindent
set backspace=indent,eol,start
set complete-=i
set smarttab

set nrformats-=octal

if !has('nvim') && &ttimeoutlen == -1
  set ttimeout
  set ttimeoutlen=100
endif

set hlsearch
" Use <C-L> to clear the highlighting of :set hlsearch.
if maparg('<C-L>', 'n') ==# ''
  nnoremap <silent> <C-L> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>
endif

set laststatus=2
set ruler
set wildmenu

if !&scrolloff
  set scrolloff=1
endif
if !&sidescrolloff
  set sidescrolloff=5
endif
set display+=lastline

if &encoding ==# 'latin1' && has('gui_running')
  set encoding=utf-8
endif

if &listchars ==# 'eol:$'
  set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
endif

if v:version > 703 || v:version == 703 && has("patch541")
  set formatoptions+=j " Delete comment character when joining commented lines
endif

if has('path_extra')
  setglobal tags-=./tags tags-=./tags; tags^=./tags;
endif

set autoread

if &history < 1000
  set history=1000
endif
if &tabpagemax < 50
  set tabpagemax=50
endif
if !empty(&viminfo)
  set viminfo^=!
endif
set sessionoptions-=options
set viewoptions-=options

" Allow color schemes to do bright colors without forcing bold.
if &t_Co == 8 && $TERM !~# '^Eterm'
  set t_Co=16
endif

" Load matchit.vim, but only if the user hasn't installed a newer version.
if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
  runtime! macros/matchit.vim
endif

if empty(mapcheck('<C-U>', 'i'))
  inoremap <C-U> <C-G>u<C-U>
endif
if empty(mapcheck('<C-W>', 'i'))
  inoremap <C-W> <C-G>u<C-W>
endif

function ReTab()
  set expandtab
  retab
endfunction

" vim:set ft=vim et sw=2:
autocmd FileType * setlocal ts=2 sts=2 sw=2 expandtab fo-=c fo-=r fo-=o
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab fo-=c fo-=r fo-=o
set bg=dark
command! RT ReTab()

" reset search highlighting
highlight clear search
" Only add the things I want to add.
" 15 == white
"  4 == dark blue
highlight search ctermfg=15 ctermbg=4

"set foldenable
"set foldmethod=syntax
"set foldlevel=1
" set foldclose=all

au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") |
 \ exe "normal g'\"" | endif

" Mark trailing whitespace and other whitespace oddities.
highlight ExtraWhitespace ctermbg=yellow guibg=yellow
" Show trailing whitespace; and spaces before and after a tab:
match ExtraWhitespace /\s\+$\| \+\ze\t\|\ze\t \+ \+$/
" Not when I'm actively typing, because that is distracting
autocmd InsertEnter * highlight ExtraWhitespace ctermbg=black guibg=black
" But put it back when I am not typing
autocmd InsertLeave * highlight ExtraWhitespace ctermbg=yellow guibg=yellow

" Make the vimdiff colors not so garish
" Defaults in case we want to go back for some reason:
"   DiffAdd        xxx term=bold ctermbg=4 guibg=DarkBlue
"   DiffChange     xxx term=bold ctermbg=5 guibg=DarkMagenta
"   DiffDelete     xxx term=bold ctermfg=12 ctermbg=6 gui=bold guifg=Blue guibg=DarkCyan
"   DiffText       xxx term=reverse cterm=bold ctermbg=9 gui=bold guibg=Red
" Strangely, my monitor shows #ffffff (231) as a little bit red, so I use #d7ffff (195) instead
" Using dark green for background [#005f00 (22)]
highlight DiffAdd    cterm=bold ctermfg=195 ctermbg=22
highlight DiffDelete cterm=bold ctermfg=0 ctermbg=172
highlight DiffChange ctermfg=46 ctermbg=240
highlight DiffText   ctermfg=195 ctermbg=52
