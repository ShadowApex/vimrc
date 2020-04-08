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
        Plug 'vim-airline/vim-airline'
        Plug 'vim-airline/vim-airline-themes'
        Plug 'scrooloose/nerdtree'
        " Completion Engine
        Plug 'neoclide/coc.nvim', {'do': 'yarn install --frozen-lockfile'}
        " File Completion/Search
        Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
        Plug 'junegunn/fzf.vim'
        " Golang
        Plug 'sebdah/vim-delve'
        " GDScript
        Plug 'calviken/vim-gdscript3'
        " Kubernetes
        Plug 'towolf/vim-helm'
        " Terraform
        Plug 'hashivim/vim-terraform'
        " Puppet
        Plug 'rodjek/vim-puppet'
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
    
    " vim-delve {
        let g:delve_new_command = 'enew'
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
" }

" Keybindings {
    " Launch a bash terminal
    nnoremap <F3> :below 10sp term://$SHELL<cr>i

    " Golang {
        " Use '\t' to toggle breakpoint 
        au FileType go nmap <Leader>t :DlvToggleBreakpoint<CR>
    " }

    " coc.nvim {
        " use <tab> for trigger completion and navigate to the next complete item
        function! s:check_back_space() abort
          let col = col('.') - 1
          return !col || getline('.')[col - 1]  =~ '\s'
        endfunction
        
        inoremap <silent><expr> <Tab>
              \ pumvisible() ? "\<C-n>" :
              \ <SID>check_back_space() ? "\<Tab>" :
              \ coc#refresh()

        " Use <c-space> to trigger completion.
        inoremap <silent><expr> <c-space> coc#refresh()

        " Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
        " position. Coc only does snippet and additional edit on confirm.
        if exists('*complete_info')
          inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
        else
          imap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
        endif
      
        " Use `[g` and `]g` to navigate diagnostics
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
        
        " Formatting selected code.
        xmap <leader>f  <Plug>(coc-format-selected)
        nmap <leader>f  <Plug>(coc-format-selected)
        
        augroup mygroup
          autocmd!
          " Setup formatexpr specified filetype(s).
          autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
          " Update signature help on jump placeholder.
          autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
        augroup end
        
        " Applying codeAction to the selected region.
        " Example: `<leader>aap` for current paragraph
        xmap <leader>a  <Plug>(coc-codeaction-selected)
        nmap <leader>a  <Plug>(coc-codeaction-selected)
        
        " Remap keys for applying codeAction to the current line.
        nmap <leader>ac  <Plug>(coc-codeaction)
        " Apply AutoFix to problem on the current line.
        nmap <leader>qf  <Plug>(coc-fix-current)
        
        " Introduce function text object
        " NOTE: Requires 'textDocument.documentSymbol' support from the language server.
        xmap if <Plug>(coc-funcobj-i)
        xmap af <Plug>(coc-funcobj-a)
        omap if <Plug>(coc-funcobj-i)
        omap af <Plug>(coc-funcobj-a)
        
        " Use <TAB> for selections ranges.
        " NOTE: Requires 'textDocument/selectionRange' support from the language server.
        " coc-tsserver, coc-python are the examples of servers that support it.
        nmap <silent> <TAB> <Plug>(coc-range-select)
        xmap <silent> <TAB> <Plug>(coc-range-select)
        
        " Add `:Format` command to format current buffer.
        command! -nargs=0 Format :call CocAction('format')
        
        " Add `:Fold` command to fold current buffer.
        command! -nargs=? Fold :call     CocAction('fold', <f-args>)
        
        " Add `:OR` command for organize imports of the current buffer.
        command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')
        
        " Add (Neo)Vim's native statusline support.
        " NOTE: Please see `:h coc-status` for integrations with external plugins that
        " provide custom statusline: lightline.vim, vim-airline.
        set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}
        
        " Mappings using CoCList:
        " Show all diagnostics.
        nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
        " Manage extensions.
        nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
        " Show commands.
        nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
        " Find symbol of current document.
        nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
        " Search workspace symbols.
        nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
        " Do default action for next item.
        nnoremap <silent> <space>j  :<C-u>CocNext<CR>
        " Do default action for previous item.
        nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
        " Resume latest coc list.
        nnoremap <silent> <space>p  :<C-u>CocListResume<CR>
    " }
" }

      

