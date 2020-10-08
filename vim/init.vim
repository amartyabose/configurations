if has('nvim')
    let s:editor_root = expand('~/.config/nvim')
else
    let s:editor_root = expand('~/.vim')
end

if (has('termguicolors'))
  set termguicolors
endif

let mapleader = "'"
let maplocalleader = "`"
let @/ = ""                         " Clears previous searches 
set t_Co=256
set nocompatible

set nowrap
set encoding=utf8

filetype plugin indent on
syntax on

" Completion {{{
set omnifunc=syntaxcomplete#Complete
set completeopt=longest,menuone
" }}}

set hidden                          " hide buffers instead of closing them

set tabstop=4                       " number of visual spaces per tab
set softtabstop=4                   " number of spaces inserted when <TAB> is pressed
set shiftwidth=4                    " number of spaces used for indenting
set expandtab                       " tabs are spaces
set smartindent

set incsearch                       " set incremental search
set hlsearch                        " highlight the search results
set ignorecase                      " non-case sensitive searches
set number                          " show line number
set relativenumber                  " show relative line number

set laststatus=2

set autoread
set splitbelow
set splitright

set cursorline

" Package handling {{{
function! PackInit() abort
    packadd minpac
    if !exists('*minpac#init')
        call system('mkdir -p '.s:editor_root.'/pack/minpac/opt/')
        call system('git clone https://github.com/k-takata/minpac.git '.s:editor_root.'/pack/minpac/opt/minpac')
    endif
    call minpac#init()
    call minpac#add('k-takata/minpac', {'type': 'opt'})
    call minpac#add('hecal3/vim-leader-guide')
    call minpac#add('tpope/vim-surround')
    call minpac#add('tpope/vim-fugitive')
    " call minpac#add('tpope/vim-dispatch')
    call minpac#add('skywind3000/asyncrun.vim')
    call minpac#add('mhinz/vim-signify')
    call minpac#add('itchyny/lightline.vim')
    call minpac#add('junegunn/fzf')
    call minpac#add('junegunn/fzf.vim')
    call minpac#add('lervag/vimtex')
    call minpac#add('bfrg/vim-cpp-modern')
    call minpac#add('easymotion/vim-easymotion')
    call minpac#add('JuliaEditorSupport/julia-vim')
    call minpac#add('mboughaba/i3config.vim')
    call minpac#add('dylanaraps/wal.vim')
endfunction

command! PackUpdate call PackInit() | source $MYVIMRC | call minpac#update()
command! PackClean  call PackInit() | source $MYVIMRC | call minpac#clean()
command! PackStatus call PackInit() | source $MYVIMRC | call minpac#status()

let g:deoplete#enable_at_startup = 1

let g:vimtex_quickfix_ignore_filters = {'overfull' : 0, 'underfull' : 0, 'default' : 0}
let g:vimtex_view_general_viewer = 'evince'
let g:vimtex_tex_flavor = 'latex'
let g:tex_flavor = 'latex'

let g:EasyMotion_do_mapping = 0 " Disable default mappings
let g:EasyMotion_smartcase = 1

