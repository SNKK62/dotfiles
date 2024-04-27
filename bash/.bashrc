
export LANG="en_US.UTF-8"
#===git===
if [ -e $HOME/.git-completion.bash ]
then
	source $HOME/.git-completion.bash
fi

if [ -e $HOME/.git-prompt.sh ]
then
	GIT_PS1_SHOWDIRTYSTATE=true
	GIT_PS1_SHOWUNTRACKEDFILES=
	GIT_PS1_SHOWSTASHSTATE=
	GIT_PS1_SHOWUPSTREAM=

	source $HOME/.git-prompt.sh
	PS1='\[\e[31m\]($arch|bash)\[\e[00m\e[36m\]\u@MacBook-Pro\[\e[00m\]:\[\e[31m\]\w\[\e[32m\]$(__git_ps1) \[\e[00m\]\$ \[\e[00m\]'	
fi
#===git===

#====anaconda3====
export PATH=$HOME/Environments/anaconda3/bin:$PATH
export PATH=$HOME/Environments/anaconda3/bin/python:$PATH
export PATH=$HOME/Environments/anaconda3/bin/python3:$PATH
#====anaconda3====

#====java====
export JAVA_HOME=$HOME/Environments/jdk-21
export PATH=$JAVA_HOME/Contents/Home/bin:$PATH
#====java====

#===homebrew==
if [ "$(uname -m)" = "arm64" ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
  export PATH="/opt/homebrew/bin:$PATH"
else
  eval "$(/usr/local/bin/brew shellenv)"
fi
#==homebrew==

#====switch-arch====
switch-arch() {
    if  [[ "$(uname -m)" == arm64 ]]; then
	arch=x86_64
	arch -$arch /bin/bash
	#arch -$arch /usr/local/bin/bash
    elif [[ "$(uname -m)" == x86_64 ]]; then
	arch=arm64
	arch -$arch /bin/bash
    fi
}
#====switch-arch===

#====VSCode====
export PATH="/Applications/Visual Studio Code.app/Contents/Resources/app/bin:$PATH"
#====VSCode====

#====rbenv=======
export PATH=$HOME/.rbenv/bin:$PATH
#====rbenv=======

#====neovim====
alias vim=nvim
alias vi=nvim
alias viconfig='nvim ~/.config/nvim'
#====neovim====
#====tmux====
alias tmuxconfig='nvim ~/.tmux.conf'
#====tmux====
#===go===
export GOPATH="$HOME/go"
export GOROOT="/usr/local/go"
export PATH="$GOPATH/bin:$PATH"
#===go===
#===emsdk===
EMSDK="$HOME/emsdk"
#===emsdk===
export PATH="$EMSDK:$EMSDK/upstream/emscripten:$PATH"
