" Detect OS and set plug directory
if has('win32')
  let s:plugdir = '~/vimfiles/plugged'
else
  let s:plugdir = '~/.vim/plugged'
endif

" Initialize vim-plug

call plug#begin(s:plugdir)

Plug 'dense-analysis/ale'            " Linting / fixer
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'              " Vim bindings for fzf
Plug 'Yggdroot/indentLine'           " Indentation guides
Plug 'preservim/nerdtree'            " File tree
Plug 'vim-airline/vim-airline'       " Statusline
Plug 'tpope/vim-commentary'          " Commenting
Plug 'tpope/vim-sleuth'              " Detect tab/shiftwidth
Plug 'tpope/vim-surround'            " Surroundings

call plug#end()

" ======================================================
" VIM CONFIGS
" ======================================================
set nocompatible
language en_US
set encoding=utf-8
set cmdheight=2
set shortmess-=S
set noerrorbells
set visualbell
syntax on
filetype plugin on
set autoindent

set number
set hidden
set nowrap
set tabstop=4
set shiftwidth=4
set expandtab
set smartindent
set ignorecase
set smartcase
set incsearch
set nohlsearch
set cursorline
set relativenumber

let mapleader = " "
let maplocalleader = ","
let g:loaded_netrw = 1
let g:loaded_netrwPlugin = 1

set synmaxcol=200
set noshowmode
set mouse=a
set clipboard=unnamedplus
set scrolloff=10
set sidescrolloff=8
set gdefault
set nofoldenable
set foldlevel=99
set splitright
set splitbelow
set equalalways
set history=10000
set undolevels=10000

" ======================================================
" CUSTOM MAPS
" ======================================================
nnoremap <silent> < :bprevious<CR>
nnoremap <silent> > :bnext<CR>

" Keybindings mirrored from Lua config
nnoremap <silent> vv V
nnoremap <silent> <C-s> :w<CR>
vnoremap <silent> b <C-v>
inoremap <silent> <C-h> <C-w>

" Window navigation
nnoremap <silent> <C-h> <C-w>h
nnoremap <silent> <C-j> <C-w>j
nnoremap <silent> <C-k> <C-w>k
nnoremap <silent> <C-l> <C-w>l

" Window resizing
nnoremap <silent> <C-Down> :resize -2<CR>
nnoremap <silent> <C-Up> :resize +2<CR>
nnoremap <silent> <C-Right> :vertical resize -2<CR>
nnoremap <silent> <C-Left> :vertical resize +2<CR>
nnoremap <silent> <C-+> :vertical resize =<CR>

" Keep cursor centered when scrolling and searching
nnoremap <silent> <C-d> <C-d>zz
nnoremap <silent> <C-u> <C-u>zz
nnoremap <silent> n nzzzv
nnoremap <silent> N Nzzzv

" Better indenting in visual mode (keep selection)
vnoremap <silent> < <gv
vnoremap <silent> > >gv

" Splits
nnoremap <silent> <leader>sh :split<CR>
nnoremap <silent> <leader>sv :vsplit<CR>
nnoremap <silent> <leader>sc :close<CR>

" Buffers
nnoremap <silent> <C-q> :bd<CR>

" Yank/Delete entire buffer
nnoremap <silent> <leader>ya ggVGy
nnoremap <silent> <leader>da ggVGd

" ======================================================
" CUSTOM FUNCTIONALITIES
" ======================================================
function! VisualBlockSearchReplace() range
  let l:search_term = input('Search for: ')
  if empty(l:search_term)
    return
  endif
  let l:replace_term = input('Replace with: ')
  if empty(l:replace_term)
    return
  endif

  execute "'<,'>s/" . escape(l:search_term, '/\') . "/" . escape(l:replace_term, '/\&') . "/gc"
endfunction
vnoremap <silent> <leader>sr :<C-u>call VisualBlockSearchReplace()<CR>

" ======================================================
" PLUGIN CONFIGS
" ======================================================
" ======================================================
" AIRLINE CONFIGS
" ======================================================

let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1

" ======================================================
" NERDTree CONFIGS
" ======================================================
nnoremap <silent> <C-e> :silent! NERDTreeToggle<CR>

augroup NERDTreeAutoClose
  autocmd!
  autocmd BufEnter * if (winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree()) | quit | endif
augroup END

" ======================================================
" FZF CONFIGS
" ======================================================
" Debug version - see what file fzf is trying to open
function! CCFilePicker()
  let l:files = systemlist('find . -type f -not -path "*/lost+found*" | head -200')
  let l:choice = inputlist(['Select file:'] + map(copy(l:files), 'v:key + 1 . ". " . v:val'))

  if l:choice > 0 && l:choice <= len(l:files)
    let l:selected = l:files[l:choice - 1]
    execute 'edit ' . fnameescape(l:selected)
  endif
endfunction

" Use this if fzf keeps failing
nnoremap <silent> <C-f> :call CCFilePicker()<CR>

" nnoremap <silent> <C-f> :Files<CR>
nnoremap <silent> <C-t> :RG<CR>

" FZF completion integration
" Enable fzf completion for various commands
let g:fzf_completion = {
  \ 'file': 'fzf#vim#complete#path',
  \ 'buffer': 'fzf#vim#complete#buffer',
  \ 'line': 'fzf#vim#complete#line',
  \ 'tag': 'fzf#vim#complete#tag',
  \ 'help': 'fzf#vim#complete#help'
\ }

" ======================================================
" ALE CONFIGS
" ======================================================

nnoremap <silent> gd :ALEGoToDefinition<CR>
nnoremap <silent> gD :ALEGoToDefinition<CR>
nnoremap <silent> K :ALEHover<CR>
nnoremap <silent> gi :ALEGoToImplementation<CR>
nnoremap <silent> <leader>rn :ALERename<CR>
nnoremap <silent> fr :ALEFindReferences<CR>
let g:ale_completion_enabled = 1

" Airline
let g:airline#extensions#ale#enabled = 1

let g:ale_fixers = {
\   'c': ['clang-format'],
\   'cpp': ['clang-format'],
\}
let g:ale_fix_on_save = 1

" ======================================================
" COMMENTARY CONFIGS
" ======================================================
:autocmd FileType c,cpp setlocal commentstring=//\ %s


