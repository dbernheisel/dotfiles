#!/bin/zsh

alias history='history -f'
source "$HOME/.local/bin/wvim.zsh"

function deploy_staging() {
  YELLOW="\033[1;33m"
  RED="\033[1;31m"
  GREEN="\033[0;32m"
  RESET="\033[0m"

  local BRANCH=$(git symbolic-ref HEAD --short)
  local TARGET="staging"

  if [ $(git status -s -b | wc -l) -eq 1 ]; then
    echo -e "Do you want to deploy ${YELLOW}${BRANCH}${RESET} to ${YELLOW}${TARGET}${RESET}? "
    read yn
    case "$yn" in
      [Yy])
        git push --force origin "${BRANCH}:${TARGET}"
        echo -e "${GREEN}Triggered deployment${RESET}"
        ;;
      *)
        echo -e "${RED}Cancelling...${RESET}"
        ;;
    esac
  else
    echo "You have uncommitted changes. Please resolve you changes first"
    echo -e "${RED}Cancelling...${RESET}"
    return 1
  fi
}
