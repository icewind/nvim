"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" NeoVim configuration for modern fullstack development 
" Node.js, React, TypeScript, Rust, Go(Will be added soon)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" -------------------- General settings -----------------------
language en_US

if has('vim_starting')
  set nocompatible
endif

set history=500
set autoread

set wildmenu

set wildignore+=.hg,.git,.svn                    " Version control
set wildignore+=*.aux,*.out,*.toc                " LaTeX intermediate files
set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg   " binary images
set wildignore+=*.o,*.obj,*.exe,*.dll,*.manifest " compiled object files
set wildignore+=*.spl                            " compiled spelling word lists
set wildignore+=*.sw?                            " Vim swap files
set wildignore+=*.DS_Store                       " OSX bullshit
set wildignore+=*.luac                           " Lua byte code
set wildignore+=migrations                       " Django migrations
set wildignore+=go/pkg                           " Go static files
set wildignore+=go/bin                           " Go bin files
set wildignore+=go/bin-vagrant                   " Go bin-vagrant files
set wildignore+=*.pyc                            " Python byte code
set wildignore+=*.orig                           " Merge resolution files


"" Encoding
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8

"" Fix backspace indent
set backspace=indent,eol,start

"" Tabs. May be overriten by autocmd rules
set tabstop=4
set softtabstop=0
set shiftwidth=4
set expandtab

"" Map leader to ,
let mapleader=','

"" Enable hidden buffers
set hidden

"" Searching
set hlsearch
set incsearch
set ignorecase
set smartcase
set showmatch 

"" Directories for swp files
set nowb
set nobackup
set noswapfile

set fileformats=unix,dos,mac

" Should work in most terminal emulators
if has('mouse')
  set mouse=a
endif
let s:uname = system("echo -n \"$(uname)\"")
if !v:shell_error && s:uname == "Linux" && !has('nvim')
  set ttymouse=xterm
endif

" --------------------- Editor settings -----------------------

" These are default settings and most of them will be overrided
" by linter and/or editorconfig plugins

set expandtab
set smarttab

set shiftwidth=4
set tabstop=4

set tw=180

set ai "Auto indent
set si "Smart indent

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugins (vim-plug)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Let's install vim-plug if we don't have one
let vimplug_exists=expand('~/.config/nvim/autoload/plug.vim')
if !filereadable(vimplug_exists)
  if !executable("curl")
    echoerr "You have to install curl or first install vim-plug yourself!"
    execute "q!"
  endif
  echo "Installing Vim-Plug..."
  echo ""
  silent !\curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  let g:not_finish_vimplug = "yes"

  autocmd VimEnter * PlugInstall
endif

" Load vim-plug config. This step is required
call plug#begin(expand('~/.config/nvim/plugged'))

" --------------------- General packages -----------------------
Plug 'mhartington/oceanic-next'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'easymotion/vim-easymotion'
Plug 'Yggdroot/indentLine'
Plug 'sheerun/vim-polyglot' " Consists of more than 100 file type plugins
Plug 'majutsushi/tagbar' " Show tags for current buffer
Plug 'editorconfig/editorconfig-vim'
Plug 'Raimondi/delimitMate' " Automatically close quotes and brackets
    let delimitMate_expand_cr = 1
    let delimitMate_expand_space = 1
Plug 'Shougo/deol.nvim' " Terminal for nvim

Plug 'w0rp/ale' " Syntax errors and checking / fixing
    let g:ale_linters = {'rust': ['rls']}
    let g:ale_sign_column_always = 1 " Keep ALE gutter on the screen
    let g:airline#extensions#ale#enabled = 1

