" Make the spacebar the leader key
nnoremap <SPACE> <Nop>
let mapleader=" "

call plug#begin(stdpath('data') . '/plugged')
" Look
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'jszakmeister/vim-togglecursor'
Plug 'itchyny/lightline.vim'
Plug 'airblade/vim-gitgutter'

" Navigation
Plug 'christoomey/vim-tmux-navigator'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'ms-jpq/chadtree', {'branch': 'chad', 'do': ':UpdateRemotePlugins'}

" General configuration
Plug 'machakann/vim-sandwich'
Plug 'chrisbra/matchit'
Plug 'neoclide/coc.nvim'
Plug 'antoinemadec/coc-fzf'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'

" Language
Plug 'leafOfTree/vim-svelte-plugin'
Plug 'pangloss/vim-javascript'
Plug 'leafgarland/typescript-vim'
call plug#end()

" ================ General Config ====================
set number                      " Line numbers are good
set backspace=indent,eol,start  " Allow backspace in insert mode
set history=1000                " Store lots of :cmdline history
set showcmd                     " Show incomplete cmds down the bottom
set autoread                    " Reload files changed outside vim
set ttimeout                    " https://vi.stackexchange.com/a/20220
set ttimeoutlen=100
set signcolumn=yes:2
set hidden
filetype plugin on

" Create a command named 'Vimrc' that will open the .vimrc file
command! -nargs=0 Vimrc :e ~/.config/nvim/init.vim

" set Vim-specific sequences for RGB colors
if !has('nvim')
    set termguicolors
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif

" https://github.com/dracula/vim/issues/65#issuecomment-377496609
let g:dracula_italic = 0
colorscheme dracula
highlight Normal ctermbg=None

" https://unix.stackexchange.com/a/50735
if !has('nvim')
    set ttymouse=xterm2
endif
set mouse=a

set colorcolumn=80  " 80 char ruler

" https://github.com/tpope/vim-vinegar/issues/13#issuecomment-47133890
autocmd FileType netrw setl bufhidden=delete

" ================ Turn Off Swap Files ==============

set noswapfile
set nobackup
set nowb 

" ================ Indentation ======================

set autoindent
set smartindent
set smarttab
set shiftwidth=2
set softtabstop=2
set tabstop=2
set expandtab

" Auto indent pasted text
" nnoremap p p=`]<C-o>
" nnoremap P P=`]<C-o>

filetype plugin on
filetype indent on

" Display tabs and trailing spaces visually
set list listchars=tab:\ \ ,trail:·

set nowrap       "Don't wrap lines
set linebreak    "Wrap lines at convenient points

" ================ Persistent Undo ==================
" Keep undo history across sessions, by storing in file.
" Only works all the time.
if has('persistent_undo') && isdirectory(expand('~').'/.vim/backups')
  silent !mkdir ~/.vim/backups > /dev/null 2>&1
  set undodir=~/.vim/backups
  set undofile
endif

" ================ Completion =======================

set wildmenu
set wildmode=longest:full,full

" ================ Scrolling ========================

set scrolloff=8         "Start scrolling when we're 8 lines away from margins
set sidescrolloff=15
set sidescroll=1

" ================ Search ===========================

set incsearch       " Find the next match as we type the search
set hlsearch        " Highlight searches by default
set ignorecase      " Ignore case when searching...
set smartcase       " ...unless we type a capital


" ================ Mappings ===========================
nnoremap <leader>\ :nohlsearch<CR>
nnoremap <leader>s <C-^>
nnoremap <leader><TAB> <cmd>CHADopen<cr>

" ================ Plugin Specific ===========================

" ---------vim-commentary---------
autocmd FileType svelte setlocal commentstring=<!--\ %s\ -->
autocmd FileType svelte.javascript  setlocal commentstring=//\ %s

" ---------vim-togglecursor---------
" Enable togglecursor when using tmux 
if $TERM == 'screen-256color'
  let g:togglecursor_force = 'xterm'
endif

" ---------lightline.vim---------
let g:lightline = {
      \ 'colorscheme': 'dracula',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'cocstatus', 'currentfunction', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'cocstatus': 'coc#status',
      \   'currentfunction': 'CocCurrentFunction'
      \ },
      \ }

set laststatus=2
set noshowmode

" ---------fzf.vim---------
" Create a command named 'Rg' that will fuzzy find all lines in the CWD
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)

nnoremap <silent> <leader><space> :GFiles --cached --others --exclude-standard<CR>
nnoremap <silent> <leader>t :Buffers<CR>

" Fuzzy find projects and cd into them 
nnoremap <silent> <leader>p :call fzf#run(fzf#wrap({
      \'source': 'ls', 
      \'dir': $PROJECTS, 
      \'sink': 'cd'}))<CR>

" ---------coc.nvim---------
" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()
inoremap <silent><expr> <NUL> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
" <cr> could be remapped by other vim plugin, try `:verbose imap <CR>`.
if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Not sure what this does so I'm just keeping it around
" augroup mygroup
"   autocmd!
"   " Setup formatexpr specified filetype(s).
"   autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
"   " Update signature help on jump placeholder.
"   autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
" augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of LS, ex: coc-tsserver
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Show all diagnostics.
nnoremap <silent><nowait> <leader>d  :<C-u>CocFzfList diagnostics<cr>
nnoremap <silent><nowait> <leader>c  :<C-u>CocFzfList commands<cr>
" nnoremap <silent><nowait> <leader>r  :<C-u>CocFzfList symbols<cr>
