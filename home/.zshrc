# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# zsh theme
ZSH_THEME="dracula-pro"

# zsh auto-update behavior
zstyle ':omz:update' mode auto # update automatically without asking

# Uncomment the following line to change how often to auto-update (in days).
zstyle ':omz:update' frequency 10

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(colored-man-pages git zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh

# User configuration

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    # shellcheck source=/dev/null
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

alias ohmyzsh="mate ~/.oh-my-zsh"

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

fpath+=~/.config/zsh/functions/; autoload -Uz compinit; compinit

####################################################################################
# Dracula Theme (for zsh-syntax-highlighting)
#
# https://github.com/zenorocha/dracula-theme
#
# Copyright 2021, All rights reserved
#
# Code licensed under the MIT license
# http://zenorocha.mit-license.org
#
# @author George Pickering <@bigpick>
# @author Zeno Rocha <hi@zenorocha.com>
# Paste this files contents inside your ~/.zshrc before you activate zsh-syntax-highlighting
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main cursor)
typeset -gA ZSH_HIGHLIGHT_STYLES
# Default groupings per, https://spec.draculatheme.com, try to logically separate
# possible ZSH_HIGHLIGHT_STYLES settings accordingly...?
#
# Italics not yet supported by zsh; potentially soon:
#    https://github.com/zsh-users/zsh-syntax-highlighting/issues/432
#    https://www.zsh.org/mla/workers/2021/msg00678.html
# ... in hopes that they will, labelling accordingly with ,italic where appropriate
#
# Main highlighter styling: https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters/main.md
#
## General
### Diffs
### Markup
## Classes
## Comments
ZSH_HIGHLIGHT_STYLES[comment]='fg=#6272A4'
## Constants
## Entitites
## Functions/methods
ZSH_HIGHLIGHT_STYLES[alias]='fg=#50FA7B'
ZSH_HIGHLIGHT_STYLES[suffix-alias]='fg=#50FA7B'
ZSH_HIGHLIGHT_STYLES[global-alias]='fg=#50FA7B'
ZSH_HIGHLIGHT_STYLES[function]='fg=#50FA7B'
ZSH_HIGHLIGHT_STYLES[command]='fg=#50FA7B'
ZSH_HIGHLIGHT_STYLES[precommand]='fg=#50FA7B,italic'
ZSH_HIGHLIGHT_STYLES[autodirectory]='fg=#FFB86C,italic'
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=#FFB86C'
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=#FFB86C'
ZSH_HIGHLIGHT_STYLES[back-quoted-argument]='fg=#BD93F9'
## Keywords
## Built ins
ZSH_HIGHLIGHT_STYLES[builtin]='fg=#8BE9FD'
ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=#8BE9FD'
ZSH_HIGHLIGHT_STYLES[hashed-command]='fg=#8BE9FD'
## Punctuation
ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=#FF79C6'
ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter]='fg=#F8F8F2'
ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter-unquoted]='fg=#F8F8F2'
ZSH_HIGHLIGHT_STYLES[process-substitution-delimiter]='fg=#F8F8F2'
ZSH_HIGHLIGHT_STYLES[back-quoted-argument-delimiter]='fg=#FF79C6'
ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]='fg=#FF79C6'
ZSH_HIGHLIGHT_STYLES[back-dollar-quoted-argument]='fg=#FF79C6'
## Serializable / Configuration Languages
## Storage
## Strings
ZSH_HIGHLIGHT_STYLES[command-substitution-quoted]='fg=#F1FA8C'
ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter-quoted]='fg=#F1FA8C'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#F1FA8C'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument-unclosed]='fg=#FF5555'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#F1FA8C'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument-unclosed]='fg=#FF5555'
ZSH_HIGHLIGHT_STYLES[rc-quote]='fg=#F1FA8C'
## Variables
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=#F8F8F2'
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument-unclosed]='fg=#FF5555'
ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]='fg=#F8F8F2'
ZSH_HIGHLIGHT_STYLES[assign]='fg=#F8F8F2'
ZSH_HIGHLIGHT_STYLES[named-fd]='fg=#F8F8F2'
ZSH_HIGHLIGHT_STYLES[numeric-fd]='fg=#F8F8F2'
## No category relevant in spec
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#FF5555'
ZSH_HIGHLIGHT_STYLES[path]='fg=#F8F8F2'
ZSH_HIGHLIGHT_STYLES[path_pathseparator]='fg=#FF79C6'
ZSH_HIGHLIGHT_STYLES[path_prefix]='fg=#F8F8F2'
ZSH_HIGHLIGHT_STYLES[path_prefix_pathseparator]='fg=#FF79C6'
ZSH_HIGHLIGHT_STYLES[globbing]='fg=#F8F8F2'
ZSH_HIGHLIGHT_STYLES[history-expansion]='fg=#BD93F9'
#ZSH_HIGHLIGHT_STYLES[command-substitution]='fg=?'
#ZSH_HIGHLIGHT_STYLES[command-substitution-unquoted]='fg=?'
#ZSH_HIGHLIGHT_STYLES[process-substitution]='fg=?'
#ZSH_HIGHLIGHT_STYLES[arithmetic-expansion]='fg=?'
ZSH_HIGHLIGHT_STYLES[back-quoted-argument-unclosed]='fg=#FF5555'
ZSH_HIGHLIGHT_STYLES[redirection]='fg=#F8F8F2'
ZSH_HIGHLIGHT_STYLES[arg0]='fg=#F8F8F2'
ZSH_HIGHLIGHT_STYLES[default]='fg=#F8F8F2'
ZSH_HIGHLIGHT_STYLES[cursor]='standout'

