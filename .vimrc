" vim: set sw=4 ts=4 sts=4 et tw=78 foldmarker={,} foldlevel=10 foldmethod=marker spell:

" Identify platform {
    let g:MAC = has('macunix')
    let g:LINUX = has('unix') && !has('macunix') && !has('win32unix')
    let g:WINDOWS = has('win32') || has('win64')
" }

" Plugin Setup {
    if empty(glob('~/.config/nvim/autoload/plug.vim'))
        silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
            \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        autocmd VimEnter * PlugInstall
    endif
" }

" Load Plugins {
    call plug#begin()
        " Colors    
        Plug 'dracula/vim'
        " Look and Feel
        Plug 'bling/vim-airline'
        Plug 'scrooloose/nerdtree'
        " Completion Engine
        Plug 'roxma/nvim-yarp'
        Plug 'ncm2/ncm2'
        Plug 'ncm2/ncm2-bufword'
        Plug 'fgrsnau/ncm-otherbuf'
        Plug 'Shougo/echodoc.vim'
        " File Completion/Search
        Plug 'ncm2/ncm2-path'
        Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
        Plug 'junegunn/fzf.vim'
        " Language Server Protocol
        Plug 'prabirshrestha/async.vim'
		Plug 'prabirshrestha/vim-lsp'
        Plug 'ncm2/ncm2-vim-lsp'
        " Golang
        Plug 'sebdah/vim-delve'
        "Plug 'ncm2/ncm2-go'
        " Javascript/Typescript
        Plug 'ncm2/ncm2-cssomni'
        Plug 'ncm2/ncm2-tern', {'do': 'npm install'}
        Plug 'mhartington/nvim-typescript'
        " Python
        Plug 'ncm2/ncm2-jedi'
        " Puppet
        Plug 'rodjek/vim-puppet'
        " Vimscript
        Plug 'Shougo/neco-vim'
        Plug 'ncm2/ncm2-vim'
        " Linters
        Plug 'w0rp/ale'
        " Formatters
        Plug 'sbdchd/neoformat'
        " Insert bracks/parens in pairs
        Plug 'raimondi/delimitmate'
        " Git
        Plug 'airblade/vim-gitgutter'
        Plug 'tpope/vim-fugitive'
        Plug 'junegunn/gv.vim'
        " Multi-cursor
        Plug 'terryma/vim-multiple-cursors'
        " Indentation guide
        Plug 'Yggdroot/indentLine'
        " Change into a project root
        Plug 'airblade/vim-rooter'
    call plug#end()
"}

" General {
	scriptencoding utf-8
    set encoding=utf8
	
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

" Edit {
    " Undo and swap location
    set undolevels=1000 " Lots of undo
    set directory=$HOME/.vim/swapfiles//

    " Clipboard {
        if has('clipboard')
            if has('unnamedplus')  " When possible use + register for copy-paste
                set clipboard=unnamed,unnamedplus
            else         " On mac and Windows, use * register for copy-paste
                set clipboard=unnamed
            endif
        endif
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
    
    " Indent same level as previous line
    set smartindent
    set autoindent

    " C/C++
    autocmd FileType cpp setlocal shiftwidth=2 softtabstop=2 expandtab

    " YAML
    autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
" }

" Look and Feel {
    " Use the 'dracula' color scheme
    colorscheme dracula

    " Use terminal colors
    set termguicolors
	let $NVIM_TUI_ENABLE_TRUE_COLOR=1

    " airline {
        let g:airline_theme = 'airlineish'
        let g:airline#extensions#tabline#enabled = 1  " Disable for large files
        let g:airline_powerline_fonts = 1
        set laststatus=2
    " }

	" Enable mouse support
	set mouse=a
" }

