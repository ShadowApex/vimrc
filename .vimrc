" vim: set sw=4 ts=4 sts=4 et tw=78 foldmarker={,} foldlevel=10 foldmethod=marker spell:

filetype plugin on

" Identify platform {
    let g:MAC = has('macunix')
    let g:LINUX = has('unix') && !has('macunix') && !has('win32unix')
    let g:WINDOWS = has('win32') || has('win64')
" }

" Load plugins {
    call plug#begin('~/.vim/plugged')
        " Colors    
        Plug 'dracula/vim'
        Plug 'paranoida/vim-airlineish'
        " Useful tools
        Plug 'Konfekt/FastFold'
        Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
        Plug 'Shougo/echodoc.vim'
        Plug 'Shougo/neco-syntax'
        Plug 'bling/vim-airline'
        Plug 'editorconfig/editorconfig-vim'
        Plug 'fidian/hexmode'
        Plug 'godlygeek/tabular'
        Plug 'jeffkreeftmeijer/vim-numbertoggle'
        Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
        Plug 'kassio/neoterm'
        Plug 'kien/ctrlp.vim'
        Plug 'mileszs/ack.vim'
        Plug 'neomake/neomake'
        Plug 'numkil/ag.nvim'
        Plug 'raimondi/delimitmate'
        Plug 'scrooloose/nerdcommenter'
        Plug 'scrooloose/nerdtree'
        Plug 'terryma/vim-expand-region'
        Plug 'vim-scripts/visual-increment'
        Plug 'wincent/terminus'
        "Plug 'vim-syntastic/syntastic'
        " Golang
        Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries'}
        Plug 'jodosha/vim-godebug'
        Plug 'zchee/deoplete-go', { 'do': 'make'}
        Plug 'zchee/deoplete-jedi'
        " Rust
        Plug 'racer-rust/vim-racer'
        Plug 'rust-lang/rust.vim'
        Plug 'sebastianmarkow/deoplete-rust'
        " C/C++
        Plug 'Shougo/neoinclude.vim'
        Plug 'rhysd/vim-clang-format'
        Plug 'zchee/deoplete-clang'
        " openCL
        Plug 'petRUShka/vim-opencl'
        " erlang
        Plug 'vim-erlang/vim-erlang-compiler'
        " Puppet
        Plug 'puppetlabs/puppet-syntax-vim'
        Plug 'rodjek/vim-puppet'
        " Terraform
        "Plug 'hashivim/vim-terraform'
        "Plug 'juliosueiras/vim-terraform-completion'
        " Python
        Plug 'zchee/deoplete-jedi'
        " Ruby
        Plug 'vim-ruby/vim-ruby'
        " Git helpers
        Plug 'airblade/vim-gitgutter'
        Plug 'tpope/vim-fugitive'
        " MD preview (use with brew install grip)
        Plug 'JamshedVesuna/vim-markdown-preview'
    call plug#end()
"}

" Nvim specific {

    " NeoVim Python
    if g:LINUX
        let g:python_host_prog = '/usr/bin/python'
        let g:python3_host_prog = '/usr/bin/python3'
    endif
    if g:MAC
        let g:python_host_prog = '/usr/local/bin/python'
        let g:python3_host_prog = '/usr/local/bin/python3'
    endif
    if g:WINDOWS
        let g:python_host_prog = '/c/Python27/python'
        let g:python3_host_prog = '/c/Python32/python'
    endif
" }

" Look and feel {
    set termguicolors
	let $NVIM_TUI_ENABLE_TRUE_COLOR=1
    "set guicursor=
	 
	syntax enable
    colorscheme dracula

    " Highlight searches
    set hlsearch
    highlight Search cterm=NONE ctermfg=white ctermbg=LightBlue
    highlight Search guibg=LightBlue guifg=white

	" Enable mouse support
	set mouse=a
"}

" General {
	scriptencoding utf-8
	
	" Show line numbers
	set number	

	" Highlight current line and set ruler at col 80
	set cursorline
	set colorcolumn=80	

    " Change directories into the file's directory
    set autochdir
    set autowrite

    " This will increase the amount of memory used for patterns
    " It is needed with airline with large files.
    set maxmempattern=30000
"}

