-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- optionally enable 24-bit colour
vim.opt.termguicolors = false

-- empty setup using defaults
require("nvim-tree").setup()

-- OR setup with some options
require("nvim-tree").setup({
  renderer = {
    icons = {
      show = {
        file = false,
        folder = false,
        folder_arrow = false,
        git = false,
        modified = false,
        hidden = false,
        diagnostics = false,
        bookmarks = false
      }
    }
  },
  sort = {sorter = "filetype"},
  view = {width = 30},
  filters = {dotfiles = true}
})
