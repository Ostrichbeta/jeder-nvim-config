local is_picking_focus = require("cokeline.mappings").is_picking_focus
local is_picking_close = require("cokeline.mappings").is_picking_close

require("bufferin").setup({show_window_layout = true})
require("cokeline").setup(
    {
        components = {
            {
                text = function(buffer)
                    return (buffer.index ~= 1) and "▏" or ""
                end
            },
            {text = " "},
            {
                text = function(buffer)
                    return (buffer.is_focused) and "--> " or ""
                end
            },
            {
                text = function(buffer)
                    return (is_picking_focus() or is_picking_close()) and buffer.pick_letter .. " " or
                        (buffer.index) .. " "
                end,
                italic = function()
                    return (is_picking_focus() or is_picking_close())
                end,
                bold = function()
                    return (is_picking_focus() or is_picking_close())
                end
            },
            {text = ""},
            {
                text = function(buffer)
                    return buffer.filename .. ""
                end,
                bold = function(buffer)
                    return buffer.is_focused
                end
            },
            {
                text = function(buffer)
                    return (buffer.is_focused) and " <--" or ""
                end
            },
            {text = " "},
            {
                text = "X",
                on_click = function(_, _, _, _, buffer)
                    buffer:delete()
                end
            },
            {text = "  "}
        },
        sidebar = {
            filetype = {"NvimTree"},
            components = {{text = function(buf)
                        return buf.filetype
                    end}}
        }
    }
)

-- Set key bindings
vim.keymap.set(
    "n",
    "<leader>bp",
    function()
        require("cokeline.mappings").pick("focus")
    end,
    {desc = "Pick a buffer to focus"}
)
vim.keymap.set("n", "<Leader>p", "<Plug>(cokeline-focus-prev)", {silent = true})
vim.keymap.set("n", "<Leader>n", "<Plug>(cokeline-focus-next)", {silent = true})
vim.keymap.set(
    "n",
    "<leader>bd",
    function()
        local cbn = vim.api.nvim_get_current_buf()
        local buffers = vim.fn.getbufinfo({buflisted = true})
        local size = 0
        local idx = 0
        for n, e in ipairs(buffers) do
            size = size + 1
            if e.bufnr == cbn then
                idx = n
            end
        end

        if idx == 0 then
            return
        end

        -- if idx == size then
        vim.cmd("bprevious")
        -- else
        --    vim.cmd("bnext")
        -- end
        vim.cmd("bdelete " .. cbn)
    end,
    {desc = "Close buffer and switch to previous"}
)
