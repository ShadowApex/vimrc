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

" Maybe?
" https://github.com/glepnir/lspsaga.nvim 
" https://github.com/folke/trouble.nvim

" Load Plugins {
    call plug#begin()
        " Completion Engine
        Plug 'neovim/nvim-lspconfig'
        Plug 'hrsh7th/cmp-nvim-lsp'
        Plug 'hrsh7th/cmp-buffer'
        Plug 'hrsh7th/cmp-path'
        Plug 'hrsh7th/cmp-cmdline'
        Plug 'hrsh7th/nvim-cmp'
        " Snippets
        Plug 'hrsh7th/cmp-vsnip'
        Plug 'hrsh7th/vim-vsnip'
        " Package Manager
        Plug 'williamboman/mason.nvim'
        Plug 'williamboman/mason-lspconfig.nvim'
        " Diagnostics 
        Plug 'folke/trouble.nvim'
        Plug 'glepnir/lspsaga.nvim'
        " Colors    
        Plug 'dracula/vim', { 'as': 'dracula' }
        " Look and Feel
        Plug 'vim-airline/vim-airline'
        Plug 'vim-airline/vim-airline-themes'
        Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
        Plug 'nathanaelkane/vim-indent-guides'
        "Plug 'ryanoasis/vim-devicons'
        Plug 'nvim-tree/nvim-web-devicons'
        Plug 'onsails/lspkind.nvim'
        " File Completion/Search
        Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
        Plug 'junegunn/fzf.vim'
        " Golang
        Plug 'sebdah/vim-delve'
        " Kubernetes
        Plug 'towolf/vim-helm'
        " Terraform
        Plug 'hashivim/vim-terraform'
        " Puppet
        Plug 'rodjek/vim-puppet'
        " Linters
        "Plug 'w0rp/ale'
        " Formatters
        Plug 'sbdchd/neoformat'
        " Insert bracks/parens in pairs
        Plug 'raimondi/delimitmate'
        " Git
        Plug 'airblade/vim-gitgutter'
        Plug 'tpope/vim-fugitive'
        Plug 'junegunn/gv.vim'
        " Multi-cursor
        Plug 'mg979/vim-visual-multi', {'branch': 'master'}
        " Change into a project root
        Plug 'airblade/vim-rooter'
        " Shortcut discovery
        Plug 'sunaku/vim-shortcut'
    call plug#end()
"}

" Neovide {
    if exists("g:neovide")
        let g:neovide_floating_blur_amount_x = 3.0
        let g:neovide_floating_blur_amount_y = 3.0
        let g:neovide_remember_window_size = v:true " Remember window size
        set guifont=FiraCode_Nerd_Font:h12

        " Open terminal with ctrl+shift+t
        map <C-t> :terminal<cr>i
        tnoremap <C-t> <C-\><C-n>:terminal<cr>i
    endif
" }

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

    " TextEdit might fail if hidden is not set.
    set hidden
    
    " Some servers have issues with backup files, see #649.
    set nobackup
    set nowritebackup
    
    " Give more space for displaying messages.
    "set cmdheight=2
    
    " Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
    " delays and poor user experience.
    set updatetime=300

    " Don't pass messages to |ins-completion-menu|.
    set shortmess+=c
    
    " Always show the signcolumn, otherwise it would shift the text each time
    " diagnostics appear/become resolved.
    set signcolumn=yes

    " Terminal {
        au TermOpen * setlocal nonumber norelativenumber wrap
    " }
"}

" Edit {
    " Undo and swap location
    set undolevels=1000 " Lots of undo
    set directory=$HOME/.vim/swapfiles//

    " Clipboard {
        if has('clipboard')
            set clipboard+=unnamedplus
        "    if has('unnamedplus')  " When possible use + register for copy-paste
        "        set clipboard=unnamed,unnamedplus
        "    else         " On mac and Windows, use * register for copy-paste
        "        set clipboard=unnamed,unnamedplus
        "    endif
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

    " SCONS support {
        augroup scons
            au!
            autocmd BufNewFile,BufRead SCsub,SConstruct set syntax=python
        augroup END
    " }
    
    " Indent same level as previous line
    set smartindent
    set autoindent

    " Add indentation lines on startup
    let g:indent_guides_enable_on_vim_startup = 1
    let g:indent_guides_auto_colors = 0
    autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=#242632 ctermbg=3
    autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=#262834 ctermbg=4

    " C/C++
    autocmd FileType cpp setlocal shiftwidth=2 softtabstop=2 expandtab

    " YAML
    autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

    " Typescript
    autocmd FileType typescript setlocal ts=2 sts=2 sw=2 expandtab
    autocmd FileType typescriptreact setlocal ts=2 sts=2 sw=2 expandtab
" }

" Look and Feel {
    " Use the 'dracula' color scheme
    colorscheme dracula

    " Use terminal colors
    set termguicolors
	let $NVIM_TUI_ENABLE_TRUE_COLOR=1

    " airline {
        let g:airline_theme = 'dracula'
        let g:airline#extensions#tabline#enabled = 1  " Disable for large files
        let g:airline_powerline_fonts = 1
        set laststatus=2
        " Show terminal buffers
        let g:airline#extensions#tabline#ignore_bufadd_pat = 'defx|gundo|nerd_tree|startify|tagbar|undotree|vimfiler'
    " }

	" Enable mouse support
	set mouse=a
