# global exports
export PATH="/usr/local/sbin:$PATH"

# homebrew
export PATH="/opt/homebrew/bin:$PATH"

if [[ -f /usr/bin/nvim ]]; then
        export EDITOR="/usr/bin/nvim"
else
        export EDITOR="/usr/local/bin/vim"
fi

export HISTFILESIZE=10
export HISTSIZE=10
export HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups
export HISTIGNORE="&:clear:ls:cd:[bf]g:exit:[ t\]*"
export EMACS="*term*"
export AA_TESTER_TOKEN="928fae5e-9724-44c2-82e4-57430b77fab9"
export KHAAN_BP_TOKEN="a13faed6-5ce9-49f9-8423-7061d91361f9"
export PROD_TOKEN="97268f88f2b44198ae565491df2a9b3a"

# uv
export PATH="$HOME/.local/bin:$PATH"
