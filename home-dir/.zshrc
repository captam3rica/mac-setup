echo "
  ██████╗ █████╗ ██████╗ ████████╗ █████╗ ███╗   ███╗██████╗ ██████╗ ██╗ ██████╗ █████╗
 ██╔════╝██╔══██╗██╔══██╗╚══██╔══╝██╔══██╗████╗ ████║╚════██╗██╔══██╗██║██╔════╝██╔══██╗
 ██║     ███████║██████╔╝   ██║   ███████║██╔████╔██║ █████╔╝██████╔╝██║██║     ███████║
 ██║     ██╔══██║██╔═══╝    ██║   ██╔══██║██║╚██╔╝██║ ╚═══██╗██╔══██╗██║██║     ██╔══██║
 ╚██████╗██║  ██║██║        ██║   ██║  ██║██║ ╚═╝ ██║██████╔╝██║  ██║██║╚██████╗██║  ██║
  ╚═════╝╚═╝  ╚═╝╚═╝        ╚═╝   ╚═╝  ╚═╝╚═╝     ╚═╝╚═════╝ ╚═╝  ╚═╝╚═╝ ╚═════╝╚═╝  ╚═
"

echo ""
echo "Be strong and of great courage,
be not afraid or dismayed for the Lord
your God is wich you wherever you go.
  - Joshua 1:9"

echo ""
date
uptime
echo ""
who
echo ""

alias ls="ls -G  -F"
alias ll="ls -la"
alias grep="grep --color"
alias bitwarden="bw"
alias gotoicloud="cd /Users/captam3rica/Library/Mobile\ Documents/com~apple~CloudDocs"
alias gotoipsw="cd ~/Library/Group\ Containers/K36BKF7T3D.group.com.apple.configurator/Library/Caches/Firmware/"
alias gotokandjigit="cd ~/My\ Drive/kandji_git_repos"
alias gitba="git branch -lav"
alias gitb="git branch --show-current"

export PATH="/usr/local/sbin:$PATH"
export PROMPT="%m%#: "
export EDITOR="/usr/bin/vim"
export HISTFILESIZE=10
export HISTSIZE=10
export HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups
export HISTIGNORE="&:clear:ls:cd:[bf]g:exit:[ t\]*"
export EMACS="*term*"

export GITGUARDIAN_API_KEY="4C0562D4b8eAcC0CcBaB9DD0AE385053d1a13Cb67cfd847137DAbEF60b9B28Df6cDFb72"

bindkey -e

autoload -U compinit && compinit

# colorls settings
source $(dirname $(gem which colorls))/tab_complete.sh

# pyenv stuff
# if command -v pyenv 1>/dev/null 2>&1; then
#    eval "$(pyenv init -)"
# fi
eval "$(pyenv init --path)"


# pyenv-virtualenv
eval "$(pyenv virtualenv-init -)"
