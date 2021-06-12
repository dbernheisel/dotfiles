# sourced from install.sh
column
fancy_echo "Installing xcode command line tools" "$yellow"
xcode-select --install

if ! command -v brew >/dev/null; then
  column
  fancy_echo "Installing Homebrew ..." "$yellow"
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

  export PATH="/usr/local/bin:$PATH"
fi

if ! command -v mas > /dev/null; then
  column
  fancy_echo "Installing MAS to manage Mac Apple Store installs" "$yellow"
  brew install mas
fi

column
fancy_echo "Updating Apple macOS defaults" "$yellow"

fancy_echo "Enabling full keyboard access for all controls. e.g. enable Tab in modal dialogs" "$yellow"
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

fancy_echo "Setting a blazingly fast keyboard repeat rate" "$yellow"
defaults write NSGlobalDomain KeyRepeat -int 1

fancy_echo "Disable smart quotes and smart dashes as they're annoying when typing code" "$yellow"
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

fancy_echo "Automatically quit printer app once the print jobs complete" "$yellow"
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

fancy_echo "Enabling Safari debug menu" "$yellow"
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true

fancy_echo "Enabling the Develop menu and the Web Inspector in Safari" "$yellow"
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari "com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled" -bool true

fancy_echo "Adding a context menu item for showing the Web Inspector in web views" "$yellow"
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

fancy_echo "Turning on AptX and AAC codecs over Bluetooth for non-Apple devices" "$yellow"
defaults write bluetoothaudiohd "Enable AptX codec" -bool true
defaults write bluetoothaudiohd "Enable AAC codec" -bool true

column
fancy_echo "Installing programs" "$yellow"
brew update
brew bundle check || brew bundle
brew cleanup
