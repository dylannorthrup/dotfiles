" This requires vim-plug to be installed which is available from https://github.com/junegunn/vim-plug
"   mkdir -p ~/.local/share/nvim/site/autoload && cd !$
"   curl https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim > plug.vim
" You will then need to run neovim and invoke the following command:
"   :PlugInstall
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
Plug 'towolf/vim-helm'
Plug 'neovim/nvim-lspconfig' | Plug 'hrsh7th/cmp-nvim-lsp' | Plug 'hrsh7th/cmp-buffer' | Plug 'hrsh7th/cmp-path' | Plug 'hrsh7th/cmp-cmdline' | Plug 'hrsh7th/nvim-cmp'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'godlygeek/tabular'
Plug 'google/vim-jsonnet'
"Plug 'sjl/vitality.vim'
Plug 'jamessan/vim-gnupg'

" List ends here. Plugins become visible to Vim after this call.
call plug#end()

" Fake out any attempts to use vim-sensible
if exists('g:loaded_sensible') || &compatible
  finish
else
  let g:loaded_sensible = 'yes'
endif