##############################################################################

if [[ -d /opt/homebrew ]]; then 
    # shellcheck source=/dev/null
    source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    # shellcheck source=/dev/null
    source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme
else
    # shellcheck source=/dev/null
    source /usr/local/share/powerlevel10k/powerlevel10k.zsh-theme
    # shellcheck source=/dev/null
    source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# colorls settings
# /opt/homebrew/opt/ruby/bin/ruby
colorls_gem=$(/opt/homebrew/opt/ruby/bin/gem which colorls)
# shellcheck source=/dev/null
source "${colorls_gem:h}/tab_complete.sh"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
# shellcheck source=${HOME}/.p10k.zs
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Update tab title with git branch/worktree info
function set_ghostty_tab_title() {
    local branch
    branch=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)

    if [[ -n "$branch" ]]; then
        printf "\e]2;%s  %s\a" "${PWD/#$HOME/~}" "$branch"
    else
        printf "\e]2;%s\a" "${PWD/#$HOME/~}"
    fi
}

# Run before each prompt
precmd_functions+=(set_ghostty_tab_title)

# zshes
alias myzshrc="nvim ~/.zshrc"
alias myzshenv="nvim ~/.zshenv"
alias myzprofile="nvim ~/.zprofile"

# ls and colorls
# alias ls="ls -G  -F"
# alias ll="ls -la"
alias ls="colorls --dark --git-status" 
alias ll="colorls --dark -p -la --git-status --group-directories-first" # long list
alias lst="colorls --dark -p --tree --git-status --group-directories-first" # tree view
alias lsm="colorls --dark -plat --git-status --group-directories-first" # sort by modtime

# misc
alias emptytrash="osascript -e 'tell application \"Finder\" to empty the trash'"
alias grep="grep --color"
alias gotoicloud="cd \${HOME}/Library/Mobile Documents/com~apple~CloudDocs"
alias gotoipsw="cd ~/Library/Group\ Containers/K36BKF7T3D.group.com.apple.configurator/Library/Caches/Firmware/"
alias gotogitrepos="cd ~/Google\ Drive/My Drive/dev"
alias gotoautopkgcache="cd \${HOME}/Library/AutoPkg/Cache"
alias openautopkgcache="open \${HOME}/Library/AutoPkg/Cache"
alias openipswmacos="open https://ipsw.me/\${HOME}"
alias openmsaaderrors="open https://login.microsoftonline.com/error"
alias openappleicons="open /System/Library/Components/CoreAudio.component/Contents/Resources"
alias opencoreicons="open /System/Library/CoreServices/CoreTypes.bundle/Contents/Resources"

# github
alias github="open https://github.com/"
# clears away anything not in version control and resets your branch modifications. 
alias gitfresh='git reset --hard HEAD && git clean -dffx -e ".venv" -e ".vscode" -e ".env" -e "node_modules"'
alias gsc='git switch --create'


# uv
alias uvp="uv run --with poethepoet poe"
bindkey -e

# tmux
alias start-dev="\${HOME}/.config/zsh/functions/start-dev"

# worktrunk
if command -v wt >/dev/null 2>&1; then eval "$(command wt config shell init zsh)"; fi
alias wts="wt switch"

# nvm
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

# auto activate venv
# https://gist.github.com/mikeckennedy/010a96dc6a406242d5b49d12e5d51c22
source "${HOME}/.config/zsh/functions/venv-auto-activate"
# Venv security whitelist/blocklist
alias venv-security='uv run -q --no-project ${HOME}/.config/zsh/functions/venv-security'
