" set nocompatible
syntax on
set nowrap
set encoding=utf8
filetype plugin indent on

""" Plugins start
call plug#begin('~/.vim/plugged')

" Theme / Interface
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'dracula/vim'

" Utility
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/nerdcommenter'
Plug 'junegunn/fzf.vim'
Plug 'junegunn/fzf'

" Generic Programming Support 
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-surround'
Plug 'editorconfig/editorconfig-vim'
Plug 'elzr/vim-json'
"Plug 'w0rp/ale'
"Plug 'prettier/vim-prettier', {
"  \ 'do': 'yarn install',
"  \ 'for': ['javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql', 'markdown', 'vue'] }

if has('nvim')
  " Autocomplete    
"  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
"  Plug 'ervandew/supertab'

  " Javascript Support
"  Plug 'ternjs/tern_for_vim', { 'for': ['javascript', 'javascript.jsx'] }
"  Plug 'carlitux/deoplete-ternjs', { 'for': ['javascript', 'javascript.jsx'] }
"  Plug 'othree/jspc.vim', { 'for': ['javascript', 'javascript.jsx'] }

  " Typescript Support
"  Plug 'mhartington/nvim-typescript'
"  Plug 'HerringtonDarkholme/yats.vim'
endif
call plug#end()

""" General Configuration
" Show linenumbers
set number
set ruler
set relativenumber

" Set Proper Tabs
set tabstop=2
set shiftwidth=2
set smarttab
set expandtab

" Disable auto-creating comments
set formatoptions-=r
set formatoptions-=o

" Always display the status line
set laststatus=2

" Enable highlighting of the current line
"set cursorline

" Theme and Styling
" color dracula

" Deoplete Configuration
let g:deoplete#enable_at_startup = 1
set completeopt=longest,menuone,preview
let g:deoplete#omni#functions = {}
let g:deoplete#sources = {}

" Javascript Support
let g:deoplete#omni#functions.javascript = [
  \ 'tern#Complete',
  \ 'jspc#omni'
\]
let g:deoplete#sources['javascript.jsx'] = ['file', 'ultisnips', 'ternjs']
let g:tern#command = ['tern']
let g:tern#arguments = ['--persistent']

" Vim-Supertab Configuration
autocmd FileType javascript let g:SuperTabDefaultCompletionType = "<c-x><c-o>"
let g:SuperTabClosePreviewOnPopupClose = 1

" Vim-Airline Configuration
" let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1 
let g:airline_theme='hybrid'
let g:hybrid_custom_term_colors = 1
let g:hybrid_reduced_contrast = 1 

" Fzf Configuration
" This is the default extra key bindings
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

" Default fzf layout
" - down / up / left / right
let g:fzf_layout = { 'down': '~40%' }

" In Neovim, you can set up fzf window using a Vim command
let g:fzf_layout = { 'window': 'enew' }
let g:fzf_layout = { 'window': '-tabnew' }

" NerdTree
let g:NERDTreeShowHidden=1

" Customize fzf colors to match your color scheme
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

" let $FZF_DEFAULT_COMMAND='fzf --ignore node_modules'
let $FZF_DEFAULT_COMMAND = 'ag --nocolor --ignore node_modules -g ""'

" Typescript
let g:ale_linters = {
\   'typescript': ['prettier', 'eslint', 'tsserver', 'typecheck'],
\}
let g:ale_fixers = {
\   'typescript': ['prettier', 'eslint'],
\}

""" Binds
map <C-n> :NERDTreeToggle<CR>
map <C-m> :TagbarToggle<CR>

" Line Management
noremap <C-j> o<Esc>k
noremap <C-k> O<Esc>j
noremap <C-h> j"_ddk
noremap <C-l> k"_dd

" Enter Normal Mode Using jk 
inoremap jk <esc>
inoremap <esc> <nop>

" <TAB>: completion
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"

" Shortcuts
nnoremap <leader>o :Files<CR>