" Common Typos {
    cnoreabbrev W! w!
    cnoreabbrev Q! q!
    cnoreabbrev Qall! qall!
    cnoreabbrev Wq wq
    cnoreabbrev Wa wa
    cnoreabbrev wQ wq
    cnoreabbrev WQ wq
    cnoreabbrev W w
    cnoreabbrev Q q
    cnoreabbrev Qall qall
" }

" Edit {
    " Allow cursor after last line character
    set virtualedit=onemore

    " Automatically reload modified files
    "set autoread

    " Undo and swap location
    set undolevels=1000 " Lots of undo
    set directory=$HOME/.vim/swapfiles//

    " Prevent cursor from moving one position to the left when exiting insert mode
    au InsertLeave * call cursor([getpos('.')[1], getpos('.')[2]+1])

    " Always position quickfix window to the bottom
    au FileType qf wincmd J

    " Clipboard {
        if has('clipboard')
            if has('unnamedplus')  " When possible use + register for copy-paste
                set clipboard=unnamed,unnamedplus
            else         " On mac and Windows, use * register for copy-paste
                set clipboard=unnamed
            endif
        endif
    " }

    " GIT support {
        " Instead of reverting the cursor to the last position in the buffer, we
        " set it to the first line when editing a git commit message
        au FileType gitcommit au! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0])
    " }

    " Binary hex editing {
    " vim -b : edit binary using xxd-format!
	    augroup Binary
	        au!
	        au BufReadPre  *.bin,*.so,*.o,*.exe let &bin=1
	        au BufReadPost *.bin,*.so,*.o,*.exe if &bin | %!xxd
	        au BufReadPost *.bin,*.so,*.o,*.exe set ft=xxd | endif
	        au BufWritePre *.bin,*.so,*.o,*.exe if &bin | %!xxd -r
	        au BufWritePre *.bin,*.so,*.o,*.exe endif
	        au BufWritePost *.bin,*.so,*.o,*.exe if &bin | %!xxd
	        au BufWritePost *.bin,*.so,*.o,*.exe set nomod | endif
        augroup END
    " }
" }

 " Formatting {
    " Indent same level as previous line
    set smartindent
    set autoindent

    " Text wrap options (disable text-wrap) {
        set textwidth=0 
        set wrapmargin=0
        set formatoptions-=t
        set nowrap
    "}

    " Format overrides based on file type
    au FileType javascript setl sw=2 sts=2 et
    au FileType python set tabstop=4|set shiftwidth=4|set expandtab
    au FileType ruby set tabstop=2|set shiftwidth=2|set expandtab

    " Automatically trim EOL whitespace when editing ruby/erlang code 
    au FileType ruby autocmd BufWritePre * :%s/\s\+$//e
    au FileType erlang autocmd BufWritePre * :%s/\s\+$//e
" }

