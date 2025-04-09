# global exports
export PATH="/usr/local/sbin:$PATH"
export PATH="/opt/homebrew/bin:$PATH"

if [[ -f /opt/homebrew/bin/nvim ]]; then
        export EDITOR="/opt/homebrew/bin/nvimm"
elif [[ -f /usr/bin/nvim ]]; then
        export EDITOR="/usr/bin/nvim"
else
        export EDITOR="/usr/local/bin/vim"
fi

export HISTFILESIZE=10
export HISTSIZE=10
export HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups
export HISTIGNORE="&:clear:ls:cd:[bf]g:exit:[ t\]*"
export EMACS="*term*"
export GITGUARDIAN_API_KEY="<key>"
