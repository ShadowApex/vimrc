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
        Plug 'dracula/vim', { 'as': 'dracula' }
        " Look and Feel
        Plug 'vim-airline/vim-airline'
        Plug 'vim-airline/vim-airline-themes'
        Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
        Plug 'nathanaelkane/vim-indent-guides'
        Plug 'ryanoasis/vim-devicons'
        " Completion Engine
        Plug 'neoclide/coc.nvim', {'branch': 'release'}
        " File Completion/Search
        Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
        Plug 'junegunn/fzf.vim'
        " Golang
        Plug 'sebdah/vim-delve'
        " GDScript
        Plug 'clktmr/vim-gdscript3'
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
        "Plug 'raimondi/delimitmate'
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

        " Python Black formatter for Tuxemon
        let g:neoformat_python_black = {
                    \ 'exe': 'black',
                    \ 'args': ['-q', '-t', 'py38', '-l', '79', '-'],
                    \ 'stdin': 1,
                    \ }
        let g:neoformat_enabled_python = ['black', 'docformatter']

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

    " coc.nvim {
        " Use tab for trigger completion with characters ahead and navigate.
        " NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
        " other plugin before putting this into your config.
        inoremap <silent><expr> <TAB>
              \ coc#pum#visible() ? coc#pum#next(1):
              \ CheckBackspace() ? "\<Tab>" :
              \ coc#refresh()
        inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
        
        " Make <CR> to accept selected completion item or notify coc.nvim to format
        " <C-g>u breaks current undo, please make your own choice.
        inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                                      \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
        
        function! CheckBackspace() abort
          let col = col('.') - 1
          return !col || getline('.')[col - 1]  =~# '\s'
        endfunction
        
        " Use <c-space> to trigger completion.
        if has('nvim')
          inoremap <silent><expr> <c-space> coc#refresh()
        else
          inoremap <silent><expr> <c-@> coc#refresh()
        endif
 
        " Highlight the symbol and its references when holding the cursor.
        autocmd CursorHold * silent call CocActionAsync('highlight')
        
        augroup mygroup
          autocmd!
          " Setup formatexpr specified filetype(s).
          autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
          " Update signature help on jump placeholder.
          autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
        augroup end
        
        " Add `:Format` command to format current buffer.
        command! -nargs=0 Format :call CocActionAsync('format')
        
        " Add `:Fold` command to fold current buffer.
        command! -nargs=? Fold :call     CocAction('fold', <f-args>)
        
        " Add `:OR` command for organize imports of the current buffer.
        command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')
        
        " Add (Neo)Vim's native statusline support.
        " NOTE: Please see `:h coc-status` for integrations with external plugins that
        " provide custom statusline: lightline.vim, vim-airline.
        set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}
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
    " }

    " Launch a bash terminal {
        Shortcut [shell] launch a bash terminal
            \ nnoremap <F3> :below 10sp term://$SHELL<cr>i
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

    " coc.nvim {
        " Use `[g` and `]g` to navigate diagnostics
        " Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
        Shortcut [coc.vim] navigate to previous diagnostic message
            \ nmap <silent> [g <Plug>(coc-diagnostic-prev)
        Shortcut [coc.vim] navigate to next diagnostic message
            \ nmap <silent> ]g <Plug>(coc-diagnostic-next)
        
        " GoTo code navigation.
        Shortcut [coc.vim] go to definition
            \ nmap <silent> gd <Plug>(coc-definition)
        Shortcut [coc.vim] go to type definition
            \ nmap <silent> gy <Plug>(coc-type-definition)
        Shortcut [coc.vim] go to implementation
            \ nmap <silent> gi <Plug>(coc-implementation)
        Shortcut [coc.vim] go to references
            \ nmap <silent> gr <Plug>(coc-references)
        
        " Use K to show documentation in preview window.
        Shortcut [coc.vim] show/lookup documentation in preview window
            \ nnoremap <silent> K :call ShowDocumentation()<CR>
        
        function! ShowDocumentation()
          if CocAction('hasProvider', 'hover')
            call CocActionAsync('doHover')
          else
            call feedkeys('K', 'in')
          endif
        endfunction
        
        " Symbol renaming.
        Shortcut [coc.vim] rename symbol
            \ nmap <leader>rn <Plug>(coc-rename)
        
        " Formatting selected code.
        Shortcut [coc.vim] format selected code
            \ nmap <leader>f  <Plug>(coc-format-selected)
        xmap <leader>f  <Plug>(coc-format-selected)
       
        " Applying codeAction to the selected region.
        " Example: `<leader>aap` for current paragraph
        Shortcut [coc.vim] apply code action to the selected region
            \ nmap <leader>a  <Plug>(coc-codeaction-selected)
        xmap <leader>a  <Plug>(coc-codeaction-selected)
        
        " Remap keys for applying codeAction to the current buffer.
        Shortcut [coc.vim] apply code action to the current buffer
            \ nmap <leader>ac  <Plug>(coc-codeaction)
        " Apply AutoFix to problem on the current line.
        Shortcut [coc.vim] apply quick fix to problem on the current line
            \ nmap <leader>qf  <Plug>(coc-fix-current)
        
        " Run the Code Lens action on the current line.
        Shortcut [coc.vim] run Code Lens action on the current line
            \ nmap <leader>cl  <Plug>(coc-codelens-action)
        
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
        
        " Remap <C-f> and <C-b> for scroll float windows/popups.
        if has('nvim-0.4.0') || has('patch-8.2.0750')
          nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
          nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
          inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
          inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
          vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
          vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
        endif
        
        " Use CTRL-S for selections ranges.
        " Requires 'textDocument/selectionRange' support of language server.
        Shortcut [coc.vim] use range select
            \ nmap <silent> <C-s> <Plug>(coc-range-select)
        xmap <silent> <C-s> <Plug>(coc-range-select)
       
        " Mappings for CoCList
        " Show all diagnostics.
        Shortcut [coc.vim] show all diagnostics
            \ nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
        " Manage extensions.
        Shortcut [coc.vim] manage extensions
            \ nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
        " Show commands.
        Shortcut [coc.vim] show commands
            \ nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
        " Find symbol of current document.
        Shortcut [coc.vim] find symbol of current document
            \ nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
        " Search workspace symbols.
        Shortcut [coc.vim] search workspace symbols
            \ nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
        " Do default action for next item.
        Shortcut [coc.vim] do default action for next item
            \ nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
        " Do default action for previous item.
        Shortcut [coc.vim] do default action for previous item
            \ nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
        " Resume latest coc list.
        Shortcut [coc.vim] resume latest coc list
            \ nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>
    " }
" }

      

