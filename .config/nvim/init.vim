set runtimepath^=~/.local/share/nvim runtimepath+=~/.local/share/nvim/after runtimepath+=~/.local/share/nvim/site runtimepath+=~/.local/share/nvim/site/after
let &packpath = &runtimepath
" source ~/.vimrc
let g:loaded_node_provider = 0
let g:loaded_python3_provider = 0
let g:loaded_perl_provider = 0
let g:ruby_host_prog = '~/.rbenv/versions/2.7.0/bin/neovim-ruby-host'

" Do a ':sv' to reload the init.vim
nnoremap <leader>sv :source $MYVIMRC<CR>

" This required vim-plug to be installed which is available from https://github.com/junegunn/vim-plug
"   mkdir -p ~/.local/share/nvim/site/autoload && cd !$
"   curl https://raw.githubusercontent.com/junegunn/vim-plug/masger/plug.vim > plug.vim
" Plugins will be downloaded under the specified directory.
call plug#begin(has('nvim') ? stdpath('data') . '/plugged' : '~/.vim/plugged')

" Declare the list of plugins.
" Plug 'tpope/vim-sensible'   " Specifically not installing this one
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-markdown'
Plug 'neomake/neomake'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'hashivim/vim-terraform'
Plug 'junegunn/fzf', { 'do': './install --all' } | Plug 'junegunn/fzf.vim'
Plug 'neovim/nvim-lspconfig' | Plug 'hrsh7th/cmp-nvim-lsp' | Plug 'hrsh7th/cmp-buffer' | Plug 'hrsh7th/cmp-path' | Plug 'hrsh7th/cmp-cmdline' | Plug 'hrsh7th/nvim-cmp'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'godlygeek/tabular'
Plug 'google/vim-jsonnet'
"Plug 'sjl/vitality.vim'

" List ends here. Plugins become visible to Vim after this call.
call plug#end()

" Run neomake when writing a buffer (no delay).
call neomake#configure#automake('w')
let g:neomake_cpp_gcc_maker = {
      \ 'exe': 'gcc',
      \ 'args': ['-fsyntax-only', '-Wall', '-Wextra', '-I./', '-L/usr/include/mariadb/', '-L/usr/lib/x86_64-linux-gnu/', '-lmariadb']
      \}
let g:neomake_rubocop_maker = {
      \ 'exe': 'rubocop',
      \ 'args': ['--format', 'emacs', '--force-exclusion', '--display-cop-names', '--disable-pending-cops']
      \}

" Fake out any attempts to use vim-sensible
if exists('g:loaded_sensible') || &compatible
  finish
else
  let g:loaded_sensible = 'yes'
endif

" Use :help 'option' to see the documentation for the given option.

" vim:set ft=vim et sw=2:
autocmd FileType * setlocal ts=2 sts=2 sw=2 expandtab fo-=c fo-=r fo-=o ai
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab fo-=c fo-=r fo-=o ai

" reset search highlighting
highlight clear search
" Only add the things I want to add.
" 15 == white
"  4 == dark blue
highlight search ctermfg=15 ctermbg=4

" Not sure what this does
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

" Keep entr from running twice on a save
set backupcopy=yes

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
highlight Folded     ctermfg=15 ctermbg=17

""" Module settings
" vim-terraform
let g:terraform_fmt_on_save=1


" Automatically align ' =' signs
"inoremap <silent> = =<Esc>:call <SID>ealign()<CR>a
"function! s:ealign()
"  let p = '^.*=\s.*$'
"  if exists(':Tabularize') && getline('.') =~# '^.*=' && (getline(line('.')-1) =~# p || getline(line('.')+1) =~# p)
"    let column = strlen(substitute(getline('.')[0:col('.')],'[^=]','','g'))
"    let position = strlen(matchstr(getline('.')[0:col('.')],'.*=\s*\zs.*'))
"    Tabularize/=/l1
"    normal! 0
"    call search(repeat('[^=]*=',column).'\s\{-\}'.repeat('.',position),'ce',line('.'))
"  endif
"endfunction

" Advanced Tabularize method to align '|' delimited tables for cucumber
"inoremap <silent> <Bar>   <Bar><Esc>:call <SID>align()<CR>a
"
"function! s:align()
"  let p = '^\s*|\s.*\s|\s*$'
"  if exists(':Tabularize') && getline('.') =~# '^\s*|' && (getline(line('.')-1) =~# p || getline(line('.')+1) =~# p)
"    let column = strlen(substitute(getline('.')[0:col('.')],'[^|]','','g'))
"    let position = strlen(matchstr(getline('.')[0:col('.')],'.*|\s*\zs.*'))
"    Tabularize/|/l1
"    normal! 0
"    call search(repeat('[^|]*|',column).'\s\{-\}'.repeat('.',position),'ce',line('.'))
"  endif
"endfunction


" For if I start using vitality again
"let g:vitality_fix_cursor = 1
"let g:vitality_normal_cursor = 2
"let g:vitality_insert_cursor = 2
"let g:vitality_fix_focus = 0
"let g:vitality_always_assume_iterm = 1

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

" Use <C-L> to clear the highlighting of :set hlsearch.
if maparg('<C-L>', 'n') ==# ''
"  nnoremap <silent> <C-L> <C-L>:nohlsearch<CR>:match<CR>:diffupdate<CR>
  nnoremap <silent> <C-L> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>
endif

if !has('nvim') && &ttimeoutlen == -1
  set ttimeout
  set ttimeoutlen=100
endif

" Override the cursor setting
set guicursor=n-v-c-sm-i-ci-r-cr:block,ve:ver25,o:hor20

" Override the cursor setting
set guicursor=n-v-c-sm-i-ci-r-cr:hor20,ve:hor25,o:hor20
au VimLeave,VimSuspend * set guicursor=a:hor20-blinkon0

if &t_Co == 8 && $TERM !~# '^Eterm'
  set t_Co=16           " Allow bright colors without forcing bold
endif

function ReTab()
  set expandtab
  retab
endfunction

" vim:set ft=vim et sw=2:
autocmd FileType * setlocal ts=2 sts=2 sw=2 expandtab fo-=c fo-=r fo-=o ai
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab fo-=c fo-=r fo-=o ai
command! RT ReTab()