" }

" Plugins {
    " nvim-web-devicons {
        :lua require('nvim-web-devicons').setup()
    " }    

    " vim-delve {
        let g:delve_new_command = 'enew'
    " }

    " Neoformat {
        " Have Neoformat use &formatprg as a formatter
        let g:neoformat_try_formatprg = 1

        " Python Black formatter for Tuxemon
        let g:neoformat_python_black = {
                    \ 'exe': 'black',
                    \ 'args': ['-q', '-t', 'py38', '-l', '79', '-'],
                    \ 'stdin': 1,
                    \ }
        let g:neoformat_enabled_python = ['black', 'docformatter']

        let g:neoformat_enabled_go = ['gofmt']

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

            " Case-sensitive sorting
            let g:NERDTreeCaseSensitiveSort = 1
        endif
    " }

    " nvim-cmp {
        set completeopt=menu,menuone,noselect
        :lua require('plugins/lsp')
        :lua require('plugins/nvim-cmp')
    " }

    " mason {
        :lua require('mason').setup()
        :lua require('mason-lspconfig').setup()
    " }

    " trouble.nvim {
        :lua require('trouble').setup()
        :lua require('plugins/lspsaga')
    " }
" }

" Keybindings {
    " Enable the 'Shortcut' command to define searchable shortcuts
    runtime plugin/shortcut.vim

    " Shortcuts {
        Shortcut [shortcut] show shortcut menu and run chosen shortcut
            \ noremap <silent> <Leader><Leader> :Shortcuts<Return>
        Shortcut [shortcut] fallback to shortcut menu on partial entry
            \ noremap <silent> <Leader> :Shortcuts<Return>
    " }

    " Tab/Buffer navigation {
        Shortcut [tabs] switch to next tab/buffer
            \ nmap <silent> gt :bn<cr>
        Shortcut [tabs] switch to previous tab/buffer
            \ nmap <silent> gT :bp<cr>
        Shortcut [tabs] close current tab/buffer
            \ nmap <silent> gq :bd<cr>
    " }

    " FZF {
        " Set CTRL+p for file search
        Shortcut [fzf] search for files by name
            \ nnoremap <C-p> :Files<ENTER>

        " Set CTRL+g for ag/grep pattern search
        Shortcut [fzf] search for patterns inside files
            \ nnoremap <C-g> :Ag<ENTER>

        " Set CTRL+b for searching buffers
        Shortcut [fzf] show and search tabs/buffers
            \ nnoremap <Leader>t :Buffers<ENTER>
    " }

    " Neoformat {
        " To Run Manually
        Shortcut [Neoformat] run code formatter
            \ nnoremap <leader>fm :Neoformat<CR>
    " }

    " NERDTree {
        Shortcut [NERDTree] toggle nerd tree file browser
            \ map <F2> :NERDTreeToggle<CR>
    " }

    " Golang {
        " Use '\t' to toggle breakpoint 
        au FileType go Shortcut [delve] toggle breakpoint
            \ nmap <Leader>t :DlvToggleBreakpoint<CR>
    " }

    " LspSaga {
        " Use K to show documentation in preview window.
        Shortcut [lspsaga] show documentation in preview window 
            \ nnoremap <silent> K <cmd>Lspsaga hover_doc<CR>

        " Symbol renaming.
        Shortcut [lspsaga] rename symbol
            \ nmap <silent> <Leader>rn <cmd>Lspsaga rename<CR>

        " Code action/quick fix
        Shortcut [lspsaga] open code action/quick fix
            \ nmap <silent> <Leader>qf <cmd>Lspsaga code_action<CR>

        " Outline
        Shortcut [lspsaga] open outline of the buffer 
            \ noremap <silent> <Leader>o <cmd>LSoutlineToggle<CR>

        " Diagnostics
        Shortcut [lspsaga] go to next diagnostic error
            \ noremap <silent> ]d <cmd>Lspsaga diagnostic_jump_next<CR>
        Shortcut [lspsaga] go to previous diagnostic error
            \ noremap <silent> [d <cmd>Lspsaga diagnostic_jump_prev<CR>

        " Launch a bash terminal
        Shortcut [shell] launch a bash terminal
            \ nnoremap <F3> <cmd>Lspsaga open_floaterm<CR>
        tnoremap <F3> <C-\><C-n><cmd>Lspsaga close_floaterm<CR>
    " }

    " Neovim LSP {
    " https://github.com/neovim/nvim-lspconfig#keybindings-and-completion
        " Use `[d` and `]d` to navigate diagnostics
        Shortcut [neovim-lsp] open diagnostics window
            \ noremap <silent> <Leader>d :lua vim.diagnostic.setloclist()<CR>

        " GoTo code navigation.
        Shortcut [neovim-lsp] go to definition
            \ nmap <silent> gd :lua vim.lsp.buf.definition()<CR>
        Shortcut [neovim-lsp] go to type definition declaration
            \ nmap <silent> gD :lua vim.lsp.buf.declaration()<CR>
        Shortcut [neovim-lsp] go to implementation
            \ nmap <silent> gi :lua vim.lsp.buf.implementation()<CR>
        Shortcut [neovim-lsp] go to references
            \ nmap <silent> gr :lua vim.lsp.buf.references()<CR>
        Shortcut [neovim-lsp] go back
            \ nmap <silent> gb <C-t>
    " }

" }
