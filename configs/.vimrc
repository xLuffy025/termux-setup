" =============================================================================
"  GESTIÓN DE PLUGINS CON VIM-PLUG
" =============================================================================
call plug#begin('~/.vim/plugged')
Plug 'preservim/nerdtree'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'tpope/vim-commentary'
Plug 'junegunn/fzf.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'itchyny/lightline.vim'
Plug 'morhetz/gruvbox'
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'jiangmiao/auto-pairs'

call plug#end()

" =============================================================================
"  CONFIGURACIÓN ESENCIAL
" =============================================================================
set nocompatible
set encoding=utf-8
syntax on
set number
set relativenumber
set cursorline
set ruler
set ignorecase
set smartcase
set incsearch
set hlsearch
set backspace=indent,eol,start
set showcmd
set showmatch

" =============================================================================
"  INDENTACIÓN Y FORMATO
" =============================================================================
set autoindent
set expandtab
set tabstop=4
set shiftwidth=4
set smartindent

" =============================================================================
"  CONFIGURACIÓN DE PLUGINS
" =============================================================================
" NERDTree: Abrir con Ctrl + n
nnoremap <C-n> :NERDTreeToggle<CR>

function! ToggleNERDTree()
  if exists("t:nerdtree_bufnr") && bufexists(t:nerdtree_bufnr)
      NERDTreeClose
  else
      NerdTreeToggle
  endif
endfunction




" Vim-Airline y Dracula Theme
set background=dark
let g:airline_powerline_fonts = 1
let g:airline_theme = 'dracula'
colorscheme dracula

