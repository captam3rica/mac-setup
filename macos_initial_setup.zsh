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
#           - Recoverit - https://recoverit.wondershare.net/buy/recoverit-data-recovery.html?gcl#################################################################
################################ VARIABLES ############################################
#######################################################################################

# Set the version of python that we want pyenv to install
PYTHON_VERSION="3.11.1"

VERSION="1.0.0"

# Define this scripts current working directory
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
    agenda
    anka-virtualization
    # atom
    autopkgr
    bettertouchtool
    blockblock
    beautysh
    checkbashisms
    chromium
    daisydisk
    do-not-disturb
    firefox
    firefox-developer-edition
    gitify
    gnupg
    grammarly
    hancock
    hermes
    hyper
    insomnia
    jq
    kextviewr
    knockknock
    lulu
    macdown
    mist
    npm
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
    rectangle
    readline
    signal
    shellcheck
    shfmt
    speedtest-cli
    sqlite3
    suspicious-package
    topnotch
    wireshark
    vim
    visual-studio-code
    xz
    zlib
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
    # Logging function
    #
    # Takes in a log level and log string and logs to /Library/Logs/$script_name if a LOG_PATH
    # constant variable is not found. Will set the log level to INFO if the first built-in $1 is
    # passed as an empty string.
    #
    # Args:
    #   $1: Log level. Examples "info", "warning", "debug", "error"
    #   $2: Log statement in string format
    #
    # Examples:
    #   logging "" "Your info log statement here ..."
    #   logging "warning" "Your warning log statement here ..."
    log_level=$(printf "$1" | /usr/bin/tr '[:lower:]' '[:upper:]')
    log_statement="$2"
    script_name="$(/usr/bin/basename $0)"
    prefix=$(/bin/date +"[%b %d, %Y %Z %T $log_level]:")

    # see if a LOG_PATH has been set
    if [[ -z "${LOG_PATH}" ]]; then
        LOG_PATH="/Library/Logs/${script_name}"
    fi

    if [[ -z $log_level ]]; then
        # If the first builtin is an empty string set it to log level INFO
        log_level="INFO"
    fi

    if [[ -z $log_statement ]]; then
        # The statement was piped to the log function from another command.
        log_statement=""
    fi

    # echo the same log statement to stdout
    /bin/echo "$prefix $log_statement"

    # send log statement to log file
    printf "%s %s\n" "$prefix" "$log_statement" >>"$LOG_PATH"

}

rosetta2_check() {
    # Check for and install Rosetta2 if needed.
    # $1: processor_brand
    # Determine the processor brand
    if [[ "$1" == *"Apple"* ]]; then
        logging "info" "Apple Processor is present..."

        # Check if the Rosetta service is running
        check_rosetta_status=$(/usr/bin/pgrep oahd)

        # Rosetta Folder location
        # Condition to check to see if the Rosetta folder exists. This check was added because
        # the Rosetta2 service is already running in macOS versions 11.5 and greater without
        # Rosseta2 actually being installed.
        rosetta_folder="/Library/Apple/usr/share/rosetta"

        if [[ -n $check_rosetta_status ]] && [[ -e $rosetta_folder ]]; then
            logging "info" "Rosetta2 is installed... no action needed"

        else
            logging "info" "Rosetta is not installed... installing now"

            # Installs Rosetta
            /usr/sbin/softwareupdate --install-rosetta --agree-to-license | /usr/bin/tee -a "${LOG_PATH}"

            # Checks the outcome of the Rosetta install
            if [[ $? -ne 0 ]]; then
                logging "error" "Rosetta2 install failed..."
                exit 1
            fi
        fi

    else
        logging "info" "Apple Processor is not present... Rosetta2 not needed"
    fi
}

