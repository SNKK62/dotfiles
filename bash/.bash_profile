source ~/.bashrc

export arch=$(uname -m)

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/kokiseno/Environments/anaconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/kokiseno/Environments/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/kokiseno/Environments/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/kokiseno/Environments/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

eval "$(rbenv init - bash)"
source "/Users/kokiseno/emsdk/emsdk_env.sh"

export WASMTIME_HOME="$HOME/.wasmtime"

export PATH="$WASMTIME_HOME/bin:$PATH"
. "$HOME/.cargo/env"
