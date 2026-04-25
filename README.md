# Jeder's NVIM config

This is Jeder's NVIM default config. It is based on JavaScript, LaTeX, Python and C++ coding. If you don't want LaTeX plugins, use the `nolatex` branch.

## OSC52 Clipboard Setup

This config includes a custom `clipboard.lua` for copying text from remote Neovim to the local clipboard when using SSH.

It is mainly intended for this setup:

```text
macOS Terminal.app -> osc52pty -> SSH -> Linux -> nvim
```

Neovim has built-in OSC52 clipboard support, but in this setup the built-in provider may leak text such as `+q4D73` or hang when reading clipboard data. This config disables Neovim’s OSC52 detection query and uses a copy-only OSC52 provider that writes directly to Neovim’s stderr channel. Neovim documents `g:termfeatures.osc52 = false` as the way to disable OSC52 queries, and OSC52 clipboard providers write escape sequences for the terminal to handle. :contentReference[oaicite:0]{index=0}

### 1. Install `osc52pty` on macOS Terminal.app

macOS Terminal.app does not support OSC52 directly, so use `osc52pty` as a wrapper. The `osc52pty` project is specifically a workaround for Terminal.app and requires the Go toolchain. :contentReference[oaicite:1]{index=1}

```bash
brew install go
go install github.com/roy2220/osc52pty@latest
echo 'export PATH="$PATH:$HOME/go/bin"' >> ~/.zshrc
source ~/.zshrc
```

Check it:

```bash
which osc52pty
```

### 2. Start SSH through `osc52pty`

On macOS Terminal.app:

```bash
osc52pty zsh
```

Then SSH from inside that wrapped shell:

```bash
ssh user@your-linux-host
```

Do not start `nvim` from a normal Terminal.app SSH session if you want OSC52 clipboard copy to work with Terminal.app.

### 3. Add `clipboard.lua`

Create this file:

```text
~/.config/nvim/clipboard.lua
```

This file detects SSH sessions and enables the OSC52 copy-only provider. For local Linux desktop terminals, it leaves clipboard handling to Neovim’s normal provider detection.

### 4. Load it from `init.vim`

Add this near the top of `~/.config/nvim/init.vim`, before plugin setup:

```vim
" Clipboard setup.
" - SSH/macOS Terminal.app path: OSC52 via stderr.
" - Local Linux desktop: normal wl-copy/xclip/xsel provider.
source ~/.config/nvim/clipboard.lua
```

Loading this early is important because clipboard providers can be initialized by plugins or other settings.

### 5. Usage over SSH

In remote Neovim:

```vim
"+y
"+yy
yy
```

These copy text from remote Neovim to the local macOS clipboard.

Then paste into macOS apps with:

```text
Cmd+V
```

Because OSC52 clipboard reading is unreliable in this Terminal.app + `osc52pty` setup, `"+p` does not fetch arbitrary current macOS clipboard content. It only returns the last text copied by Neovim through this provider. Neovim users have reported hangs when OSC52 paste/read waits for a terminal response, so this config intentionally avoids querying the terminal clipboard. :contentReference[oaicite:2]{index=2}

For macOS clipboard to remote Neovim, use terminal paste:

```text
i
Cmd+V
Esc
```

### 6. Local Linux desktop usage

When running Neovim directly inside a Linux desktop terminal, do not use `osc52pty`.

Install a normal Linux clipboard provider instead:

```bash
# Wayland
sudo apt install wl-clipboard

# X11
sudo apt install xclip
# or
sudo apt install xsel
```

Then use normal Neovim clipboard operations:

```vim
"+y
"+p
```

Neovim detects common clipboard tools such as `wl-copy`, `wl-paste`, `xclip`, and `xsel` through its clipboard provider system. :contentReference[oaicite:3]{index=3}

### 7. Test OSC52 outside Neovim

Inside the SSH session started through `osc52pty`, run:

```bash
printf 'hello from shell' | base64 | tr -d '\n' | awk '{printf "\033]52;c;%s\007", $0}'
```

Then press `Cmd+V` in a macOS app.

Expected result:

```text
hello from shell
```

If this does not work, fix `osc52pty` or the terminal wrapper first before debugging Neovim.

### 8. Debugging

Inside Neovim:

```vim
:checkhealth provider
:echo has('clipboard')
:echo $SSH_TTY
:echo $SSH_CONNECTION
```

If strange characters appear after killing Neovim, reset the terminal:

```bash
stty sane
reset
```

### 9. Expected behavior summary

```text
SSH through osc52pty:
  "+y / yy  -> copy remote Neovim text to macOS clipboard
  "+p       -> paste last Neovim-copied text only
  Cmd+V     -> paste macOS clipboard into Neovim insert mode

Local Linux desktop:
  "+y       -> copy to Linux desktop clipboard
  "+p       -> paste from Linux desktop clipboard
```
