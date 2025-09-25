set number

call plug#begin()
Plug 'nvim-tree/nvim-tree.lua'
Plug 'nvim-lualine/lualine.nvim'
Plug 'luochen1990/rainbow'
Plug 'sbdchd/neoformat'

" Use release branch (recommended)
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'honza/vim-snippets'

" Buffer Related
Plug 'nvim-lua/plenary.nvim'
Plug 'wasabeef/bufferin.nvim'
Plug 'willothy/nvim-cokeline'

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" Debug Stuff
Plug 'mfussenegger/nvim-dap'
Plug 'mfussenegger/nvim-dap-python'
Plug 'mxsdev/nvim-dap-vscode-js'

" Session Manager
Plug 'nvim-lua/plenary.nvim'
Plug 'Shatur/neovim-session-manager'

" Copilot
Plug 'CopilotC-Nvim/CopilotChat.nvim'

" Markdown Live Preview
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}

" Fzf
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'ibhagwan/fzf-lua'


call plug#end()

let g:rainbow_active = 1 "set to 0 if you want to enable it later via :RainbowToggle
let g:neoformat_lua_luaformat = {
			\ 'exe': 'lua-format',
			\ 'args': ['--indent-width=4', '--tab-width=4']
\ }

let g:neoformat_tex_prettierd = {
        \ 'exe': 'prettierd',
        \ 'args': ['--tab-width 4'],
        \ 'stdin': 1,
        \ 'valid_exit_codes': [0],
        \ 'no_append': 1
        \}

" Default Tab settings
set tabstop=4
set shiftwidth=4
set expandtab

set mouse=nvi

" Set special highlight
set background=light

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
            \'coc-pyright',
            \'@yaegassy/coc-volar'
            \]

" Color the line number
highlight LineNr ctermfg=58 gui=NONE

lua << EOF
require("CopilotChat").setup()
EOF


source ~/.config/nvim/nvimtree.lua
source ~/.config/nvim/lualine.lua
source ~/.config/nvim/coc.lua
source ~/.config/nvim/dap.lua
source ~/.config/nvim/treesitter.lua
source ~/.config/nvim/session-manager.lua
source ~/.config/nvim/buffer.lua
source ~/.config/nvim/fzf.lua