" Plugins {

    " Completion (ncm2) {
        " enable ncm2 for all buffers
        autocmd BufEnter * call ncm2#enable_for_buffer()
    
        " set completeopt to be what ncm2 expects
        set completeopt=noinsert,menuone,noselect

        " supress the annoying 'match x of y', 'The only match' and 'Pattern not
        " found' messages
        set shortmess+=c

        " enable auto complete for `<backspace>`, `<c-w>` keys.
        " known issue https://github.com/ncm2/ncm2/issues/7
        au TextChangedI * call ncm2#auto_trigger()

	    " Use <TAB> to select the popup menu:
	    inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
		inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

        " make it fast
        let ncm2#popup_delay = 5
        let ncm2#complete_length = [[1, 1]]

        " Use new fuzzy based matches
        let g:ncm2#matcher = 'substrfuzzy'
    " }
    
    " vim-delve {
        let g:delve_new_command = 'enew'
    " }

    " vim-lsp {
        " Language servers can be registered here. For a list, refer to this:
        " https://github.com/prabirshrestha/vim-lsp/wiki/Servers

        " go {
            " Register a golang language server. Uncomment one of the three
            " choices here.

            " NOTE: Run `go get -u golang.org/x/tools/cmd/gopls`
            "if executable('gopls')
            "    au User lsp_setup call lsp#register_server({
            "        \ 'name': 'gopls',
            "        \ 'cmd': {server_info->['gopls', '-mode', 'stdio']},
            "        \ 'whitelist': ['go'],
            "        \ })
            "endif

            " NOTE: Run `go get -u github.com/sourcegraph/go-langserver`
            "if executable('go-langserver')
            "    au User lsp_setup call lsp#register_server({
            "        \ 'name': 'go-langserver',
            "        \ 'cmd': {server_info->['go-langserver', '-gocodecompletion']},
            "        \ 'whitelist': ['go'],
            "        \ })
            "endif

            " NOTE: Run `go get -u github.com/saibing/bingo`
            if executable('bingo')
                au User lsp_setup call lsp#register_server({
                    \ 'name': 'bingo',
                    \ 'cmd': {server_info->['bingo', '-mode', 'stdio']},
                    \ 'whitelist': ['go'],
                    \ })
            endif
        " }

        " docker {
            " `npm install -g dockerfile-language-server-nodejs`
            if executable('docker-langserver')
                au User lsp_setup call lsp#register_server({
                    \ 'name': 'docker-lsp',
                    \ 'cmd': {server_info->[&shell, &shellcmdflag, 'docker-langserver --stdio']},
                    \ 'whitelist': ['dockerfile'],
                    \ })
            endif
        " }

        " c/c++ {
            if executable('clangd')
                au User lsp_setup call lsp#register_server({
                    \ 'name': 'clangd',
                    \ 'cmd': {server_info->['clangd', '-background-index']},
                    \ 'whitelist': ['c', 'cpp', 'objc', 'objcpp'],
                    \ })
            endif
        " }

        " css {
            " `npm install -g vscode-css-languageserver-bin`
            if executable('css-languageserver')
                au User lsp_setup call lsp#register_server({
                    \ 'name': 'css-lsp',
                    \ 'cmd': {server_info->[&shell, &shellcmdflag, 'css-languageserver --stdio']},
                    \ 'whitelist': ['css', 'less', 'sass'],
                    \ })
            endif
        " }

        " javascript/typescript {
            " `npm install -g typescript typescript-language-server`
            if executable('typescript-language-server')
                " Use directory with .git as root
                au User lsp_setup call lsp#register_server({
                  \ 'name': 'javascript-lsp',
                  \ 'cmd': { server_info->[&shell, &shellcmdflag, 'typescript-language-server --stdio']},
                  \ 'root_uri': { server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_directory(lsp#utils#get_buffer_path(), '.git/..'))},
                  \ 'whitelist': ['javascript', 'javascript.jsx']
                  \ })

                " Use directory with package.json as root
                "au User lsp_setup call lsp#register_server({
                "    \ 'name': 'javascript-lsp',
                "    \ 'cmd': {server_info->[&shell, &shellcmdflag, 'typescript-language-server --stdio']},
                "    \ 'root_uri':{server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'package.json'))},
                "    \ 'whitelist': ['javascript', 'javascript.jsx'],
                "    \ })
            endif
        " }

        " python {
            " `pip install python-language-server`
            if executable('pyls')
                au User lsp_setup call lsp#register_server({
                    \ 'name': 'pyls',
                    \ 'cmd': {server_info->['pyls']},
                    \ 'whitelist': ['python'],
                    \ })
            endif
        " }

        " ruby {
            if executable('solargraph')
                " gem install solargraph
                au User lsp_setup call lsp#register_server({
                    \ 'name': 'solargraph',
                    \ 'cmd': {server_info->[&shell, &shellcmdflag, 'solargraph stdio']},
                    \ 'initialization_options': {"diagnostics": "true"},
                    \ 'whitelist': ['ruby'],
                    \ })
            endif
        " }

        " rust {
			" rustup update
            " rustup component add rls rust-analysis rust-src
			if executable('rls')
			    au User lsp_setup call lsp#register_server({
			        \ 'name': 'rls',
			        \ 'cmd': {server_info->['rustup', 'run', 'stable', 'rls']},
			        \ 'workspace_config': {'rust': {'clippy_preference': 'on'}},
			        \ 'whitelist': ['rust'],
			        \ })
			endif
        " }

        " yaml {
            " `npm install -g yaml-language-server`
            if executable('yaml-language-server')
                au User lsp_setup call lsp#register_server({
                    \ 'name': 'yaml-lsp',
                    \ 'cmd': {server_info->[&shell, &shellcmdflag, 'yaml-language-server --stdio']},
                    \ 'whitelist': ['yaml', 'yml'],
                    \ })
            endif
        " }
    " }

    " Ale {
        let g:ale_sign_error = '●' " Less aggressive than the default '>>'
        let g:ale_sign_warning = '.'
    " }

    " Neoformat {
        " Have Neoformat use &formatprg as a formatter
        let g:neoformat_try_formatprg = 1

        " Define the formatter function to run.
        fun! RunFormatter()
            if exists('b:noFormatter')
                return
            endif
            undojoin | :silent Neoformat
        endfun

        " Format on save, if desired
        augroup fmt
          autocmd!
          autocmd BufWritePre * call RunFormatter()
          autocmd FileType yaml,json let b:noFormatter=1
          "autocmd BufWritePre * undojoin | :silent Neoformat
        augroup END

        " To Run Manually
        nnoremap <leader>fm :Neoformat<CR>
        
        " javascript {
            if executable('prettier')
                augroup fmtjs
                    autocmd!
                    autocmd FileType javascript setlocal formatprg=prettier\
                                                             \--stdin\
                                                             \--print-width\ 80\
                                                             \--single-quote\
                                                             \--trailing-comma\ es5
                    autocmd BufWritePre *.js :silent Neoformat
                augroup END
            endif
        " }
    " }

    " FZF {
        " Set CTRL+p for file search
        nnoremap <C-p> :Files<ENTER>

        " Set CTRL+g for ag/grep pattern search
        nnoremap <C-g> :Ag<ENTER>

        " Define fzf action when key is pressed
        let g:fzf_action = {
            \ 'ctrl-t': 'tab split',
            \ 'enter':  'tab split',
            \ 'ctrl-x': 'split',
            \ 'ctrl-v': 'vsplit' }

        " Setup FZF if it hasn't been set up
        if has('nvim')
            aug fzf_setup
                au!
                au TermOpen term://*FZF tnoremap <silent> <buffer><nowait> <esc> <c-c>
            aug END
        end
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

    " echodoc {
        set noshowmode
        let g:echodoc_enable_at_startup = 1
    " }

    " indentline {
        " Enable indent line guides by default
        let g:indentLine_enabled = 1

        " Character to use for indent line
        let g:indentLine_char = '┊'
    " }
" }

" Keybindings {
    " Launch a bash terminal
    nnoremap <F3> :below 10sp term://$SHELL<cr>i

    " LSP {
        " Use '\g' to go to definition
        au FileType * nmap <Leader>g :LspDefinition<CR>
        " Use 'K' to pull up documentation
        au FileType * nmap K :LspHover<CR>    
    " }

    " Golang {
        " Use '\t' to toggle breakpoint 
        au FileType go nmap <Leader>t :DlvToggleBreakpoint<CR>
    " }
" }
