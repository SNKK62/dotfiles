if [ -f ~/.env ]; then
  source ~/.env
fi

# setting
# permission for new files
umask 027
# prevent remaining core dump
limit coredumpsize 0

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
bindkey '^T' fzf-cdr

function cdrepo() {
    local repodir=$(ghq list | fzf)
     if [ -z "$repodir" ]; then
        echo "No repository selected. Exiting."
        return 1
    fi

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
    --bind='ctrl-B:preview-up,ctrl-F:preview-down'
    --bind='ctrl-P:preview-page-up,ctrl-N:preview-page-down'
"

export BAT_THEME="TwoDark"

# fzf with preview
function fzfp() {
  local cmd preview_cmd out q n selected_file
  preview_cmd="bat --color=always --style=header,grid {}"

  while out=$(
    fzf --preview $preview_cmd --preview-window=right:60% --exit-0 --expect=ctrl-p,ctrl-c,enter "$@"
  ); do
    q=$(head -1 <<< "$out")
    n=1
    selected_file=`echo $(tail "-$n" <<< "$out")`
    if [ "$q" = ctrl-p ]; then
      bat $selected_file
    elif [ "$q" = ctrl-c ]; then
      break
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
    local out=$(rg --files --hidden --follow --glob "!**/.git/*" | fzfp);
    [[ -z "$out" ]] && return 1
    vi "$out"
}

# ssh
function fssh() {
  local host=$(grep -E "^Host " ~/.ssh/config | sed -e 's/Host[ ]*//g' | fzf)
  if [ -n "$host" ]; then
    ssh $host
  fi
}

# git add, diff
fga() {
  local out q n addfiles preview_cmd
  while out=$(
    git status --short |
    awk '{
      if (substr($0,2,1) !~ / /) {
        if ($1 == "??") {
            print $2 " (new)"
        } else if ($1 == "D") {
            print $2 " (deleted)"
        } else {
            print $2 " (modified)"
        }
      } 
    }' |
        fzf --preview '[[ {2} == "(new)" ]] && bat {1} --color=always --style=header,grid || [[ {2} == "(deleted)" ]] && ext=$(echo {1} | awk -F. "{if (NF>1 && \$1 != \"\") print \$NF; else print \"txt\"}") && git show HEAD:$(echo $(pwd)/{1} | sed "s|$(git rev-parse --show-toplevel)/||") | bat --color=always --style=header,grid --language $ext || git diff {1} | delta' --preview-window=right:70%:wrap --multi --exit-0 --expect=ctrl-d
  ); do
    q=$(head -1 <<< "$out")
    n=$[$(wc -l <<< "$out") - 1]
    addfiles=(`echo $(tail "-$n" <<< "$out") | sed 's/(new)//g; s/(deleted)//g; s/(modified)//g'`)
    [[ -z "$addfiles" ]] && continue
    if [ "$q" = ctrl-d ]; then
      git diff-side-by-side $addfiles
    else
      git add $addfiles
    fi
  done
}

# git diff
fgd() {
  local selected preview_cmd
  preview_cmd="git diff {} | delta"
  selected=$(
    git status --short |
    awk '{
      if (substr($0,2,1) !~ / /) {
        if ($1 == "??") {
            print $2 " (new)"
        } else if ($1 == "D") {
            print $2 " (deleted)"
        } else {
            print $2 " (modified)"
        }
      } 
    }' |
    fzf --preview '[[ {2} == "(new)" ]] && bat {1} --color=always --style=header,grid || [[ {2} == "(deleted)" ]] && ext=$(echo {1} | awk -F. "{if (NF>1 && \$1 != \"\") print \$NF; else print \"txt\"}") && git show HEAD:$(echo $(pwd)/{1} | sed "s|$(git rev-parse --show-toplevel)/||") | bat --color=always --style=header,grid --language $ext || git diff {1} | delta' --preview-window=right:70%:wrap --multi --exit-0 --expect=ctrl-d
  )
  selected=(`echo $selected | sed 's/(new)//g; s/ (deleted)//g; s/ (modified)//g'`)
  if [ -n "$selected" ]; then
    git diff-side-by-side $selected
  fi
}

