setlocal foldmethod=syntax

nnoremap <Plug>clang-format :!clang-format -i %<cr>
nmap <localleader>f <Plug>clang-format
