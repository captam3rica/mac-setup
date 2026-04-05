# global exports
export PATH="/usr/local/sbin:$PATH"

# uv
export PATH="$HOME/.local/bin:$PATH"

# homebrew
export PATH="/opt/homebrew/bin:$PATH"

# ruby path
export PATH="/opt/homebrew/opt/ruby/bin:$PATH"

if [[ -f /usr/bin/nvim ]]; then
    export EDITOR="/usr/bin/nvim"
elif [[ -f /opt/homebrew/bin/nvim ]]; then
    export EDITOR="/opt/homebrew/bin/nvim"
else
    export EDITOR="/usr/local/bin/vim"
fi

# export HISTFILESIZE=10
# export HISTSIZE=10

export HISTCONTROL=${HISTCONTROL}${HISTCONTROL+,}ignoredups
export HISTIGNORE="&:clear:ls:cd:[bf]g:exit:[ t]*"
export EMACS="*term*"
export GREP_COLOR="1;38;2;255;85;85"

# gitguardian
export GIT_GUARDIAN=""

# fzf
export FZF_DEFAULT_OPTS="--exact"

# XDG ENVs
export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_CACHE_HOME="${HOME}/.cache"
export XDG_DATA_HOME="${HOME}/.local/share"

# Node and nvm things
export NVM_DIR="$HOME/.nvm"