" Plugins {
    " vim-go {
        let g:go_highlight_functions = 1
        let g:go_highlight_methods = 1
        let g:go_highlight_structs = 1
        let g:go_highlight_operators = 1
        let g:go_highlight_build_constraints = 1
        let g:go_fmt_fail_silently = 0
        let g:go_fmt_command = "gofmt"
        let g:go_list_type = "quickfix" 
        "let g:go_auto_sameids = 1
        "let g:go_auto_type_info = 1
        let g:go_addtags_transform = "snakecase"
        let g:go_info_mode = "gocode"

        " Run automake on go file save
        au FileType go au! BufWritePost * Neomake
    " }
    
    " rust {
        let g:rustfmt_autosave = 1
        let g:racer_experimental_completer = 1
        let g:deoplete#sources#rust#racer_binary = $HOME.'/.cargo/bin/racer'
        let g:deoplete#sources#rust#rust_source_path = '/usr/src/rustc-1.21.0/src'
        au FileType rust au! BufWritePost * Neomake
    " }
    
    " ruby {
        " Run automake on go file save
        au FileType ruby au! BufWritePost * Neomake
    " }

    " tagbar {
        let g:tagbar_ctags_bin = '/usr/bin/ctags'
    " }
    
    " neomake {
        let g:neomake_open_list = 2
        let g:neomake_list_height = 5
        let g:neomake_always_use_quickfix = 1

        " vim-go {
            let g:neomake_go_enabled_makers = ['go']
        " }
        " cpp {
            let g:neomake_cpp_enabled_makers = ['clang']
        " }
        " python {
            let g:neomake_python_enabled_makers = ['flake8']
        " }
    " }
    
    " deocomplete {
        let g:deoplete#enable_at_startup = 1
        call deoplete#custom#option('num_processes', 4)
        
        " deoplete-go settings {
            let g:deoplete#sources#go#gocode_binary = $GOPATH.'/bin/gocode'
            let g:deoplete#sources#go#sort_class = ['package', 'func', 'type', 'var', 'const']
            let g:deoplete#sources#go#pointer = 1
        " }

        " deoplete popup {
            let g:deoplete#enable_smart_case = 1
            let g:deoplete#auto_complete_delay = 0
            let g:deoplete#auto_refresh_delay = 10
        " }

        " deoplete tab to insert {
            inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
        " }
    " }

    " NERDTree {
        " Automatically show NERDTree if no files are specified when
        " launching vim 
        if !exists("g:gui_oni")
            autocmd StdinReadPre * let s:std_in=1
            autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
            set splitright

            map <F2> :NERDTreeToggle<CR>

            " Case-sensitive sorting
            let g:NERDTreeCaseSensitiveSort = 1
        endif
    " }

    " airline {
        let g:airline_theme = 'airlineish'
        let g:airline#extensions#tabline#enabled = 1  " Disable for large files
        let g:airline_powerline_fonts = 1
        set laststatus=2
    " }
    
    " yaml {
        autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

        " Requires 'yamllint' for linting
        au FileType yaml au! BufWritePost * Neomake
    " }
    
    " json {
        au FileType json au! BufWritePost * Neomake
    " }

    " bash/sh {
        au FileType sh,bash au! BufWritePost * Neomake
    " }

    " puppet {
        " Enable syntax highlighting for puppet modules.
        autocmd BufNewFile,BufRead *.pp set syntax=puppet
        autocmd BufNewFile,BufRead *.pp set autoread
        autocmd BufNewFile,BufRead *.pp setfiletype puppet

        au FileType puppet au! BufWritePost * Neomake
    " }

    " terraform {
        " Deoplete
        "let g:deoplete#omni_patterns = {}
        "let g:deoplete#omni_patterns.terraform = '[^ *\t"{=$]\w*'
        "call deoplete#custom#option('omni_patterns', {'complete_method': 'omnifunc', 'terraform': '[^ *\t"{=$]\w*'})
        "call deoplete#initialize()

        "" Enable terraform plan to be include in filter
        "let g:syntastic_terraform_tffilter_plan = 1

        "" default: 0, enable(1)/disable(0) plugin's keymapping
        "let g:terraform_completion_keys = 0

        "" default: 1, enable(1)/disable(0) terraform module registry
        "" completion
        "let g:terraform_registry_module_completion = 0

        "let g:terraform_module_registry_search = 0
    " }
    
    " python {
        let g:deoplete#sources#jedi#show_docstring = 1
        au FileType python au! BufWritePost * Neomake
    " }
    
    " groovy {
        au BufNewFile,BufRead *.groovy setlocal ts=4 sts=4 sw=4 expandtab
    " }

    " c/c++ {
        if g:LINUX
            let g:deoplete#sources#clang#libclang_path = '/usr/lib/llvm-4.0/lib/libclang.so'
            let g:deoplete#sources#clang#clang_header = '/usr/lib/llvm-4.0/lib/clang'
        endif
        if g:MAC
            let g:deoplete#sources#clang#libclang_path = '/usr/local/Cellar/llvm/5.0.0/lib/libclang.dylib'
            let g:deoplete#sources#clang#clang_header = '/usr/local/Cellar/llvm'
        endif
        au FileType c,cpp,objc,hpp,h au! BufWritePost * Neomake
        au FileType c,cpp ClangFormatAutoEnable
    " }
    
    " echodoc {
        set noshowmode
        let g:echodoc_enable_at_startup = 1
        set completeopt=menu,menuone,noinsert
    " }
    
    " ctrlp {
        let g:ctrlp_use_caching = 0
        if executable('ag')
            set grepprg=ag\ --nogroup\ --nocolor

            let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
        else
          let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files . -co --exclude-standard', 'find %s -type f']
          let g:ctrlp_prompt_mappings = {
            \ 'AcceptSelection("e")': ['<space>', '<cr>', '<2-LeftMouse>'],
            \ }
        endif
    " }
    
    " ack {
        if executable('ag')
            let g:ackprg = 'ag --vimgrep'
        endif
    " }
    
    " vim-numbertoggle {
        let g:NumberToggleTrigger="§"
    " }
    
    " AG {
        " Always ignore Godeps and node_modules
        let g:ag_prg='ag -S --nocolor --nogroup --column --ignore node_modules --ignore Godeps --vimgrep -F'
    " }

    " vim-markdown-preview {
    let vim_markdown_preview_github=1
    let vim_markdown_preview_hotkey='<C-m>'
    " }
