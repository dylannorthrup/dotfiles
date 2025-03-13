let g:loaded_node_provider = 0
let g:python3_host_prog = '/usr/local/bin/python3'
let g:loaded_perl_provider = 0
let g:ruby_host_prog = '~/.rbenv/versions/3.3.1/bin/neovim-ruby-host'

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