"" Integration with language server
Plug 'neoclide/coc.nvim', {'tag': '*', 'do': { -> coc#util#install()}}
    " Use K for show documentation in preview window
    nnoremap <silent> K :call <SID>show_documentation()<CR>
    function! s:show_documentation()
      if &filetype == 'vim'
        execute 'h '.expand('<cword>')
      else
        call CocAction('doHover')
      endif
    endfunction
    command! -nargs=0 Prettier :call CocAction('runCommand', 'prettier.formatFile')
    command! -nargs=0 OrganizeImports :call CocAction('runCommand', 'tsserver.organizeImports')

Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
    let g:NERDTreeIgnore=['\.rbc$', '\~$', '\.pyc$', '\.db$', '\.sqlite$', '__pycache__']
    let g:NERDTreeSortOrder=['^__\.py$', '\/$', '*', '\.swp$', '\.bak$', '\~$']
    let g:NERDTreeShowBookmarks=1
    let g:nerdtree_tabs_focus_on_files=1
    let g:NERDTreeMapOpenInTabSilent = '<RightMouse>'
    let g:NERDTreeWinSize = 50

Plug 'vim-airline/vim-airline'
    set laststatus=2
    let g:airline_theme='oceanicnext'
    let g:airline#extensions#tabline#enabled = 1
    let g:airline#extensions#tabline#fnamemod = ':t'
    let g:airline_powerline_fonts = 1
    let g:airline_skip_empty_sections = 1

    if exists("*fugitive#statusline")
      set statusline+=%{fugitive#statusline()}
    endif

" Install the best fuzzy finder tool
if isdirectory('/usr/local/opt/fzf')
  Plug '/usr/local/opt/fzf' | Plug 'junegunn/fzf.vim'
else
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
  Plug 'junegunn/fzf.vim'
endif

let g:make = 'gmake'
if exists('make')
        let g:make = 'make'
endif
    set wildmode=list:longest,list:full

    " Using find if there is no any other search tools available
    let $FZF_DEFAULT_COMMAND =  "find * -path '*/\.*' -prune -o -path 'node_modules/**' -prune -o -path 'target/**' -prune -o -path 'dist/**' -prune -o  -type f -print -o -type l -print 2> /dev/null"

    " The Silver Searcher
    if executable('ag')
      let $FZF_DEFAULT_COMMAND = 'ag --hidden --ignore .git -g ""'
      set grepprg=ag\ --nogroup\ --nocolor
    endif

    if executable('rg')
      let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --follow --glob "!.git/*"'
      set grepprg=rg\ --vimgrep
      command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --hidden --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>).'| tr -d "\017"', 1, <bang>0)
    endif

" --------------------------- Git ------------------------------
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'rbong/vim-flog' " Git branch viewer

" Include user's extra bundle
if filereadable(expand("~/.config/nvim/local_bundles.vim"))
  source ~/.config/nvim/local_bundles.vim
endif

" --------------------------- HTML ----------------------------

autocmd Filetype html setlocal ts=2 sw=2 expandtab
Plug 'mattn/emmet-vim', { 'for': ['html', 'css', 'scss', 'less'] }

" ------------------------ TypeScript -------------------------

" *.tsx syntax highlight
Plug 'peitalin/vim-jsx-typescript'

" ------------------------ JavaScript -------------------------

autocmd Filetype javascript setlocal ts=2 sw=2 sts=0 expandtab
let g:javascript_enable_domhtmlcss = 1

" --------------------------- Rust ----------------------------


" ---------------------------- Go ----------------------------

call plug#end()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Auto commands 
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup prewrites
    autocmd!
    " autocmd BufWritePre *.js,*.jsx,*.mjs,*.ts,*.tsx, CocCommand tsserver.organizeImports
    autocmd BufWritePre *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.json,*.graphql,*.md,*.vue,*.yaml,*.html Prettier
augroup END

augroup coc
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Appearance 
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set t_Co=256
set ruler
set number
set background=dark
colorscheme OceanicNext

if has('gui_running')
  syntax enable
  set transparency=3
  set regexpengine=1
  set guioptions-=T
  set guioptions-=L
  set guioptions-=e
  set guitablabel=%M\ %t
endif

if (has("termguicolors"))
 set termguicolors
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Keybindings 
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" M here is mapped to Meta symbol provided by iTerm2(CMD in my case)
nnoremap <M-p> :FZF<CR> 
nnoremap <M-S[> :bp<CR>
nnoremap <M-S]> :bn<CR>

"" Open file browser like in VSCode
nnoremap <M-b> :NERDTreeToggle<CR>

if has('nvim')
  nnoremap <silent> <leader>sh :terminal<CR>
else
  nnoremap <silent> <leader>sh :VimShellCreate<CR>
endif

"" Clean search (highlight)
nnoremap <silent> <leader><space> :noh<cr>

"" Split
noremap <Leader>h :<C-u>split<CR>
noremap <Leader>v :<C-u>vsplit<CR>

"" Search mappings: These will make it so that going to the next one in a
"" search will center on the line it's found in.
nnoremap n nzzzv
nnoremap N Nzzzv

"" Switching windows
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l
noremap <C-h> <C-w>h

"" Switching buffers
:nnoremap <C-n> :bnext<CR>
:nnoremap <C-p> :bprevious<CR>

"" no one is really happy until you have this shortcuts
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

nnoremap <F6> :setlocal spell! spell?<CR>

"" Prettier
nnoremap <M-??> :Prettier<cr>

"" Organize imports
nnoremap ?? :OrganizeImports<CR>

"" Rename refactor
nmap <F2> <Plug>(coc-rename) 

"" Coc show diagnostic message
nmap <leader>d <Plug>(coc-diagnostic-info)<CR>

" Remap for do codeAction of current line
nmap <leader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)


" Use `[c` and `]c` for navigate diagnostics
nmap <silent> [c <Plug>(coc-diagnostic-prev)
nmap <silent> ]c <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Show commands
nnoremap <silent> <M-SP> :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <M-SO> :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <M-t> :<C-u>CocList -I symbols<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Autocmd 
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if has("autocmd")

    filetype plugin indent on

    " Remember the last cursor position
    augroup vimrc-remember-cursor-position
        autocmd!
        autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
    augroup END

endif
