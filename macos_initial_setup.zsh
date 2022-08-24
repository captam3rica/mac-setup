#!/bin/zsh

#
#   https://gist.github.com/khebbie/b54eeaf851c69cb1829e
#
#   Initial config script for setting preferences
#
#       - Make sure that Xcode command line tools are installed.
#
#       - Setup the python environment
#           - pyenv
#           - pyenv-virtualenv
#
#   Todo
#
#       - Encorporate apps and tools that need to be downloaded from github (git)
#           - Dracula
#               - macOS Terminal
#               - Atom themes
#               - MacDown theme
#               - Vim
#           - Launchd Package Creator - https://github.com/ryangball/launchd-package-creator/releases
#           - Vundle (vim package manager) - git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
#
#       - Other apps that are direct download
#           - AirBuddy -
#           - Recoverit - https://recoverit.wondershare.net/buy/recoverit-data-recovery.html?gclid=EAIaIQobChMI75vtppzs7AIVt_bjBx1ndg3qEAAYASAAEgJoJPD_BwE
#           - StatusBuddy - https://statusbuddy.app

VERSION="0.7.0"

#######################################################################################
################################ VARIABLES ############################################
#######################################################################################

# Set the version of python that we want pyenv to install
PYTHON_VERSION="3.10.2"

# Define this scripts current working directory
SCRIPT_DIR=$(/usr/bin/dirname "$0")

# The present working directory
HERE="$(/usr/bin/dirname $0)"

# Script name
SCRIPT_NAME="$(/usr/bin/basename $0)"

# Logging files
LOG_FILE="$SCRIPT_NAME""_log-$(date +"%Y-%m-%d").log"
LOG_PATH="$HERE/$LOG_FILE"

# Application installation array for Homebrew

declare -a HOMEBREW_APPS
declare -a GIT_REPOS

HOMEBREW_APPS=(
    audacious
    agenda
    atom
    autopkgr
    autodmg
    bettertouchtool
    bitwarden
    bitwarden-cli
    blockblock
    beautysh
    checkbashisms
    chromium
    daisydisk
    do-not-disturb
    firefox
    gnupg
    grammarly
    hancock
    hermes
    kextviewr
    knockknock
    lulu
    macdown
    murus
    omnigraffle
    openssl
    oversight
    packages
    pdf-expert
    pocket-casts
    postman
    pppc-utility
    private-internet-access
    pyenv
    pyenv-pip-migrate
    pyenv-virtualenv
    pylint
    readline
    signal
    shellcheck
    shfmt
    speedtest-cli
    spotify
    sqlite3
    suspicious-package
    synergy
    taskexplorer
    teamviewer
    timing
    wireshark
    vfuse
    vim
    vmware-fusion
    xz
    zlib
    zoom
)

GIT_REPOS=(
    https://github.com/dracula/macdown.git      # ~/Library/Application\ Support/MacDown/Themes
    https://github.com/dracula/terminal-app.git # Dracula Terminal.app theme
    https://github.com/munki/munki-pkg.git
    https://github.com/ryangball/launchd-package-creator/releases
    https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
)

#######################################################################################
################################ FUNCTIONS ############################################
#######################################################################################

logging() {
    # Pe-pend text and print to standard output
    # Takes in a log level and log string.
    # Example: logging "INFO" "Something describing what happened."

    log_level=$(printf "$1" | /usr/bin/tr '[:lower:]' '[:upper:]')
    log_statement="$2"
    LOG_FILE="$SCRIPT_NAME""_log-$(date +"%Y-%m-%d").log"
    LOG_PATH="$HERE/$LOG_FILE"

    if [ -z "$log_level" ]; then
        # If the first builtin is an empty string set it to log level INFO
        log_level="INFO"
    fi

    if [ -z "$log_statement" ]; then
        # The statement was piped to the log function from another command.
        log_statement=""
    fi

    DATE=$(date +"[%b %d, %Y %Z %T $log_level]:")
    printf "%s %s\n" "$DATE" "$log_statement" >>"$LOG_PATH"
}

rosetta_2_check() {
    # Check for Apple Silicon Macs and install rosetta2 if necessary
    # credit: Graham Gilbert
    arch="$(/usr/bin/arch)"

    if [ "$arch" == "arm64" ]; then
        logging "info" "Installing rosetta2 for Intel compatibility on Apple Silicon ..."
        /usr/sbin/softwareupdate --install-rosetta --agree-to-license
    else
        logging "info" "This is an Intel-based Mac ..."
    fi
}

xcode_cmd_tools() {
    logging "info" "Installing xcode CLI tools ..."
    xcode-select --install

    # Get the PID for the Install Command Line Developer Tools.app process
    local pid=$(/usr/bin/pgrep "Install Command Line Developer Tools")

    while [[ "$pid" ]]; do
        logging "info" "Waiting for Install Command Line Developer Tools($pid) to complete ..."

        /bin/sleep 5

        # Grab the PID again
        pid=$(/usr/bin/pgrep "Install Command Line Developer Tools")
    done
}

install_homebrew() {
    logging "info" "Downloading and installing Homebrew ..."
    # Download and install
    # Install Homebrew | removes all interactive prompts
    /bin/bash -c "$(/usr/bin/curl -fsSL \
        https://raw.githubusercontent.com/Homebrew/install/master/install.sh |
        sed "s/abort \"Don't run this as root\!\"/\
        echo \"WARNING: Running as root...\"/" |
        sed 's/  wait_for_user/  :/')" 2>&1 | /usr/bin/tee "$LOG_PATH"
    logging "info" "Waiting 30 seconds ..."
    /bin/sleep 30
}

