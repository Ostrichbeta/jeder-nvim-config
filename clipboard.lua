-- ~/.config/nvim/clipboard.lua
--
-- Clipboard setup for two environments:
--
-- 1. SSH session, especially:
--      macOS Terminal.app -> osc52pty -> SSH -> Linux -> nvim
--
--    Uses OSC52 copy through Neovim stderr.
--    This avoids the leaked "+q4D73" terminal query and avoids OSC52 paste/read hangs.
--
-- 2. Local Linux desktop terminal:
--    Lets Neovim use normal clipboard tools such as wl-copy/wl-paste,
--    xclip, or xsel.

local is_ssh = vim.env.SSH_TTY ~= nil
  or vim.env.SSH_CONNECTION ~= nil
  or vim.env.SSH_CLIENT ~= nil

-- Always disable Neovim's OSC52 feature detection query in SSH.
-- This is the part that caused "+q4D73" in your macOS Terminal.app setup.
if is_ssh then
  vim.g.termfeatures = { osc52 = false }
end

local function setup_ssh_osc52_clipboard()
  local b64chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"

  local function base64_encode(data)
    return ((data:gsub(".", function(x)
      local r, b = "", x:byte()

      for i = 8, 1, -1 do
        r = r .. (b % 2 ^ i - b % 2 ^ (i - 1) > 0 and "1" or "0")
      end

      return r
    end) .. "0000"):gsub("%d%d%d?%d?%d?%d?", function(x)
      if #x < 6 then
        return ""
      end

      local c = 0

      for i = 1, 6 do
        c = c + (x:sub(i, i) == "1" and 2 ^ (6 - i) or 0)
      end

      return b64chars:sub(c + 1, c + 1)
    end) .. ({ "", "==", "=" })[#data % 3 + 1])
  end

  local last_lines = { "" }
  local last_regtype = "v"

  local function osc52_copy(lines, regtype)
    last_lines = vim.deepcopy(lines)
    last_regtype = regtype or "v"

    local text = table.concat(lines, "\n")

    -- Preserve final newline for linewise yanks, e.g. yy / "+yy.
    if regtype == "V" then
      text = text .. "\n"
    end

    local encoded = base64_encode(text)
    local seq = "\027]52;c;" .. encoded .. "\007"

    -- Critical part:
    -- Send OSC52 directly to Neovim's stderr channel.
    -- External commands via system() are captured by Neovim and may not reach
    -- Terminal.app / osc52pty.
    vim.api.nvim_chan_send(vim.v.stderr, seq)
  end

  local function no_terminal_paste()
    -- Do not query terminal clipboard through OSC52.
    -- In this setup, OSC52 read/paste can hang forever.
    --
    -- This makes "+p paste the last thing Neovim copied, instead of asking
    -- macOS Terminal.app for the current clipboard.
    return {
      vim.deepcopy(last_lines),
      last_regtype,
    }
  end

  vim.g.clipboard = {
    name = "OSC52-stderr-copy-only",

    copy = {
      ["+"] = osc52_copy,
      ["*"] = osc52_copy,
    },

    paste = {
      ["+"] = no_terminal_paste,
      ["*"] = no_terminal_paste,
    },

    cache_enabled = 0,
  }

  vim.opt.clipboard = "unnamedplus"
end

local function setup_local_desktop_clipboard()
  -- Local Linux desktop:
  -- Let Neovim use its normal provider detection.
  --
  -- Wayland: install wl-clipboard.
  -- X11: install xclip or xsel.
  vim.opt.clipboard = "unnamedplus"
end

if is_ssh then
  setup_ssh_osc52_clipboard()
else
  setup_local_desktop_clipboard()
end
