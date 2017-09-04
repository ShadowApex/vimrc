:imap <C-L> <Esc>
set nocompatible
filetype off
"let mapleader = ","

set rtp+=~/.vim/bundle/Vundle.vim/
call vundle#rc()

" let Vundle manage Vundle
" required! 
Bundle 'gmarik/vundle'
"
" The bundles you install will be listed here
"
filetype plugin indent on
syntax on
"Bundle 'Lokaltog/powerline', {'rtp': 'powerline/bindings/vim/'}
Bundle 'vim-airline/vim-airline'
Bundle 'vim-airline/vim-airline-themes'
Bundle 'tpope/vim-fugitive'
Bundle 'scrooloose/nerdtree'
Bundle 'klen/python-mode'
Bundle 'davidhalter/jedi-vim'
Bundle 'moll/vim-node'
Bundle 'marijnh/tern_for_vim'
Bundle 'NLKNguyen/copy-cut-paste.vim'
Bundle 'kien/ctrlp.vim'
Bundle 'airblade/vim-rooter.git'
Bundle 'Yggdroot/indentLine.git'
Bundle 'mkitt/tabline.vim.git'
Bundle 'neomake/neomake'
Bundle 'keith/swift.vim'
Bundle 'peterhoeg/vim-qml'
Bundle 'fatih/vim-go', { 'do': ':GoInstallBinaries' }
Bundle 'Shougo/neosnippet.vim'
Bundle 'Shougo/neosnippet-snippets'
Bundle 'fatih/molokai'
Bundle 'garyburd/go-explorer'
Bundle 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Bundle 'zchee/deoplete-go', {'build': 'make'}
"Bundle 'airblade/vim-gitgutter'
"
" The rest of your config follows here
"
map <F2> :NERDTreeToggle<CR>

augroup vimrc_autocmds
    autocmd!
    " highlight characters past column 120
    autocmd FileType python highlight Excess ctermbg=DarkGrey guibg=Black
    autocmd FileType python match Excess /\%120v.*/
    autocmd FileType python set nowrap
    augroup END


call vundle#end()

" Neomake
autocmd! BufWritePost,BufEnter * Neomake
"let g:neomake_open_list = 2
let g:neomake_java_javac_maker = {
        \ 'errorformat': 
            \ '%E%f:%l: %trror: %m,' .
            \ '%W%f:%l: %tarning: %m,' .
            \ '%E%f:%l: %m,'. 
            \ '%Z%p^,'.
            \ '%-G%.%#',
        \ }
let g:neomake_java_enabled_makers = ['javac']

" " Copy to clipboard
set clipboard+=unnamedplus

" Eclim completion
let g:EclimCompletionMethod = 'omnifunc'

" Deoplete autocompletion
" Start deoplete for autocompletion
let g:deoplete#enable_at_startup = 1
inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"

" NeoVim True Color
"let $NVIM_TUI_ENABLE_TRUE_COLOR=1

" automatically change window's cwd to file's dir
set autochdir

" I'm prefer spaces to tabs
set tabstop=4
set shiftwidth=4
set expandtab

" Set line numbers
set number

" Highlight searches
set hlsearch
highlight Search cterm=NONE ctermfg=white ctermbg=blue

" Column Color Settings
set colorcolumn=80
highlight ColorColumn ctermfg=black ctermbg=red 

" more subtle popup colors 
if has ('gui_running')
    highlight Pmenu guibg=#cccccc gui=bold    
endif

" Powerline setup
"let g:Powerline_symbols = 'fancy'
"set rtp+=$HOME/.local/lib/python2.7/site-packages/powerline/bindings/vim/

" Airline setup
let g:airline_powerline_fonts = 1

" Always show statusline
set laststatus=2

" Use 256 colours (Use this setting only if your terminal supports 256 colours)
set t_Co=256

" 10 line terminal binding
nnoremap <F3> :below 10sp term://$SHELL<cr>i

" NeoVim Python
let g:python_host_prog = '/usr/bin/python'
let g:python3_host_prog = '/usr/bin/python3'


" Python-mode
" Activate rope
" Keys:
" K             Show python docs
" <Ctrl-Space>  Rope autocomplete
" <Ctrl-c>g     Rope goto definition
" <Ctrl-c>d     Rope show documentation
" <Ctrl-c>f     Rope find occurrences
" <Leader>b     Set, unset breakpoint (g:pymode_breakpoint enabled)
" [[            Jump on previous class or function (normal, visual, operator modes)
" ]]            Jump on next class or function (normal, visual, operator modes)
" [M            Jump on previous class or method (normal, visual, operator modes)
" ]M            Jump on next class or method (normal, visual, operator modes)
let g:pymode_lint_config = '$HOME/.pylint.rc'
autocmd FileType python set colorcolumn=120
let g:pymode_rope = 0

" Documentation
let g:pymode_doc = 1
let g:pymode_doc_key = 'K'

"Linting
let g:pymode_lint = 1
let g:pymode_lint_checker = "pylint"
" Auto check on save
let g:pymode_lint_write = 1

" Support virtualenv
let g:pymode_virtualenv = 0

" Enable breakpoints plugin
let g:pymode_breakpoint = 1
let g:pymode_breakpoint_bind = '<leader>b'

" syntax highlighting
let g:pymode_syntax = 1
let g:pymode_syntax_all = 1
let g:pymode_syntax_indent_errors = g:pymode_syntax_all
let g:pymode_syntax_space_errors = g:pymode_syntax_all

" Don't autofold code
let g:pymode_folding = 0

" vertical line indentation
let g:indentLine_color_term = 239
let g:indentLine_color_gui = '#09AA08'
let g:indentLine_char = '│'

" Allow jumping into Java files with gf
autocmd BufRead *.java set suffixesadd=.java

" Enable syntax highlighting for swift
autocmd BufNewFile,BufRead *.swift set syntax=swift

" Enable syntax highlighting for flatbuffers
autocmd BufNewFile,BufRead *.fbs setfiletype fbs

" go-vim settings
"let g:go_auto_type_info = 1
set updatetime=70
let g:go_auto_sameids = 1
autocmd FileType go nmap <Leader>g <Plug>(go-def-tab)
autocmd FileType go nmap <leader>t <Plug>(go-test)
autocmd FileType go nmap <leader>b  <Plug>(go-build)
autocmd FileType go nmap <leader>r  <Plug>(go-run)
