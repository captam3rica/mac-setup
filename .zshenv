# global exports
export PATH="/usr/local/sbin:$PATH"

# homebrew
export PATH="/opt/homebrew/bin:$PATH"

if [[ -f /usr/bin/nvim ]]; then
        export EDITOR="/usr/bin/nvim"
elif [[ -f /opt/homebrew/bin/nvim ]]; then
        export EDITOR="/opt/homebrew/bin/nvim"
else
        export EDITOR="/usr/local/bin/vim"
fi

# export HISTFILESIZE=10
# export HISTSIZE=10
export HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups
export HISTIGNORE="&:clear:ls:cd:[bf]g:exit:[ t\]*"
export EMACS="*term*"

# uv
export PATH="$HOME/.local/bin:$PATH"

# gitguardian