finder_config() {
    logging "info" "Configuring Finder settings"

    # Use list view in all Finder windows by default
    # Four-letter codes for the other view modes: `icnv`, `clmv`, `Flwv`
    /usr/bin/defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

    # Disable the warning before emptying the Trash
    /usr/bin/defaults write com.apple.finder WarnOnEmptyTrash -bool false

    # Empty Trash securely by default
    /usr/bin/defaults write com.apple.finder EmptyTrashSecurely -bool false

    # Expand the following File Info panes:
    # “General”, “Open with”, and “Sharing & Permissions”
    /usr/bin/defaults write com.apple.finder FXInfoPanesExpanded -dict \
        General -bool true \
        OpenWith -bool true \
        Privileges -bool true
}

keyboard_config() {
    logging "info" "Configuring keyboard settings"

    # Enable key repeat
    /usr/bin/defaults write -g ApplePressAndHoldEnabled -bool false

    # Set KeyRepeat to fast
    # it is possible to set lower numbers of 0 or 1.
    /usr/bin/defaults write NSGlobalDomain KeyRepeat -int 2

    # Disable Force Touch
    /usr/bin/defaults write com.apple.trackpad forceClick -bool false

    # Enable Trackpad Expose
    /usr/bin/defaults write com.apple.dock mcx-expose-disabled -bool false
}

#######################################################################################
################################ MAIN LOGIC ###########################################
#######################################################################################

main() {
    # Do main logic

    logging "info" ""
    logging "info" "Starting initial Mac setup script"
    logging "info" ""
    logging "info" "Script Version: $VERSION"
    logging "info" ""

    # Are we on Apple Silicon
    # rosetta_2_check

    # INSTALL XCODE COMMAND LINE TOOLS
    xcode_cmd_tools

    # CONFIGURE HOMEBREW - HTTPS://BREW.SH
    install_homebrew

    # Force boot verbose mode
    nvram boot-args="-v"

    # FINDER
    finder_config

    # KEYBOARD & MOUSE SETTINGS
    keyboard_config

    ####################################################################################
    # TERMINAL
    ####################################################################################

    # # Use a modified version of the Pro theme by default in Terminal.app
    # # /usr/bin/open "${HOME}/Downloads/Dracula.terminal"
    # # /bin/sleep 1 # Wait a bit to make sure the theme is loaded
    # # /usr/bin/defaults write com.apple.terminal "Default Window Settings" -string "Dracula"
    # # /usr/bin/defaults write com.apple.terminal "Startup Window Settings" -string "Dracula"
    #
    ####################################################################################
    # SCREENSHOT CONFIG
    ####################################################################################

    logging "info" "Configuring screenshot settings"

    # Remove shadow effect on screenshots
    /usr/bin/defaults write com.apple.screencapture disable-shadow -bool YES && killall SystemUIServer

    ####################################################################################
    # PRINTER CONFIG
    ####################################################################################

    logging "info" "Configuring printer settings"

    # Display advanced printer options by default
    /usr/bin/defaults write -g PMPrintingExpandedStateForPrint -bool YES

    ####################################################################################
    # APPLICATION INSTALLATION
    ####################################################################################

    logging "info" "Starting app installation from Homebrew ..."

    for ((i = 1; i <= ${#HOMEBREW_APPS[@]}; i++)); do

        local app="${HOMEBREW_APPS[$i]}"

        logging "info" "Installing $app from Homebrew ..."
        # Install all the home brew apps
        /usr/local/bin/brew install "$app"

        if [[ $? -ne 0 ]]; then
            # Try installing with cask because app not available from brew directly
            logging "info" "Unable to install $app from brew install ..."
            logging "info" "Trying brew cask install $app ..."
            /usr/local/bin/brew cask install "$app"
        fi
    done

    ####################################################################################
    # SETUP .ZSHRC
    ####################################################################################

    logging "info" "Creating .zshrc config ..."

    /bin/echo 'echo "
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

export PROMPT="%m%#: "
export EDITOR="/usr/bin/vim"
export HISTFILESIZE=10
export HISTSIZE=10
export HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups
export HISTIGNORE="&:clear:ls:cd:[bf]g:exit:[ t\]*"
export EMACS="*term*"

bindkey -e

autoload -U compinit && compinit

# pyenv stuff
eval "$(/usr/local/bin/pyenv init --path)"

# pyenv-virtualenv
eval "$(/usr/local/bin/pyenv virtualenv-init -)"
    ' >~/.zshrc

    # Reset the current Terminal session to pickup the new settings
    source ~/.zshrc

    ####################################################################################
    # SETUP PYTHON3 EVIRONMENT
    ####################################################################################

    logging "info" "Setting up the python 3 environment ..."

    logging "info" "Using pyenv to install python version $PYTHON_VERSION"
    pyenv install "$PYTHON_VERSION"

    logging "info" "Setting global python version to $PYTHON_VERSION"
    pyenv global "$PYTHON_VERSION"

    logging "info" "Resetting current Terminal session ..."
    source ~/.zshrc

    logging "info" "Upgrading pip ..."
    python -m pip install --upgrade pip

    logging "info" "Installing python dependency modules ..."

    python -m pip install black
    python -m pip install flake8
    python -m pip install ggshield
    python -m pip install isort
    python -m pip install pandas
    python -m pip install pathlib
    python -m pip install pre-commit
    python -m pip install requests
    python -m pip install toml

    ####################################################################################
    # CLEANUP
    ####################################################################################

    logging "info" ""
    logging "info" "Initial Mac setup complete ..."
    logging "info" ""
}

# Call main
main

exit 0