function! s:my_displayfunc()
    let g:leaderGuide#displayname =
                \ substitute(g:leaderGuide#displayname, '\c<cr>$', '', '')
    let g:leaderGuide#displayname = 
                \ substitute(g:leaderGuide#displayname, '^<Plug>', '', '')
endfunction
let g:leaderGuide_displayfunc = [function("s:my_displayfunc")]
let g:lmap = {}
let g:llmap = {}
let g:topdict = {}
let g:topdict["'"] = g:lmap
let g:topdict["'"]['name'] = '<leader>'
let g:topdict['`'] = g:llmap
let g:topdict['`']['name'] = '<localleader>'
autocmd VimEnter * :call leaderGuide#register_prefix_descriptions("", "g:topdict")          " Plugins load after vimrc. This function is defined by leaderGuide
nnoremap <silent> <leader> :<c-u>LeaderGuide "'"<CR>
vnoremap <silent> <leader> :<c-u>LeaderGuideVisual "'"<CR>
nnoremap <localleader> :<c-u>LeaderGuide  '`'<CR>
vnoremap <localleader> :<c-u>LeaderGuideVisual  '`'<CR>

set timeoutlen=500
" }}}

" colorscheme material
colorscheme wal
hi! Normal ctermbg=NONE guibg=NONE
hi! NonText ctermbg=NONE guibg=NONE
hi! CursorLine term=bold cterm=bold ctermbg=NONE guibg=NONE
hi! Folded ctermbg=NONE guibg=NONE

" Keybindings {{{
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

let g:lmap.p = {'name': '+packages'}
nnoremap <Plug>pclean :PackClean<cr>
nmap <leader>pc <Plug>pclean
nnoremap <Plug>pstatus :PackStatus<cr>
nmap <leader>ps <Plug>pstatus
nnoremap <Plug>pupdate :PackUpdate<cr>
nmap <leader>pu <Plug>pupdate

let g:lmap.v = {'name': '+vimrc'}
nnoremap <Plug>open-vimrc-vertical :vsplit $MYVIMRC<cr>
nmap <leader>vv <Plug>open-vimrc-vertical
nnoremap <Plug>open-vimrc-horizontal :split $MYVIMRC<cr>
nmap <leader>vs <Plug>open-vimrc-horizontal
nnoremap <Plug>open-vimrc :edit $MYVIMRC<cr>
nmap <leader>ve <Plug>open-vimrc
nnoremap <Plug>reload-vimrc :source $MYVIMRC<cr>
nmap <leader>vr <Plug>reload-vimrc

let g:lmap.f = {'name': '+files'}
nnoremap <Plug>fzf-all-files :Files<cr>
nmap <leader>ff <Plug>fzf-all-files
nnoremap <Plug>fzf-git-files :GFiles<cr>
nmap <leader>fg <Plug>fzf-git-files

let g:lmap.b = {'name': '+buffers'}
nnoremap <leader>bb :Buffers<cr>
nnoremap <leader>bn :bn<cr>
nnoremap <leader>bp :bp<cr>
nnoremap <leader>bd :bd<cr>

let g:lmap.w = {'name': '+windows'}
nnoremap <Plug>horizontal-split :split<cr>
nmap <leader>ws <Plug>horizontal-split
nnoremap <Plug>vertical-split :vsplit<cr>
nmap <leader>wv <Plug>vertical-split

let g:lmap.m = {'name': '+easymotion'}
nmap <leader>mw <Plug>(easymotion-bd-w)
nmap <leader>mf <Plug>(easymotion-bd-f)

let g:lmap.g = {'name': '+git'}
nnoremap <Plug>status :Gstatus<cr>
nmap <leader>gs <Plug>status
nnoremap <Plug>diff :Gdiff<cr>
nmap <leader>gd <Plug>diff
nnoremap <Plug>commit :Gcommit<cr>
nmap <leader>gc <Plug>commit
nnoremap <Plug>log :Glog<cr>
nmap <leader>gl <Plug>log
nnoremap <Plug>blame :Gblame<cr>
nmap <leader>gb <Plug>blame
nnoremap <Plug>push :Gpush<cr>
nmap <leader>gp <Plug>push
" }}}

" NetRC file manager {{{
let g:netrw_liststyle=1        " listing: 0 - normal; 1 - details; 2 - wide; 3 - tree
let g:netrw_browse_split=0     " open file in: 0 - same window; 1 - horizontal split below; 2 - vertical split; 3 - new tab; 4 - horizontal split above
" }}}

" Close all folds when opening a new buffer {{{
autocmd BufRead * normal zM

" au VimEnter * silent !xmodmap -e 'clear Lock' -e 'keycode 0x42 = Escape'
" au VimLeave * silent !xmodmap -e 'clear Lock' -e 'keycode 0x42 = Caps_Lock'
" }}}
