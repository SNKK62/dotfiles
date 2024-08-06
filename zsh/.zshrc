eval "$(/opt/homebrew/bin/brew shellenv)"

# setting
# permission for new files
umask 027
# prevent remaining core dump
limit coredumpsize 0

# homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# antigen
source $HOME/.local/bin/antigen.zsh

# Load the oh-my-zsh's library
antigen use oh-my-zsh

antigen bundles <<EOBUNDLES
    # Bundles from the default repo (robbyrussell's oh-my-zsh)
    git
    # Syntax highlighting bundle.
    zsh-users/zsh-syntax-highlighting
    # Fish-like auto suggestions
    zsh-users/zsh-autosuggestions
    # Extra zsh completions
    zsh-users/zsh-completions
    # z
    rupa/z z.sh
    # abbr
    olets/zsh-abbr@main
EOBUNDLES

# Load the theme
antigen theme robbyrussell

# Tell antigen that you're done
antigen apply

alias ls='ls -F --color=auto'
alias vi='nvim'
alias vim='nvim'

eval "$(starship init zsh)"
