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
#           - Recoverit - https://recoverit.wondershare.net/buy/recoverit-data-recovery.html?gcl

########################################################################################
################################ VARIABLES #############################################
########################################################################################

# Set the version of python that we want pyenv to install
PYTHON_VERSION="3.13.1"

VERSION="1.1.0"

# Define this scripts current working directory
HERE="$(/usr/bin/dirname "$0")"

# Script name
SCRIPT_NAME="$(/usr/bin/basename "$0")"

# brew bundle file path
BREWBUNDLE="${HERE}/brewfile"

# Logging files
LOG_FILE="$SCRIPT_NAME""_log-$(date +"%Y-%m-%d").log"
LOG_PATH="/Users/$(/usr/sbin/scutil <<<"show State:/Users/ConsoleUser" |
    /usr/bin/awk '/Name :/ && ! /loginwindow/ && ! /root/ && ! /_mbsetupuser/ { print $3 }' |
    /usr/bin/awk -F '@' '{print $1}')/Desktop/$LOG_FILE"

#######################################################################################
################################ FUNCTIONS ############################################
#######################################################################################

function logging() {
    # Logging function
    #
    # Takes in a log level and log string and logs to /Library/Logs/$script_name if a
    # LOG_PATH constant variable is not found. Will set the log level to INFO if the
    # first built-in $1 is passed as an empty string.
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

function rosetta2_check() {
    # Check for and install Rosetta2 if needed.
    # $1: processor_brand
    # Determine the processor brand
    if [[ "$1" == *"Apple"* ]]; then
        logging "info" "Apple Processor is present..."

        # Check if the Rosetta service is running
        check_rosetta_status=$(/usr/bin/pgrep oahd)

        # Rosetta Folder location
        # Condition to check to see if the Rosetta folder exists. This check was added
        # because the Rosetta2 service is already running in macOS versions 11.5 and
        # greater without Rosseta2 actually being installed.
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

function xcode_cli_tools() {
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

function install_homebrew() {
    logging "info" "use the kandji script ..."
    logging "info" "https://github.com/kandji-inc/support/blob/main/Scripts/InstallHomebrew.zsh"
    zsh "$HERE/homebrew.zsh"
}

#######################################################################################
################################ MAIN LOGIC ###########################################
#######################################################################################

# Do main logic

# Get the current logged in user excluding loginwindow, _mbsetupuser, and root
current_user=$(/usr/sbin/scutil <<<"show State:/Users/ConsoleUser" |
    /usr/bin/awk '/Name :/ && ! /loginwindow/ && ! /root/ && ! /_mbsetupuser/ { print $3 }' |
    /usr/bin/awk -F '@' '{print $1}')

# Get the processor brand information
processor_brand="$(/usr/sbin/sysctl -n machdep.cpu.brand_string)"

logging "info" ""
logging "info" "Starting initial Mac setup script"
logging "info" ""
logging "info" "Script Version: $VERSION"
logging "info" ""
logging "info" "Current user: $current_user"
logging "info" "Processor brand: $processor_brand"

# Are we on Apple Silicon
rosetta2_check "$processor_brand"

# call xcode_cli_tools
echo "Checking to see if xcode cli tools install status ..."
xcode_cli_tools

# CONFIGURE HOMEBREW - HTTPS://BREW.SH
install_homebrew

# Force boot verbose mode
nvram boot-args="-v"

####################################################################################
# GENERAL
####################################################################################

logging "info" "Configuring general settings"

# Disable press-and-hold for keys in favor of key repeat
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Set a blazingly fast keyboard repeat rate
defaults write NSGlobalDomain KeyRepeat -int 3
defaults write NSGlobalDomain InitialKeyRepeat -int 20

# Avoid creating .DS_Store files on network volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

####################################################################################
# KEYBOARD AND MOUSE
####################################################################################

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

####################################################################################
# TEXTEDIT
####################################################################################

logging "info" "Configuring textedit settings"

# Use plain text mode for new TextEdit documents
defaults write com.apple.TextEdit RichText -int 0

# Open and save files as UTF-8 in TextEdit
defaults write com.apple.TextEdit PlainTextEncoding -int 4
defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4

# Set tab width to 4 instead of the default 8
defaults write com.apple.TextEdit "TabWidth" '4'

# Enable the debug menu in Disk Utility
defaults write com.apple.DiskUtility DUDebugMenuEnabled -bool true
defaults write com.apple.DiskUtility advanced-image-options -bool true

####################################################################################
# IMESSAGE
####################################################################################

logging "info" "Configuring iMessage settings"

# Disable automatic emoji substitution (i.e. use plain text smileys)
defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "automaticEmojiSubstitutionEnablediMessage" -bool false

# Disable smart quotes as it’s annoying for messages that contain code
defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "automaticQuoteSubstitutionEnabled" -bool false

####################################################################################
# FINDER
####################################################################################

logging "info" "Configuring Finder settings"

# Finder: allow quitting via ⌘ + Q; doing so will also hide desktop icons
defaults write com.apple.finder QuitMenuItem -bool true

# Finder: disable window animations and Get Info animations
defaults write com.apple.finder DisableAllAnimations -bool true

# Set Desktop as the default location for new Finder windows
# For other paths, use `PfLo` and `file:///full/path/here/`
defaults write com.apple.finder NewWindowTarget -string "PfDe"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/Desktop/"

# Finder: show hidden files by default
defaults write com.apple.finder AppleShowAllFiles -bool true

# Finder: show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Finder: show path bar
defaults write com.apple.finder ShowPathbar -bool true

# Display full POSIX path as Finder window title
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Enable spring loading for directories
defaults write NSGlobalDomain com.apple.springing.enabled -bool true

# Tweak the spring loading delay for directories
defaults write NSGlobalDomain com.apple.springing.delay -float .5

# Use list view in all Finder windows by default
# Four-letter codes for the other view modes: `icnv`, `clmv`, `Flwv`
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Disable the warning before emptying the Trash
defaults write com.apple.finder WarnOnEmptyTrash -bool false

# Empty Trash securely by default
defaults write com.apple.finder EmptyTrashSecurely -bool true

####################################################################################
# DOCK
####################################################################################

logging "info" "Configuring Dock settings"

# Set the icon size of Dock items to 36 pixels
defaults write com.apple.dock tilesize -int 36

# Change minimize/maximize window effect
defaults write com.apple.dock mineffect -string "scale"

# Minimize windows into their application’s icon
defaults write com.apple.dock minimize-to-application -bool true

# Show indicator lights for open applications in the Dock
defaults write com.apple.dock show-process-indicators -bool true

# Don’t animate opening applications from the Dock
defaults write com.apple.dock launchanim -bool false

# Don’t show Dashboard as a Space
defaults write com.apple.dock dashboard-in-overlay -bool true

####################################################################################
# SAFARI
####################################################################################

logging "info" "Configuring Safari settings"

# Privacy: don’t send search queries to Apple
defaults write com.apple.Safari UniversalSearchEnabled -bool false
defaults write com.apple.Safari SuppressSearchSuggestions -bool true

# Show the full URL in the address bar (note: this still hides the scheme)
defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true

# Set Safari’s home page to `about:blank` for faster loading
defaults write com.apple.Safari HomePage -string "about:blank"

# Prevent Safari from opening ‘safe’ files automatically after downloading
defaults write com.apple.Safari AutoOpenSafeDownloads -bool false

# Hide Safari’s bookmarks bar by default
defaults write com.apple.Safari ShowFavoritesBar -bool false

# Enable Safari’s debug menu
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true

# Make Safari’s search banners default to Contains instead of Starts With
defaults write com.apple.Safari FindOnPageMatchesWordStartsOnly -bool false

# Remove useless icons from Safari’s bookmarks bar
defaults write com.apple.Safari ProxiesInBookmarksBar "()"

# Enable the Develop menu and the Web Inspector in Safari
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true

# Add a context menu item for showing the Web Inspector in web views
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

####################################################################################
# MAIL
####################################################################################

logging "info" "Configuring Apple Mail.app settings"

# Copy email addresses as `foo@example.com` instead of `Foo Bar <foo@example.com>` in Mail.app
defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool false

####################################################################################
# ACTIVITY MONITOR
####################################################################################

logging "info" "Configuring Activity Monitor settings"

# Show the main window when launching Activity Monitor
defaults write com.apple.ActivityMonitor OpenMainWindow -bool true

# Show all processes in Activity Monitor
defaults write com.apple.ActivityMonitor ShowCategory -int 0

# Sort Activity Monitor results by CPU usage
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
defaults write com.apple.ActivityMonitor SortDirection -int 0

####################################################################################
# SECURITY
####################################################################################

logging "info" "Configuring Security settings"

# Require password immediately after sleep or screen saver begins
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

####################################################################################
# TERMINAL
####################################################################################

# Use a modified version of the Pro theme by default in Terminal.app
# /usr/bin/open "${HOME}/Downloads/Dracula.terminal"
# /bin/sleep 1 # Wait a bit to make sure the theme is loaded
# /usr/bin/defaults write com.apple.terminal "Default Window Settings" -string "Dracula"
# /usr/bin/defaults write com.apple.terminal "Startup Window Settings" -string "Dracula"
#
####################################################################################
# SCREENSHOT CONFIG
####################################################################################

logging "info" "Configuring screenshot behavior settings"

logging "info" "Configuring screenshot settings"

# Remove shadow effect on screenshots
/usr/bin/defaults write com.apple.screencapture disable-shadow -bool YES && killall SystemUIServer

# Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)
defaults write com.apple.screencapture type -string "png"

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

if [[ "$processor_brand" == *"Apple"* ]]; then
    brew_bin="/opt/homebrew/bin/brew"
else
    brew_bin="/usr/local/bin/brew"
fi

# Install all the home brew apps
logging "info" "Installing app from bundle file: ${BREWBUNDLE}"
 /usr/bin/su - "$current_user" -c "$brew_bin bundle --file /Users/$current_user/git-repos/mac-setup/brewfile" |
            /usr/bin/tee -a "${LOG_PATH}"

####################################################################################
# colorls
####################################################################################

sudo /usr/bin/gem install colorls
/bin/mkdir -p "/Users/${current_user}/.config/colorls"
/bin/cp "$HERE/dark_colors.yaml" "/Users/${current_user}/.config/colorls"

####################################################################################
# ohmyzsh
####################################################################################

logging "info" "Installing ohmyzsh"

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

####################################################################################
# SETUP PYTHON3 ENVIRONMENT
####################################################################################

logging "info" "Setting up the python 3 environment ..."

logging "info" "Using pyenv to install python version $PYTHON_VERSION"
# pyenv install "$PYTHON_VERSION"

logging "info" "Setting global python version to $PYTHON_VERSION"
# pyenv global "$PYTHON_VERSION"

logging "info" "Upgrading pip ..."
# python3 -m pip install --upgrade pip

logging "info" "Installing python dependency modules ..."

uv tool install pre-commit
uv tool install ruff
uv tool install scriv
# python3 -m pip install black
# python3 -m pip install flake8
# python3 -m pip install isort
# python3 -m pip install numpy
# python3 -m pip install numpy_financial
# python3 -m pip install pandas
# python3 -m pip install pathlib
# python3 -m pip install requests
# python3 -m pip install toml
# python3 -m pip install beautysh
# python3 -m pip install shellcheck-py

####################################################################################
# SETUP ZSHELL
####################################################################################

logging "info" "Creating .zshrc config ..."
/bin/cp .zshrc "/Users/$current_user/.zshrc"

logging "info" "Creating .zshenv config ..."
/bin/cp .zshenv "/Users/$current_user/.zshenv"

logging "info" "Resetting current Terminal session ..."
/bin/zsh -l

# Kill affected applications
for app in "Activity Monitor" "Address Book" "Calendar" "Contacts" "cfprefsd" \
    "Dock" "Finder" "Google Chrome" "Google Chrome Canary" "Mail" "Messages" \
    "Opera" "Safari" "SizeUp" "Spectacle" "SystemUIServer" \
    "Transmission" "Twitter" "iCal"; do
    killall "${app}" >/dev/null 2>&1
done

logging "info" ""
logging "info" "Initial Mac setup complete ..."
logging "info" ""

logging "info" "Done. Note that some of these changes require a logout/restart of your OS to take effect.  At a minimum, be sure to restart your Terminal."

/bin/echo "Done. Note that some of these changes require a logout/restart of your OS to take effect.  At a minimum, be sure to restart your Terminal."

exit 0
