# Jeder's NVIM config

This is Jeder's NVIM default config. It is based on JavaScript, LaTeX, Python and C++ coding. If you don't want LaTeX plugins, use the `nolatex` branch.

## OSC52 Clipboard Setup

This config includes `clipboard.lua` for SSH clipboard support.

It is mainly intended for this setup:

```text
macOS Terminal.app -> osc52pty -> SSH -> Linux -> nvim
```

### Direction supported

This config supports copying **from remote Neovim to the local macOS clipboard**:

```text
Linux Neovim -> macOS clipboard
```

It does **not** sync arbitrary macOS clipboard changes back into Neovim's `"+` register:

```text
macOS clipboard -> Neovim "+ register
```

So if you copy text in a macOS app, `:reg +` inside remote Neovim may stay unchanged. This is expected.

### Why paste/read is disabled

Many terminal setups support OSC52 copy but do not support OSC52 clipboard read/paste, often for security reasons. In this environment, trying to read the clipboard through OSC52 can hang Neovim. For that reason, this config intentionally uses a **copy-only** OSC52 provider.

### Install `osc52pty` for macOS Terminal.app

macOS Terminal.app does not support OSC52 directly, so start SSH through `osc52pty`.

```bash
brew install go
go install github.com/roy2220/osc52pty@latest
echo 'export PATH="$PATH:$HOME/go/bin"' >> ~/.zshrc
source ~/.zshrc
```

Start a wrapped shell:

```bash
osc52pty zsh
```

Then SSH from inside that shell:

```bash
ssh user@your-linux-host
```

### Load the clipboard config

Add this near the top of `~/.config/nvim/init.vim`:

```vim
source ~/.config/nvim/clipboard.lua
```

### Usage over SSH

Copy from remote Neovim to macOS clipboard:

```vim
"+y
"+yy
yy
```

Paste into macOS apps with:

```text
Cmd+V
```

Paste from macOS into remote Neovim with terminal paste:

```text
i
Cmd+V
Esc
```

Do not expect this to update Neovim's `"+` register from macOS clipboard.

### Local Linux desktop

When running Neovim directly inside a Linux desktop terminal, use normal Linux clipboard tools instead of OSC52.

For Wayland:

```bash
sudo apt install wl-clipboard
```

For X11:

```bash
sudo apt install xclip
# or
sudo apt install xsel
```

Then normal clipboard operations should work:

```vim
"+y
"+p
```

### Debugging

Inside Neovim:

```vim
:checkhealth provider
:echo has('clipboard')
:echo $SSH_TTY
:echo $SSH_CONNECTION
:reg +
```

Test OSC52 copy outside Neovim from the SSH session:

```bash
printf 'hello from shell' | base64 | tr -d '\n' | awk '{printf "\033]52;c;%s\007", $0}'
```

Then paste locally on macOS with `Cmd+V`.

If the terminal becomes garbled after killing Neovim:

```bash
stty sane
reset
```