# git reflog
fgref() {
  local selected preview_cmd opt args
  preview_cmd="echo '{}' | cut -d ' ' -f 1 | xargs -I@ git diff --stat --patch @^ @ | delta"
  selected=$(
    git reflog |
    fzf --preview $preview_cmd --preview-window=right:70%:wrap --exit-0
  )
  if [ -z $selected ]; then
      return 1
  fi
  args=()
  while [[ $# -gt 0 ]]; do
    case $1 in
      --hard|-h|--mixed|-m|--soft|-s)  opt="$1"; shift;;
      -*|--*) echo "[ERROR] Unknown option $1"; return 1;;
      *) args+=("$1"); shift;;
    esac
  done
  set -- "${args[@]}"  # set $1, $2, ...

  if [ -z $opt ]; then
    # copy commit hash to clipboard
    echo $selected | cut -d ' ' -f 1 | pbcopy # work on Mac // TODO: for Linux
  else
    git reset $opt `echo $selected | cut -d ' ' -f 1` $@
  fi
}

# git branch
fgb() {
  local out q n selected_branch new_branch_name
  while out=$(
      git branch $@ | grep -v HEAD |
          fzf --expect=ctrl-c,ctrl-d,ctrl-p,ctrl-n,enter
  ); do
    q=$(head -1 <<< "$out")
    selected_branch=`echo $(tail -1 <<< "$out")`
    if [ "$q" = ctrl-c ]; then
      break
    elif [ "$q" = ctrl-d ]; then
      [[ -z "$selected_branch" ]] && continue
      git branch -D $(echo "$selected_branch" | sed "s/.* //")
    elif [ "$q" = ctrl-p ]; then
      echo $(echo "$selected_branch" | sed "s/.* //")
      break
    elif [ "$q" = ctrl-n ]; then
      echo -n "Enter a new branch name: "
      read new_branch_name
      git checkout -b $new_branch_name
      break
    elif [ "$q" = enter ]; then
      git switch $(echo "$selected_branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
      break
    fi
  done
}

# git stash push
fgstp () {
  local git_repo_root selected_files files_array filtered_files_array stash_message
  git_repo_root=$(git rev-parse --show-toplevel)
  selected_files=$(git status --short|
                   fzf --multi \
                       --preview-window='right:70%:wrap' \
                       --preview="
                          if [[ {} =~ '^\?\?' ]]; then
                            bat $git_repo_root/{2};
                          else
                            git diff {2} | delta;
                          fi
                       " |
                   awk '{ print $2 }'
                  )
  if [ -z "$selected_files" ]; then
    echo "No files selected. Exiting."
    return 1
  fi

  # IFS=$'\n' read -rd '' -a files_array <<<"$selected_files"
  IFS=$'\n' files_array=(${(f)selected_files})

  filtered_files_array=()
  for file in "${files_array[@]}"; do
    if [[ $file != *"==="* ]]; then
      filtered_files_array+=("$file")
    fi
  done

  echo -n "Enter a stash message: "
  read stash_message

  git stash push -u -m "$stash_message" -- "${filtered_files_array[@]}"
}

# git stash apply/drop
fgstl() {
  # ^3 for untracked files
  local preview_cmd="echo {} | cut -d':' -f1 | xargs -I {STASH} sh -c \"git stash show -p --include-untracked '{STASH}'\" | delta"
  local out query selection key reflog_selector
  while out=$(git stash list |
            fzf --ansi --print-query --query="$query" \
              --expect=enter,ctrl-d \
              --preview=$preview_cmd \
              --preview-window='right:70%:wrap');
  do
    selection=("${(f)out}")
    query="$selection[1]"
    key="$selection[2]"
    reflog_selector=$(echo "$selection[3]" | cut -d ':' -f 1)

    case "$key" in
      enter)
        if [ "$1" = "pop" ]; then
          git stash pop "$reflog_selector"
        else
          git stash apply "$reflog_selector"
        fi
        break
        ;;
      ctrl-d)
        git stash drop "$reflog_selector"
        ;;
    esac
  done
}

fgst() {
    case $1 in
        apply|-a|list|-l)
            fgstl apply
            ;;
        pop|-p)
            fgstl pop
            ;;
        *)
            fgstp
            ;;
    esac
}

