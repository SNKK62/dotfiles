# dotfiles

configs for neovim and so on

### Neovim

```
~/.config/nvim (MacOS)
```

#### Requirements

- node
- (`brew install fsouza/prettierd/prettierd` now maybe not needed)
- `brew install lua-language-server`
- `brew install luarocks`

if error occurs while initializing neovim, try to fix

```bash
rm -Rf ~/.local/{share, state}/nvim
```

after launch nvim, try `:Mason` and search and install `eslint_d`, `stylua` and `luacheck`

### VScode

```
~/Library/Application Support/Code/User (MacOS)

~/Library/Application Support/Code/User/settings.json
~/Library/Application Support/Code/User/keybindings.json
```

### Rust

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
# set PATH properly
rustup component add clippy
```

### HammerSpoon

[https://www.hammerspoon.org/](https://www.hammerspoon.org/)

```
ln -s ${PWD}/.hammerspoon/ ~/.hammerspoon
```

### zsh

write the following in `/etc/zshenv`

```bash
ZDOTDIR=$HOME/.config/zsh
```

```
brew install starship

ln -s ${PWD}/zsh ~/.config/zsh (in /zsh dir)(MacOS)

# for using angigen
curl -L git.io/antigen > ~/.local/bin/antigen.zsh
```

### Mac

layout

```
cp ./mac/option_blank_layout.keylayout ~/Library/Keyboard\ Layouts
```

enable to hold keyboard

```bash
defaults write -g ApplePressAndHoldEnabled -bool false (requires restart after this command)
```

### Font

- HackGen<br>
  [https://github.com/yuru7/HackGen/releases](https://github.com/yuru7/HackGen/releases)

### CLI

```bash
brew install coreutils
brew install gh
brew install ghq
brew install fzf
brew install ripgrep
brew install bat
brew install lsd
brew install neofetch
brew install git-delta

git config --global ghq.root ~/workspace

```

add settings below in `~/.gitconfig`

```
[pager]
        diff = delta
        log = delta
        reflog = delta
        show = delta
[delta]
        plus-style = "syntax #012800"
        minus-style = "syntax #340001"
        syntax-theme = zenburn
        navigate = true
        line-numbers = true
        keep-plus-minus-markers
[interactive]
        diffFilter = delta --color-only
[alias]
        diff-side-by-side = -c delta.features=side-by-side diff
```

### AeroSpace

#### installation

```bash
brew install --cask nikitabobko/tap/aerospace
```

#### configuration

```bash
ln -s ${PWD}/aerospace ~/.config/aerospace
```

### WezTerm

#### installation

```bash
brew install --cask wezterm
```

#### configuration

```bash
ln -s ${PWD}/wezterm ~/.config/wezterm
```

### Zellij

#### installation

```bash
brew install zellij
```

#### configuration

```bash
ln -s ${PWD}/zellij ~/.config/zellij
```

I want to use `Super` modifier key, but now it seems not to be supported.<br>
So I use `Alt(+Shift)+[0-9]` key for temporary workaround.<br>
For details, `Super+h` is remapped to `Alt+1` in wezterm config.