"}

" Keybindings {
    " Map leader to space
    let mapleader = "\\"

    " Map Ag search to Ctrl+f
    nnoremap <C-f> :Ag 

    " Enter visual mode with space,space 
    nnoremap <Leader><Leader> V
    
    " Expand/Shrink selection while in visual mode
    vmap v <Plug>(expand_region_expand)
    vmap <C-v> <Plug>(expand_region_shrink)

    " vp doesn't replace paste buffer
    function! RestoreRegister()
      let @" = s:restore_reg
      return ''
    endfunction
    
    function! s:Repl()
      let s:restore_reg = @"
      return "p@=RestoreRegister()\<cr>"
    endfunction
    vmap <silent> <expr> p <sid>Repl()

    " Leader + w to save buffer
    nnoremap <Leader>w :w<CR>

    " Remap enter/backspace in normal mode so we can type 12<Enter> to jump to
    " line
    nnoremap <CR> G
    nnoremap <BS> gg

    " Useful keybindings when working with go files
    au FileType go nmap <leader>t :GoTest!<CR>
    au FileType go nmap <leader><leader>t :GoTestFunc!<CR>
    au FileType go nmap <leader>r :GoRun!<CR>
    au FileType go nmap <leader>b :GoToggleBreakpoint!<CR>
    au FileType go nmap <leader>d :GoDebug!<CR>
    au FileType go nmap <leader>c <Plug>(go-callers)
    au FileType go nmap <leader>i <Plug>(go-implements)
    au FileType go nmap <Leader>g <Plug>(go-def-tab)
    "au FileType go nmap <leader>d <Plug>(go-def-vertical)
    "au FileType go nmap <leader>b  <Plug>(go-build)

    " Indentation shortcuts
    nnoremap <F5> mzgg=G`z
    au FileType json nnoremap <F5> :%!python -m json.tool<CR>

    " Toggle NERDTree
    imap <F1> <Esc>:NERDTreeToggle<CR>i
    map <F1> :NERDTreeToggle<CR>
    nnoremap <leader><F1> :NERDTreeFind<CR>

    " Toggle code comment
    nnoremap <silent><C-_> :call NERDComment("n", "Toggle")<CR>
    vnoremap <silent><C-_> :call NERDComment("x", "Toggle")<CR>

    " Code folding
    inoremap <F9> <C-O>za
    nnoremap <F9> za
    onoremap <F9> <C-C>za
    vnoremap <F9> zf

    " Make Page up/down work properly
    map <PageUp> <C-U>
    map <PageDown> <C-D>
    imap <PageUp> <C-O><C-U>
    imap <PageDown> <C-O><C-D>

    " Map jj to ESC when in insert mode
    inoremap jj <ESC>

    " Launch a bash terminal
    nnoremap <F3> :below 10sp term://$SHELL<cr>i
   
    " Tagbar
    nmap <F8> :TagbarToggle<CR>

    " Easier window switching
    " Note: iterm sends <BS> chen <C-h> is pressed. To fix go to preferences,
    " keys and add a mapping for C+h to Esc+ -> [104;5u
    nmap <silent> <C-h> :wincmd h<CR>
    nmap <silent> <C-j> :wincmd j<CR>
    nmap <silent> <C-k> :wincmd k<CR>
    nmap <silent> <C-l> :wincmd l<CR>
 "}