# delta
export DELTA_PAGER="less -Rf"
# git
alias g='git'
alias ga='git add'
alias gd='git diff --stat --patch'
alias gds='git diff-side-by-side --stat --patch'
alias gda='gds --staged'
alias gc='git commit -m'
alias gp='git push'
alias gpl='git pull && git fetch --prune'
alias gs='git status'
alias gst='git stash'
alias gsw='git switch'
unalias gb # temporary solution
gb () {
  case $1 in
    -n)
      echo -n "Enter a new branch name: "
      read new_branch_name
      git checkout -b $new_branch_name
      return 0
      ;;
    *)
      ;;
  esac
  git branch $@
}
alias gref='git reflog'

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
  local ignore_paths=('.git' 'node_modules')
  local depth

  while getopts "ai:d:" opt; do
    case "$opt" in
      a) show_all=true ;;
      i) ignore_paths+=("$OPTARG") ;;
      d) depth="$OPTARG" ;;
    esac
  done
  shift $((OPTIND - 1))

  if [[ -n "$1" ]]; then
    target_dir="$@"
  fi

  local cmd="ls --tree"

  for p in "${ignore_paths[@]}"; do
    cmd+=" --ignore-glob '$p'"
  done

  if [[ -n "$depth" ]]; then
    cmd+=" --depth $depth"
  elif $show_all; then
    cmd+=" -a"
  else
    cmd+=" --directory-only"
  fi

  eval "$cmd $target_dir"
}

# image viewer (in iTerm2, wezterm)
alias imgcat="wezterm imgcat"

# zellij
zl() {
  # If there are arguments, pass them directly to zellij
  if [[ $# -gt 0 ]]; then
    zellij "$@"
    return
  fi

  local selection
  local key
  local session_name
  local new_session_name
  while selection=$(
    # Get the list of zellij sessions and remove ANSI color codes
    zellij ls \
      | sed 's/\x1b\[[0-9;]*m//g' \
      | fzf --header="Select a Zellij session" \
            --expect="ctrl-n,ctrl-d,ctrl-c,enter"
  ); do
    key=$(head -1 <<< "$selection")
    session_name=`echo $(tail -1 <<< "$selection") | awk '{print $1}'`

    if [[ $? -ne 0 ]]; then
      return
    fi

    case "$key" in
      ctrl-n)
        echo -n "Enter a new session name: "
        read new_session_name
        if [[ -n "$new_session_name" ]]; then
          zellij -s "$new_session_name"
          break
        fi
        ;;
      ctrl-d)
        if [[ -n "$session_name" ]]; then
          zellij delete-session -f "$session_name"
        fi
        ;;
      ctrl-c)
        break
        ;;
      enter)
        if [[ -n "$session_name" ]]; then
          zellij attach "$session_name"
          break
        fi
        ;;
    esac
  done
}

# pyenv
eval "$(pyenv init -)"

fpyenv() {
  local selection key version display_name

  while selection=$(
    pyenv versions --bare \
      | awk '{ if ($0 ~ /envs\//) print substr($0, index($0, "envs/") + 5); else print $0 }' \
      | fzf --header="Select a Python version or virtualenv" \
            --expect="enter,ctrl-l,ctrl-d"
  ); do
    key=$(head -1 <<< "$selection")
    display_name=$(tail -1 <<< "$selection")

    if [[ -z "$display_name" ]]; then
      return
    fi

    case "$key" in
      enter)
        echo "Activate virtualenv to $version..."
        pyenv activate "$version"
        ;;
      ctrl-l)
        echo "Setting local Python version to $version..."
        pyenv local "$version"
        ;;
      ctrl-d)
        echo -n "Are you sure you want to delete virtualenv $display_name? [y/N]: "
        read confirm
        if [[ "$confirm" =~ ^[Yy]$ ]]; then
          pyenv virtualenv-delete -f "$display_name"
        fi
        ;;
    esac
  done
}


create_pyenv_settings() {
    echo '{
    "venvPath": "'$HOME'/.pyenv/versions",
    "venv": "'$PYENV_VERSION'"
}' > ./pyrightconfig.json

  echo "[mypy]
python_executable = $(which python3)
" > ./.mypy.ini
}
