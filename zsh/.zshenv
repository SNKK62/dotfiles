# XDG
export XDG_CONFIG_HOME=${HOME}/.config
export XDG_CACHE_HOME=${HOME}/.cache
export XDG_DATA_HOME=${HOME}/.local/share
export XDG_STATE_HOME=${HOME}/.local/state

# path
export PATH=${HOME}/.local/bin:$PATH
export PATH="/usr/local/sbin:$PATH"

# anaconda3
export PATH=$HOME/Environments/anaconda3/bin/python:$PATH
export PATH=$HOME/Environments/anaconda3/bin/python3:$PATH
export PATH=$HOME/Environments/anaconda3/bin:$PATH

# java
export JAVA_HOME=$HOME/Environments/jdk-21
# export JAVA_HOME=/opt/homebrew/Cellar/openjdk/21.0.3/libexec/openjdk.jdk/Contents/Home
export PATH=$JAVA_HOME/Contents/Home/bin:$PATH

# VSCode
export PATH="/usr/local/bin/code:$PATH"

# go
export GOPATH="$HOME/go"
export GOROOT="/usr/local/go"
export PATH="$GOROOT/bin:$PATH"

# Rust
export RUST_PATH="$HOME/.cargo/bin"
export PATH="$RUST_PATH:$PATH"

# lang
export LANGUAGE="en_US.UTF-8"
export LANG="${LANGUAGE}"
export LC_ALL="${LANGUAGE}"
export LC_CTYPE="${LANGUAGE}"

# editor
export EDITOR=vim
export CVSEDITOR="${EDITOR}"
export SVN_EDITOR="${EDITOR}"
export GIT_EDITOR="${EDITOR}"

# history
# destination file for history
export HISTFILE=${HOME}/.config/zsh/.zsh_history
# num of history in memory
export HISTSIZE=1000
# num of history in file
export SAVEHIST=100000
export HISTFILESIZE=100000
# ignore duplicates in a row
setopt hist_ignore_dups
# report the time when the command was started and when it was finished
setopt EXTENDED_HISTORY
# ignore duplicates over the whole history
setopt hist_ignore_all_dups
# ignore commands that start with a space
setopt hist_ignore_space
# enable to edit commands before executing them
setopt hist_verify
# remove surplus blanks
setopt hist_reduce_blanks
# ignore duplicates when saving history on file
setopt hist_save_no_dups
# not register history command
setopt hist_no_store
# exxpand history on completion
setopt hist_expand
# share history between all sessions
setopt share_history
setopt inc_append_history
# setopt no_share_history
# unsetopt share_history

# other
# confirm before showing a huge number of candidates
export LISTMAX=50
# set background job's ionice to same as bash
unsetopt bg_nice
# 補完候補を詰めて表示
# display completion candidates compactly
setopt list_packed
# disable beep
setopt no_beep

export _ANTIGEN_INSTALL_DIR=${HOME}/.local/bin
