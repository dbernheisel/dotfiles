# Homebrew is bad at casks and updating. Just stop

brew 'asdf'           # CLI tool version manager
brew 'bat'            # CLI utility. Colorized cat
brew 'eza'            # CLI utility. Prettier ls
brew 'dfu-util'       # CLI Firmware loader for keyboard
brew 'git-delta'      # CLI diff-highlight for git
brew 'fzf'            # CLI Fuzzy Finder CLI
brew 'git'            # CLI Git version control
brew 'imagemagick'    # CLI magick Image converter CLI
brew 'lame'           # Library audio encoder/decoder
brew 'lazygit'        # CLI Git TUI
tap 'neovim/neovim'
brew 'neovim'         # CLI nvim text editor
brew 'ripgrep'        # CLI rg grep current directory
brew 'shellcheck'     # CLI POSIX shell linter
brew 'tesseract'      # CLI tesseract OCR
brew 'tidy-html5'     # CLI tidy HTML linting
brew 'tldr'           # CLI tldr shorter man pages
brew 'wget'           # CLI wget HTTP interface
brew 'x264'           # Library video decoder
brew 'xz'             # CLI xz compression

if OS.mac?
  cask 'font-fira-code-nerd-font'
  cask 'font-jetbrains-mono-nerd-font'
  cask '1password-cli'  # CLI Passwords
  cask 'rectangle'      # Better tiling

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
  brew 'gnu-sed'        # CLI sed, but GNU-y
  brew 'htop'           # CLI htop process utility
  brew 'gh'             # CLI add commands to git
  brew 'libxml2'        # Library XML parsing
  brew 'libyaml'        # Library for parsing YAML
  brew 'openssl'        # Library SSL library
  brew 'readline'       # Library file reading
  brew 'rsync'          # CLI rsync file copying
  brew 'p7zip'          # CLI 7a 7za compression
  brew 'unixodbc'       # Library for interfacing with different databases
  brew 'wxwidgets'      # Library for Erlang debugger to render GUI
  brew 'yarn'           # CLI JavaScript package manager
  brew 'sqlite'         # Service Database

  brew 'mas'            # CLI to install from Mac App Store

  printf 'Install Safari Extensions? (y/N) '
  if gets.chomp == 'y' then
    # Safari Extensions
    mas 'Wipr 2', id: 1662217862
    mas 'Noir', id: 1592917505
    mas '1Password for Safari', id: 1569813296
  end

  # Apps
  printf 'Install App Store apps? (y/N) '
  if gets.chomp == 'y' then
    mas 'Parcel', id: 639968404
    mas 'Wireguard', id: 1451685025
    mas 'Medis', id: 1063631769
    mas 'Slack', id: 803453959
  end

  # Services
  printf 'Install Services? (y/N) '
  if gets.chomp == 'y' then
    brew 'postgresql@15', restart_service: :changed
    brew 'redis', restart_service: :changed
  end
end
