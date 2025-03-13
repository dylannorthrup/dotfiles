set runtimepath^=~/.local/share/nvim runtimepath+=~/.local/share/nvim/after runtimepath+=~/.local/share/nvim/site runtimepath+=~/.local/share/nvim/site/after
let &packpath = &runtimepath
" source ~/.vimrc
let g:loaded_node_provider = 0
let g:python3_host_prog = '~/.asdf/shims/python3'
let g:loaded_perl_provider = 0
let g:ruby_host_prog = '~/.asdf/shims/neovim-ruby-host'

" Do a ':sv' to reload the init.vim
nnoremap <leader>sv :source $MYVIMRC<CR>

let g:vim_home = get(g:, 'vim_home', expand('~/.config/nvim/'))
let config_list = [
  \ 'plugins.vim',
  \ 'lsp.vim',
  \ 'hexmode.vim',
  \ 'uxTweaks.vim',
  \ 'visualTweaks.vim'
  \]

for files in config_list
  for f in glob(g:vim_home.files, 1, 1)
    exec 'source' f
  endfor
endfor

" Use :help 'option' to see the documentation for the given option.

" vim:set ft=vim et sw=2:
autocmd FileType * setlocal ts=2 sts=2 sw=2 expandtab fo-=c fo-=r fo-=o ai
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab fo-=c fo-=r fo-=o ai

""" Module settings
" vim-terraform
let g:terraform_fmt_on_save=1

" vim:set ft=vim et sw=2:
autocmd FileType * setlocal ts=2 sts=2 sw=2 expandtab fo-=c fo-=r fo-=o ai
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab fo-=c fo-=r fo-=o ai
" Local python tab standards at four spaces
autocmd FileType python setlocal ts=4 sts=4 sw=4 expandtab fo-=c fo-=r fo-=o ai

