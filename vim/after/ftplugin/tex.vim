setlocal wrap
setlocal spell spelllang=en_us

if !has('nvim')
    autocmd FileType tex call vimtex#init()
end
