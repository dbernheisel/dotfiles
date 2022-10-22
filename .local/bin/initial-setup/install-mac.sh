# sourced from install.sh
column
fancy_echo "Installing xcode command line tools" "$yellow"
xcode-select --install

if ! command -v brew >/dev/null; then
  column
  fancy_echo "Installing Homebrew ..." "$yellow"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

column
fancy_echo "Updating Apple macOS defaults" "$yellow"
fancy_echo "Enabling full keyboard access for all controls. e.g. enable Tab in modal dialogs" "$yellow"
defaults write -globalDomain AppleKeyboardUIMode 3

fancy_echo "Setting a blazingly fast keyboard repeat rate" "$yellow"
defaults write -globalDomain InitialKeyRepeat 15
defaults write -globalDomin KeyRepeat 2

fancy_echo "Disable smart quotes and smart dashes as they're annoying when typing code" "$yellow"
defaults write -globalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write -globalDomain NSAutomaticDashSubstitutionEnabled -bool false

fancy_echo "Adding a context menu item for showing the Web Inspector in web views" "$yellow"
defaults write -globalDomain WebKitDeveloperExtras -bool true

fancy_echo "Automatically quit printer app once the print jobs complete" "$yellow"
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

fancy_echo "Enabling Safari debug menu" "$yellow"
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true

fancy_echo "Enabling the Develop menu and the Web Inspector in Safari" "$yellow"
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari "com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled" -bool true

column
fancy_echo "Installing programs" "$yellow"
brew update
brew bundle check || brew bundle
brew cleanup
