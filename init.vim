set number

call plug#begin()
Plug 'nvim-tree/nvim-tree.lua'
Plug 'nvim-lualine/lualine.nvim'
Plug 'luochen1990/rainbow'
Plug 'sbdchd/neoformat'
Plug 'lervag/vimtex'

" Use release branch (recommended)
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'honza/vim-snippets'

" Buffer Related
Plug 'nvim-lua/plenary.nvim'
Plug 'j-morano/buffer_manager.nvim'

" Markdown Live Preview
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
call plug#end()

let g:rainbow_active = 1 "set to 0 if you want to enable it later via :RainbowToggle
let g:neoformat_lua_luaformat = {
			\ 'exe': 'lua-format',
			\ 'args': ['--indent-width=2', '--tab-width=2']
\ }
" let g:latexindent_opt="-m"
" Use Tex-Fmt to format the file
let g:neoformat_tex_texfmt = {
            \ 'exe': 'tex-fmt',
            \ 'args': ['-s', '-q', '-p', '--tab 4', '--wrap 160'],
            \ 'stdin': 1,
            \ 'valid_exit_codes': [0],
            \ 'no_append': 1
            \}
let g:neoformat_enabled_tex = ['texfmt']

" VimTeX
filetype plugin indent on
syntax enable
let g:vimtex_view_method = 'skim'
let g:vimtex_compiler_latexmk = { 
        \ 'executable' : 'latexmk',
        \ 'options' : [ 
        \   '-xelatex',
        \   '-file-line-error',
        \   '-synctex=1',
        \   '-interaction=nonstopmode',
        \ ],
        \}
let g:vimtex_compiler_latexmk_engines = {
    \ '_'                : '-xelatex',
    \}
" Default Tab settings
set tabstop=4
set shiftwidth=4
set expandtab

set mouse=nvi

" Set special highlight
set background=dark

" Fuzzy completion
set wildoptions+=fuzzy

" Split settings
set splitright
set splitbelow

" Rainbow Setting
let g:rainbow_conf = {
\	'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick'], 
\	'ctermfgs': ['darkblue', 'darkyellow', 'darkcyan', 'darkmagenta'],}

" Coc Settings
hi CocMenuSel ctermbg=249
let g:tex_flavor = "latex"
let g:coc_global_extensions = [
            \'coc-json',
            \'coc-tsserver',
            \'coc-snippets',
            \'coc-pyright'
            \]

" Color the line number
highlight LineNr ctermfg=58 gui=NONE

source ~/.config/nvim/nvimtree.lua
source ~/.config/nvim/lualine.lua
source ~/.config/nvim/coc.lua
source ~/.config/nvim/buffer_manager.lua 

