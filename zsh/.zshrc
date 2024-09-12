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
# antigen theme robbyrussell

# Tell antigen that you're done
antigen apply

alias vi='nvim'

# starship
eval "$(starship init zsh)"

function fzf-history-selection() {
    BUFFER=`history -n 1 | tac  | awk '!a[$0]++' | fzf --prompt="command history > " --query "$LBUFFER"`
    CURSOR=$#BUFFER
    zle reset-prompt
}

zle -N fzf-history-selection
bindkey '^R' fzf-history-selection

# cdr
if [[ -n $(echo ${^fpath}/chpwd_recent_dirs(N)) && -n $(echo ${^fpath}/cdr(N)) ]]; then
    autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
    add-zsh-hook chpwd chpwd_recent_dirs
    zstyle ':completion:*' recent-dirs-insert both
    zstyle ':chpwd:*' recent-dirs-default true
    zstyle ':chpwd:*' recent-dirs-max 1000
    zstyle ':chpwd:*' recent-dirs-file "$HOME/.cache/chpwd-recent-dirs"
fi

function fzf-cdr () {
    local selected_dir="$(cdr -l | sed -r 's/^[0-9]+ +//' | fzf --prompt="cdr > " --query "$LBUFFER")"
    if [ -n "$selected_dir" ]; then
        BUFFER="cd ${selected_dir}"
        zle accept-line
    else
        BUFFER=""
        zle reset-prompt
    fi
}
zle -N fzf-cdr
bindkey '^E' fzf-cdr

function cdrepo() {
    local repodir=$(ghq list | fzf -1 +m)
    cd $(ghq root)/$repodir
}

# gh
eval "$(gh completion -s zsh)"

function ghcr() {
    gh repo create "$@"
    ghq get $1
}
function ghcr-code()  {
    ghcr "$@"
    code $(ghq list --full-path -e $1)
}

export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!**/.git/*"'
export FZF_DEFAULT_OPTS="
    --height 50%
    --reverse
    --border=sharp
    --margin=0,1
    --prompt=' '
    --bind ctrl-K:preview-up,ctrl-J:preview-down
"

export BAT_THEME="TwoDark"

# fzf with preview
function fzfp() {
  local cmd preview_cmd out q n selected_file
  preview_cmd="bat --color=always --style=header,grid {}"

  while out=$(
    fzf --preview $preview_cmd --preview-window=right:60% --exit-0 --expect=ctrl-p,enter "$@"
  ); do
    q=$(head -1 <<< "$out")
    n=1
    selected_file=`echo $(tail "-$n" <<< "$out")`
    if [ "$q" = ctrl-p ]; then
      bat $selected_file
    elif [ "$q" = enter ]; then
      echo $selected_file
      break
    fi
  done
}

fcd() {
    local show_hidden=false
    local target_dir="."

    while getopts "a" opt; do
      case "$opt" in
        a) show_hidden=true ;;
      esac
    done
    shift $((OPTIND - 1))

    if [[ -n "$1" ]]; then
      target_dir="$1"
    fi

    if $show_hidden; then
      dir=$(find "$target_dir" \( -path '*/.git' -o -path '*/.git/*' \) -prune \
            -o -type d -print 2> /dev/null | fzf +m)
    else
        dir=$(find "$target_dir" \( -path '*/\.*' -o -path '*/node_modules/*' \) -prune -o -type d -print 2> /dev/null | fzf +m)
    fi

    [[ -n "$dir" ]] && cd "$dir"
}

fvi() {
    local out q n file
    while out=$(
        rg --files --hidden --follow --glob "!**/.git/*" | fzfp --expect=ctrl-c
    ); do
        q=$(head -1 <<< "$out")
        n=$[$(wc -l <<< "$out") - 1]
        file=(`echo $(tail "-$n" <<< "$out")`)
        [[ -z "$file" ]] && continue
        if [ "$q" = ctrl-c ]; then
            break
        else
            vi "$file"
            break
        fi
    done
}

# git checkout
fgc() {
    local branch
    branch=$(git branch $@ | grep -v HEAD |
            fzf-tmux -d $(( 2 + $(wc -l <<< "$branches") )) +m)
    git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}

# git add, diff
fga() {
  local out q n addfiles preview_cmd
  preview_cmd="git diff {} | delta"
  while out=$(
    git status --short |
    awk '{if (substr($0,2,1) !~ / /) print $2}' |
    fzf-tmux --preview $preview_cmd --preview-window=right:70% --multi --exit-0 --expect=ctrl-d
  ); do
    q=$(head -1 <<< "$out")
    n=$[$(wc -l <<< "$out") - 1]
    addfiles=(`echo $(tail "-$n" <<< "$out")`)
    [[ -z "$addfiles" ]] && continue
    if [ "$q" = ctrl-d ]; then
      git diff-side-by-side $addfiles
    else
      git add $addfiles
    fi
  done
}

# git branch
fgb() {
  local out q n selected_branches
  while out=$(
      git branch $@ | grep -v HEAD |
          fzf-tmux --multi --exit-0 --expect=ctrl-d,enter
  ); do
    q=$(head -1 <<< "$out")
    n=$[$(wc -l <<< "$out") - 1]
    selected_branches=(`echo $(tail "-$n" <<< "$out")`)
    if [ "$q" = ctrl-d ]; then
      [[ -z "$selected_branches" ]] && continue
      git branch -D $selected_branches
      break
    elif [ "$q" = enter ]; then
      echo $selected_branches
      break
    fi
  done
}

# delta
export DELTA_PAGER="less -Rf"
# git
alias g='git'
alias ga='git add'
alias gd='git diff'
alias gds='git diff-side-by-side'
alias gc='git commit -m'
alias gp='git push'
alias gs='git status'
alias gb='git branch'
alias gcb='git checkout -b'

alias cdroot='cd `git rev-parse --show-toplevel`'

# ls
alias ls='lsd -F --icon never'
alias ll='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias lf='fzfp'
# lsd --tree
lt() {
  local show_all=false
  local target_dir="."

  while getopts "a" opt; do
    case "$opt" in
      a) show_all=true ;;
    esac
  done
  shift $((OPTIND - 1))

  if [[ -n "$1" ]]; then
    target_dir="$1"
  fi

  local cmd="ls --tree --ignore-glob '.git' --ignore-glob 'node_modules'"

  if $show_all; then
    eval "$cmd $target_dir"
  else
    eval "$cmd -d $target_dir"
  fi
}

