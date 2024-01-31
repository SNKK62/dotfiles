if &compatible
    set nocompatible
    set ignorecase
    set smartcase
endif
let $CACHE = expand('~/.cache')
if !isdirectory($CACHE)
    call mkdir($CACHE, 'p')
endif
if &runtimepath !~# '/dein.vim'
  let s:dein_dir = fnamemodify('dein.vim', ':p')
  if !isdirectory(s:dein_dir)
    let s:dein_dir = $CACHE . '/dein/repos/github.com/Shougo/dein.vim'
    if !isdirectory(s:dein_dir)
      execute '!git clone https://github.com/Shougo/dein.vim' s:dein_dir
    endif
  endif
  execute 'set runtimepath^=' . fnamemodify(s:dein_dir, ':p')
endif
if dein#load_state('~/.cache/dein')
    call dein#begin('~/.cache/dein')
    call dein#add('~/.cache/dein/repos/github.com/Shougo/dein.vim')
    call dein#add('tpope/vim-fugitive')
    call dein#add('lambdalisue/fern.vim')
    call dein#add('lambdalisue/nerdfont.vim')
    call dein#add('lambdalisue/fern-renderer-nerdfont.vim')
    call dein#add('lambdalisue/glyph-palette.vim')
    call dein#add('lambdalisue/fern-git-status.vim')
    call dein#add('airblade/vim-gitgutter')
    call dein#add('romgrk/barbar.nvim')
    call dein#add('nvim-lualine/lualine.nvim')
    call dein#add('nvim-telescope/telescope.nvim', { 'rev': '0.1.2' })
    call dein#add('nvim-tree/nvim-web-devicons')
    call dein#add('nvim-lua/plenary.nvim')
    " call dein#add('editorconfig/editorconfig-vim')
    call dein#add('fatih/vim-go') " golang
    call dein#add('buoto/gotests-vim') " gotests
    call dein#add('godlygeek/tabular')
    call dein#add('iamcco/markdown-preview.nvim', {'on_ft': ['markdown', 'pandoc.markdown', 'rmd'],
        \ 'build': 'sh -c "cd app && yarn install"' }) " markdown preview
    call dein#add('lukas-reineke/indent-blankline.nvim')
    call dein#add('t9md/vim-quickhl')
    call dein#add('simeji/winresizer') " <C-e>
    " call dein#add('w0ng/vim-hybrid')
    call dein#add('tomasiser/vim-code-dark')
    call dein#add('itchyny/vim-cursorword')
    call dein#add('xiyaowong/transparent.nvim', {'rev': '4c3c392f285378e606d154bee393b6b3dd18059c'})
    call dein#add('neoclide/coc.nvim', {'rev': 'release'})
    call dein#add('nvim-treesitter/nvim-treesitter', { 'merged': 0 })
    call dein#add('tomtom/tcomment_vim')
    call dein#end()
    call dein#save_state()
endif
if dein#check_install()
    call dein#install()
endif

