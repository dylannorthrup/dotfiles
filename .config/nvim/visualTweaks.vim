" Tweaks to coloration/highlighting.
" reset search highlighting
highlight clear search
" Only add the things I want to add.
" 15 == white
"  4 == dark blue
highlight search ctermfg=15 ctermbg=4

" Use <C-L> to clear the highlighting of :set hlsearch.
if maparg('<C-L>', 'n') ==# ''
"  nnoremap <silent> <C-L> <C-L>:nohlsearch<CR>:match<CR>:diffupdate<CR>
  nnoremap <silent> <C-L> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>
endif

" Override the cursor setting
set guicursor=n-v-c-sm-i-ci-r-cr:block,ve:ver25,o:hor20

" Override the cursor setting
set guicursor=n-v-c-sm-i-ci-r-cr:hor20,ve:hor25,o:hor20
au VimLeave,VimSuspend * set guicursor=a:hor20-blinkon0

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

if &t_Co == 8 && $TERM !~# '^Eterm'
  set t_Co=16           " Allow bright colors without forcing bold
endif