xcode_cli_tools() {
    # Check for and install Xcode CLI tools
    # Run command to check for an Xcode cli tools path
    /usr/bin/xcrun --version >/dev/null 2>&1

    # check to see if there is a valide CLI tools path
    if [[ $? -eq 0 ]]; then
        /bin/echo "Valid Xcode path found. No need to install Xcode CLI tools ..."

    else
        /bin/echo "Valid Xcode CLI tools path was not found ..."

        # finded out when the OS was built
        build_year=$(/usr/bin/sw_vers -buildVersion | cut -c 1,2)

        # Trick softwareupdate into giving use everything it knows about xcode cli tools
        xclt_tmp="/tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress"

        # create the file above
        /bin/echo "Creating $xclt_tmp ..."
        /usr/bin/touch "${xclt_tmp}"

        if [[ "${build_year}" -ge 19 ]]; then
            # for Catalina or newer
            /bin/echo "Getting the latest Xcode CLI tools available ..."
            cmd_line_tools=$(/usr/sbin/softwareupdate -l | /usr/bin/awk '/\*\ Label: Command Line Tools/ { $1=$1;print }' | /usr/bin/sed 's/^[[ \t]]*//;s/[[ \t]]*$//;s/*//' | /usr/bin/cut -c 9- | /usr/bin/grep -vi beta | /usr/bin/sort -n)

        else
            # For Mojave or older
            /bin/echo "Getting the latest Xcode CLI tools available ..."
            cmd_line_tools=$(/usr/sbin/softwareupdate -l | /usr/bin/awk '/\*\ Command Line Tools/ { $1=$1;print }' | /usr/bin/grep -i "macOS" | /ussr/bin/sed 's/^[[ \t]]*//;s/[[ \t]]*$//;s/*//' | /usr/bin/cut -c 2-)

        fi

        /bin/echo "Available Xcode CLI tools found: "
        /bin/echo "$cmd_line_tools"

        if (($(/usr/bin/grep -c . <<<"${cmd_line_tools}") > 1)); then
            cmd_line_tools_output="${cmd_line_tools}"
            cmd_line_tools=$(printf "${cmd_line_tools_output}" | /usr/bin/tail -1)

            /bin/echo "Latest Xcode CLI tools found: $cmd_line_tools"
        fi

        # run softwareupdate to install xcode cli tools
        /bin/echo "Installing the latest Xcode CLI tools ..."

        # Sending this output to the local homebrew_install.log as well as stdout
        /usr/sbin/softwareupdate -i "${cmd_line_tools}" --verbose

        # cleanup the temp file
        /bin/echo "Cleaning up $xclt_tmp ..."
        /bin/rm "${xclt_tmp}"

    fi
}

install_homebrew() {
    logging "info" "use the kandji script ..."
    logging "info" "https://github.com/kandji-inc/support/blob/main/Scripts/InstallHomebrew.zsh"
    zsh ./homebrew.zsh
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

# Do main logic

logging "info" ""
logging "info" "Starting initial Mac setup script"
logging "info" ""
logging "info" "Script Version: $VERSION"
logging "info" ""

# Get the processor brand information
processor_brand="$(/usr/sbin/sysctl -n machdep.cpu.brand_string)"

# Are we on Apple Silicon
rosetta2_check "$processor_brand"

# call xcode_cli_tools
echo "Checking to see if xcode cli tools install status ..."
xcode_cli_tools

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

# for some other app installers
brew tap homebrew/cask-versions

for ((i = 1; i <= ${#HOMEBREW_APPS[@]}; i++)); do

    app="${HOMEBREW_APPS[$i]}"

    logging "info" "Installing $app from Homebrew ..."
    # Install all the home brew apps
    /opt/homebrew/bin/brew install "$app"

    if [[ $? -ne 0 ]]; then
        # Try installing with cask because app not available from brew directly
        logging "info" "Unable to install $app from brew install ..."
        logging "info" "Trying brew cask install $app ..."
        /opt/homebrew/bin/brew install --cask "$app"
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
alias gotoipsw="cd ~/Library/Group\ Containers/K36BKF7T3D.group.com.apple.configurator/Library/Caches/Firmware/"
alias gotokandjigit="cd ~/Google\ Drive/My\ Drive/kandji-git-repos"
alias gitba="git branch -lav"
alias gitb="git branch --show-currento"
alias ipswmacos="open https://ipsw.me/MacBookPro18,2"

export PATH="/usr/local/sbin:$PATH"
export PATH="/opt/homebrew/bin:$PATH"
# export PROMPT="%m%#: "
export EDITOR="/usr/bin/vim"
export HISTFILESIZE=10
export HISTSIZE=10
export HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups
export HISTIGNORE="&:clear:ls:cd:[bf]g:exit:[ t\]*"
export EMACS="*term*"

export GITGUARDIAN_API_KEY=""

bindkey -e

autoload -U compinit && compinit

# colorls settings
source $(dirname $(gem which colorls))/tab_complete.sh

# pyenv stuff
if [[ -f /usr/local/bin/pyenv ]]; then
    eval "$(/usr/local/bin/pyenv init --path)"
    # pyenv-virtualenv
    eval "$(/usr/local/bin/pyenv virtualenv-init -)"
else
    eval "$(/opt/homebrew/bin/pyenv init --path)"
    # pyenv-virtualenv
    eval "$(/opt/homebrew/bin/pyenv virtualenv-init -)"
fi
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
python -m pip install beautysh
python -m pip install pre-commit-config-shellcheck
python -m pip install shellcheck-py
python -m pip install scriv

####################################################################################
# ohmyzsh
####################################################################################

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

####################################################################################
# CLEANUP
####################################################################################

logging "info" ""
logging "info" "Initial Mac setup complete ..."
logging "info" ""

exit 0
