# Homebrew is bad at casks and updating. Just stop

if RUBY_PLATFORM.downcase.include? 'darwin'
  tap 'homebrew/cask-fonts'
  brew 'font-fira-code-nerd-font'
  brew 'font-jetbrains-mono'
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
  brew 'htop-osx'       # CLI htop process utility
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

  # Services
  brew 'postgresql@14', restart_service: :changed
  brew 'redis', restart_service: :changed
  brew 'nginx', restart_service: :changed
end

brew 'bat'            # CLI utility. Colorized cat
brew 'exa'            # CLI utility. Prettier ls
brew 'dfu-util'       # CLI Firmware loader for keyboard
brew 'git-delta'      # CLI diff-highlight for git
brew 'fzf'            # CLI Fuzzy Finder CLI
brew 'git'            # CLI Git version control
brew 'imagemagick'    # CLI magick Image converter CLI
brew 'lame'           # Library audio encoder/decoder
tap 'neovim/neovim'
brew 'neovim'         # CLI nvim text editor
brew 'ripgrep'        # CLI rg grep current directory
brew 'shellcheck'     # CLI POSIX shell linter
brew 'tesseract'      # CLI tesseract OCR
brew 'tidy-html5'     # CLI tidy HTML linting
brew 'wget'           # CLI wget HTTP interface
brew 'x264'           # Library video decoder
brew 'xz'             # CLI xz compression
