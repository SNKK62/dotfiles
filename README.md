# dotfiles

configs for neovim, tmux and bash

### Neovim

```
~/.config/nvim (MacOS)
```

#### Requirements

- node
- `brew install fsouza/prettierd/prettierd`

if error occurs while initializing neovim, try to fix

```bash
rm -Rf ~/.local/{share, state}/nvim
```

### VScode

```
~/Library/Application Support/Code/User (MacOS)

~/Library/Application Support/Code/User/settings.json
~/Library/Application Support/Code/User/keybindings.json
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

### Font

- HackGen

[github.com/yuru7/HackGen/releases](github.com/yuru7/HackGen/releases)
