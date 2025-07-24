# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="dracula-pro"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
zstyle ':omz:update' mode auto # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(aws colored-man-pages git zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

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

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

if [[ -d /opt/homebrew ]]; then 
        source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
        source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme
else
        source /usr/local/share/powerlevel10k/powerlevel10k.zsh-theme
        source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# zshes
alias myzshrc="neo ~/.zshrc"
alias myzshenv="neo ~/.zshenv"
alias myzprofile="neo ~/.zprofile"

# ls and colorls
# alias ls="ls -G  -F"
# alias ll="ls -la"
alias ls="colorls --dark" 
alias ll="colorls --dark -p -la --git-status --group-directories-first" # long list
alias lst="colorls --dark -p --tree --git-status --group-directories-first" # tree view
alias lsm="colorls --dark -plat --git-status --group-directories-first" # sort by modtime

# misc
alias emptytrash="osascript -e 'tell application \"Finder\" to empty the trash'"
alias neo="nvim"
alias grep="grep --color"
alias gotoicloud="cd /Users/$(/usr/sbin/scutil <<<"show State:/Users/ConsoleUser" |  /usr/bin/awk '/Name :/ && ! /loginwindow/ && ! /root/ && ! /_mbsetupuser/ { print $3 }' | /usr/bin/awk -F '@' '{print $1}')/Library/Mobile\ Documents/com~apple~CloudDocs"
alias gotoipsw="cd ~/Library/Group\ Containers/K36BKF7T3D.group.com.apple.configurator/Library/Caches/Firmware/"
alias gotokandjigit="cd ~/Google\ Drive/My\ Drive/kandji-git-repos"
alias autopkgcache="open /Users/$(/usr/sbin/scutil <<<"show State:/Users/ConsoleUser" |  /usr/bin/awk '/Name :/ && ! /loginwindow/ && ! /root/ && ! /_mbsetupuser/ { print $3 }' | /usr/bin/awk -F '@' '{print $1}')/Library/AutoPkg/Cache"
alias cdautopkgcache="cd /Users/$(/usr/sbin/scutil <<<"show State:/Users/ConsoleUser" |  /usr/bin/awk '/Name :/ && ! /loginwindow/ && ! /root/ && ! /_mbsetupuser/ { print $3 }' | /usr/bin/awk -F '@' '{print $1}')/Library/AutoPkg/Cache"
alias ipswmacos="open https://ipsw.me/$(/usr/sbin/system_profiler SPHardwareDataType | grep "Model Identifier" | awk '{print $3}')"
alias msaaderrors="open https://login.microsoftonline.com/error"
alias appleicons="open /System/Library/Components/CoreAudio.component/Contents/Resources"
alias coreicons="open /System/Library/CoreServices/CoreTypes.bundle/Contents/Resources"
alias acd="/opt/cisco/anyconnect/bin/vpn disconnect"
alias acs="/opt/cisco/anyconnect/bin/vpn state"

# github
alias github="open https://github.com/"
alias gitba="git branch -lav"
alias gitb="git branch --show-current"
alias gitsm="git switch main"
alias gits="git status --untracked-files"
# clears away anything not in version control and resets your branch modifications. 
alias gitfresh='git reset --hard HEAD && git clean -dffx -e ".venv" -e ".vscode" -e ".env" -e "node_modules"'

# uv
alias uvp="uv run --with poethepoet poe"

bindkey -e

autoload -U compinit && compinit

# colorls settings
source $(dirname $(gem which colorls))/tab_complete.sh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export PATH="/opt/homebrew/opt/ruby/bin:$PATH"

fpath+=~/.zfunc; autoload -Uz compinit; compinit