" base settings
let mapleader="\<Space>"
set guifont="HackGen35 Console NF:h13"
set number
syntax on
set termguicolors
colorscheme codedark
set background=dark
set title
set list
set listchars=tab:>_,trail:~,extends:>,precedes:<,nbsp:%,eol:↲
hi NonText    ctermbg=None ctermfg=65 guibg=None guifg=#41946B
hi SpecialKey ctermbg=None ctermfg=65 guibg=None guifg=#41946B
set autoindent
" set ambiwidth=double
set shiftwidth=4
set softtabstop=4
set tabstop=4
set expandtab
set encoding=utf-8
set incsearch
set ignorecase
set smartcase
set noerrorbells
set laststatus=2
set cmdheight=2
set hlsearch
set completeopt=menuone
set backspace=indent,eol,start
set cursorline
set conceallevel=0
set inccommand=split
set nobackup
set nowritebackup
set noswapfile
set clipboard&
set clipboard^=unnamedplus
hi clear CursorLine
nnoremap <Leader>rep :%s/
" arrow settings
nnoremap <S-j> 15j
vnoremap <S-j> 15j
nnoremap <buffer> <S-K> 15k
vnoremap <buffer> <S-K> 15k
nnoremap <S-l> 10l
vnoremap <S-l> 10l
nnoremap <S-h> 10h
vnoremap <S-h> 10h
" swap paste keybinds
nnoremap p P
vnoremap p P
nnoremap P p
vnoremap P p
" fill columns after 80 with red
set colorcolumn=81
highlight ColorColumn ctermbg=52 guibg=#42032c
" transparent background
let g:transparent_enabled = v:true
" comment/uncomment
nmap <C-/> <C-_><C-_>
imap <C-/> <C-_><C-_>
vmap <C-/> gc
" close brackets and quotes
inoremap { {}<LEFT>
inoremap [ []<LEFT>
inoremap ( ()<LEFT>
inoremap " ""<LEFT>
inoremap ' ''<LEFT>
inoremap ` ``<LEFT>

" terminal mode setting
tnoremap <Esc> <C-\><C-n>
nnoremap <silent> tt <cmd>terminal<CR>
nnoremap <silent> tx <cmd>belowright new<CR><cmd>terminal<CR>
autocmd TermOpen * :startinsert
autocmd TermOpen * setlocal norelativenumber
autocmd TermOpen * setlocal nonumber
" assign ecs to Ctrl-C
inoremap <C-c> <Esc>
" Find files using Telescope command-line sugar.
nnoremap <C-P> <cmd>Telescope find_files<cr>
nnoremap <C-G> <cmd>Telescope live_grep<cr>
nnoremap <C-B>g <cmd>Telescope buffers<cr>
"" tab/buffer
let g:barbar_auto_setup = v:false
lua << EOF
require'barbar'.setup {
    highlight_alternate = true
}
EOF
noremap <C-T> :tabnew<CR>
noremap <C-N> :tabNext<CR>
" lualine setting
lua <<EOF
require('lualine').setup {
  options = { theme  = 'codedark'},
}
EOF
" Move to previous/next
nnoremap <silent> <C-B>h <Cmd>BufferPrevious<CR>
nnoremap <silent> <C-h> <Cmd>BufferPrevious<CR>
nnoremap <silent> <C-B>l <Cmd>BufferNext<CR>
nnoremap <silent> <C-l> <Cmd>BufferNext<CR>
" Re-order to previous/next
nnoremap <silent> <C-B>j <Cmd>BufferMovePrevious<CR>
nnoremap <silent> <C-j> <Cmd>BufferMovePrevious<CR>
nnoremap <silent> <C-B>k <Cmd>BufferMoveNext<CR>
nnoremap <silent> <C-k> <Cmd>BufferMoveNext<CR>
" Goto buffer in position...
nnoremap <silent> <C-B>1 <Cmd>BufferGoto 1<CR>
nnoremap <silent> <C-B>2 <Cmd>BufferGoto 2<CR>
nnoremap <silent> <C-B>3 <Cmd>BufferGoto 3<CR>
nnoremap <silent> <C-B>4 <Cmd>BufferGoto 4<CR>
nnoremap <silent> <C-B>5 <Cmd>BufferGoto 5<CR>
nnoremap <silent> <C-B>6 <Cmd>BufferGoto 6<CR>
nnoremap <silent> <C-B>7 <Cmd>BufferGoto 7<CR>
nnoremap <silent> <C-B>8 <Cmd>BufferGoto 8<CR>
nnoremap <silent> <C-B>9 <Cmd>BufferGoto 9<CR>
nnoremap <silent> <C-B>0 <Cmd>BufferLast<CR>
" Pin/unpin buffer
nnoremap <silent> <C-B>p <Cmd>BufferPin<CR>
" Close buffer
nnoremap <silent> <C-B>c <Cmd>BufferClose<CR>
" Restore buffer
nnoremap <silent> <C-B>z <Cmd>BufferRestore<CR>
" Magic buffer-picking mode
nnoremap <silent> <C-B>s  <Cmd>BufferPick<CR>
nnoremap <silent> <C-B>d  <Cmd>BufferPickDelete<CR>
" Git
nnoremap <Leader><C-A> :Gwrite<CR>
nnoremap <Leader>ga :!git add<Space>
nnoremap <Leader>gc :!git commit -m ''<LEFT>
nnoremap <Leader><C-P> :!git push<CR>
nnoremap <Leader>gp :!git push -u origin<Space>
nnoremap <Leader>gd :Gdiff<CR>
nnoremap <Leader>gb :Git blame<CR>
nnoremap <Leader>gs :Git status<CR>
nnoremap <Leader>g[ :GitGutterPrevHunk<CR>
nnoremap <Leader>g] :GitGutterNextHunk<CR>
nnoremap <Leader>gh :GitGutterLineHighlightsToggle<CR>
nnoremap <Leader>gv :GitGutterPreviewHunk<CR>
highlight GitGutterAdd ctermfg=green
highlight GitGutterChange ctermfg=blue
highlight GitGutterDelete ctermfg=red
" indent-blankline
let g:indent_blankline_space_char_blankline=" "
let g:indent_blankline_show_current_context=1
let g:indent_blankline_show_current_context_start=1
" indent setting
filetype indent on
autocmd FileType typescriptreact setlocal sw=2 sts=2 ts=2 et
autocmd FileType typescript setlocal sw=2 sts=2 ts=2 et
autocmd FileType javascriptreact setlocal sw=2 sts=2 ts=2 et
autocmd FileType javascript setlocal sw=2 sts=2 ts=2 et
" js/ts enter in bracket
autocmd FileType typescriptreact inoremap <C-CR> <CR><TAB><CR><Backspace><UP><C-c>$a
autocmd FileType typescript inoremap <C-CR> <CR><TAB><CR><Backspace><UP><C-c>$a
autocmd FileType javascriptreact inoremap <C-CR> <CR><TAB><CR><Backspace><UP><C-c>$a
autocmd FileType javascript inoremap <C-CR> <CR><TAB><CR><Backspace><UP><C-c>$a
" mark setting
nmap <Leader>m <Plug>(quickhl-manual-this)
xmap <Leader>m <Plug>(quickhl-manual-this)
nmap <Leader>M <Plug>(quickhl-manual-reset)
xmap <Leader>M <Plug>(quickhl-manual-reset)
" coc
set signcolumn=number
set updatetime=300
nmap <silent> <Leader>def <Plug>(coc-definition)
nmap <silent> <Leader>typ <Plug>(coc-type-definition)
nmap <silent> <Leader>imp <Plug>(coc-implementation)
nmap <silent> <Leader>ref <Plug>(coc-references)
nmap <silent> <Leader>rnm <Plug>(coc-rename)
nmap <silent> <Leader>fmt <Plug>(coc-format)
nmap <silent> <Leader>di :CocDiagnostics<CR>
nmap <silent> <Leader>li :CocList<CR>
nnoremap <silent> <Leader>k :call <SID>show_documentation()<CR>
function! s:show_documentation()
    if (index(['vim','help'], &filetype) >= 0)
        execute 'h '.expand('<cword>')
    elseif (coc#rpc#ready())
        call CocActionAsync('doHover')
    else
        execute '!' . &keywordprg . " " . expand('<cword>')
    endif
endfunction
nnoremap <silent> .f :CocCommand prettier.formatFile<CR>
" tree sitter
lua <<EOF
require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
  },
}
EOF
" Fern
nnoremap <C-f> :Fern . -drawer -reveal=% -toggle -width=33<CR>
let g:fern#default_hidden=1
let g:fern#renderer = "nerdfont"
" let g:fern#renderer#nerdfont#indent_markers = 1
augroup my-glyph-palette
  autocmd! *
  autocmd FileType fern call glyph_palette#apply()
  autocmd FileType nerdtree,startify call glyph_palette#apply()
augroup END
" autocomplete and move cursor
nnoremap ;; $
vnoremap ;; $
inoremap <C-;><C-;> <C-o>$
nnoremap '' ^
vnoremap '' ^
inoremap <C-'><C-'> <C-o>^

inoremap <C-l> <RIGHT>
inoremap <silent><expr> <C-j> coc#pum#visible() ? coc#pum#next(1) : "\<DOWN>"
inoremap <silent><expr> <C-k> coc#pum#visible() ? coc#pum#prev(1) : "\<UP>"
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<CR>"
inoremap <silent><expr> <Esc> coc#pum#visible() ? coc#pum#cancel() : "\<Esc>"
inoremap <silent><expr> <C-h> coc#pum#visible() ? coc#pum#cancel() : "\<LEFT>"
inoremap <silent><expr> <TAB> coc#pum#visible() ? coc#pum#next(1) : "\<Tab>"
inoremap <silent><expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<S-TAB>"
let g:coc_global_extensions = [
    \ 'coc-json',
    \ 'coc-yaml',
    \ 'coc-css',
    \ 'coc-pyright',
    \ 'coc-tsserver',
    \ 'coc-clangd',
    \ 'coc-cmake',
    \ 'coc-eslint',
    \ 'coc-prettier',
    \ 'coc-texlab',
    \ 'coc-go',
    \ 'coc-vetur',
    \ ]
" markdown
autocmd FileType markdown nnoremap <Leader>pre <Plug>MarkdownPreviewToggle
" Go settings
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_methods = 1
let g:go_highlight_fields = 1
let g:go_highlight_types = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1
let g:go_highlight_generate_tags = 1
let g:go_fmt_command = "goimports"
let g:gotests_template = ""
autocmd FileType go nnoremap <Leader>run :GoRun<CR>
autocmd FileType go nnoremap <Leader>gent :GoTests<CR>
autocmd FileType go nnoremap <Leader>gena :GoTestsAll<CR>
autocmd FileType go nnoremap <Leader>test :GoTest<CR>
autocmd FileType go nnoremap <Leader>vtest :!go test -v .<CR>
autocmd FileType go nnoremap <Leader>cov :GoCoverageToggle<CR>
" let g:go_bin_path="/usr/local/go/bin"
