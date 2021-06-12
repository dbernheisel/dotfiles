# Homebrew is bad at casks and updating. Just stop

# This should be installed manually
# https://www.google.com/chrome/
# cask 'google-chrome'  # Internet browser
# cask 'google-backup-and-sync'   # File syncing
# cask 'kitty'          # Terminal emulator

# This should be installed manually.
# https://1password.com/downloads/
# cask '1password'    # Password manager

if RUBY_PLATFORM.downcase.include? 'darwin'
  tap 'homebrew/cask-fonts'
  cask 'font-fira-code-nerd-font'
  brew 'autoconf'       # CLI Build utility
  brew 'automake'       # CLI Build utility
  brew 'cmake'          # CLI Build utility
  brew 'coreutils'      # CLI GNU utilities
  brew 'fd'             # CLI find replacement
  brew 'ffmpeg'         # CLI ffmpeg Media encoder/decoder
  brew 'fontconfig'     # CLI fontconfig Font utility for patching fonts
  brew 'freetype'       # Library Render fonts
  brew 'glib'           # Library Build utility
  brew 'gpg'            # CLI GPG security
  brew 'gradle'         # CLI build tool for java
  brew 'htop-osx'       # CLI htop process utility
  brew 'gh'             # CLI add commands to git
  brew 'libxml2'        # Library XML parsing
  brew 'libyaml'        # Library for parsing YAML
  brew 'mas'            # CLI to install from Mac App Store
  brew 'openssl'        # Library SSL library
  brew 'readline'       # Library file reading
  brew 'rsync'          # CLI rsync file copying
  brew 'p7zip'          # CLI 7a 7za compression
  brew 'reattach-to-user-namespace' # CLI to help tmux and mac
  brew 'unixodbc'       # Library for interfacing with different databases
  brew 'wxmac'          # Library for Erlang debugger to render GUI
  brew 'yarn'           # CLI JavaScript package manager
  brew 'sqlite'         # Service Database
  brew 'dnsmasq', restart_service: :changed

  # This is too big and should be installed on it's own first.
  # https://itunes.apple.com/us/app/xcode/id497799835?mt=12
  # mas 'Xcode',          id: 497799835

  mas 'The Unarchiver', id: 425424353
  mas 'Medis',          id: 1063631769
  mas 'GIPHY Capture',  id: 668208984
  mas 'Calendarique',   id: 1040634920

  # Services
  brew 'postgresql', restart_service: :changed
  brew 'redis', restart_service: :changed
  brew 'nginx', restart_service: :changed
end

brew 'bat'            # CLI utility. Colorized cat
brew 'dfu-util'       # CLI Firmware loader for keyboard
brew 'git-delta'      # CLI diff-highlight for git
brew 'fzf'            # CLI Fuzzy Finder CLI
brew 'git'            # CLI Git version control
brew 'googler'        # CLI google from command line
brew 'httpie'         # CLI http
brew 'imagemagick'    # CLI magick Image converter CLI
brew 'lame'           # Library audio encoder/decoder
tap 'neovim/neovim'
brew 'neovim'         # CLI nvim text editor
brew 'ripgrep'        # CLI rg grep current directory
brew 'shellcheck'     # CLI POSIX shell linter
brew 'tesseract'      # CLI tesseract OCR
brew 'tidy-html5'     # CLI tidy HTML linting
brew 'wget'           # CLI wget HTTP interface
brew 'wrk'            # CLI wrk HTTP benchmarking
brew 'x264'           # Library video decoder
brew 'xz'             # CLI xz compression

brew 'tmux'           # CLI tmux terminal multiplexer
brew 'tmate'          # CLI tmate tmux over SSH
