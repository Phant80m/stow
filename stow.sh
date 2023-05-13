#!/bin/bash

# Regular colors
BLACK='\033[0;30m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[0;37m'

# Bold colors
BOLD_BLACK='\033[1;30m'
BOLD_RED='\033[1;31m'
BOLD_GREEN='\033[1;32m'
BOLD_YELLOW='\033[1;33m'
BOLD_BLUE='\033[1;34m'
BOLD_PURPLE='\033[1;35m'
BOLD_CYAN='\033[1;36m'
BOLD_WHITE='\033[1;37m'

# Background colors
BACKGROUND_BLACK='\033[40m'
BACKGROUND_RED='\033[41m'
BACKGROUND_GREEN='\033[42m'
BACKGROUND_YELLOW='\033[43m'
BACKGROUND_BLUE='\033[44m'
BACKGROUND_PURPLE='\033[45m'
BACKGROUND_CYAN='\033[46m'
BACKGROUND_WHITE='\033[47m'

# Reset all colors
RESET='\033[0m'

#  CORE VARS
stow_dir="$HOME/dotfiles"

function _help() {
  echo -e "${BOLD_GREEN}Usage: $0${RESET} [${BOLD_BLUE}action${RESET}]"
  echo -e ""
  echo -e "${BOLD_BLUE}Available actions:${RESET}"
  echo -e "  ${BOLD_BLUE}stow${RESET}: Stow the dotfiles to your home directory."
  echo -e "  ${BOLD_BLUE}unstow${RESET}: Unstow the dotfiles from your home directory."
  echo -e "  ${BOLD_BLUE}clean${RESET}: Remove the backup of your original configuration files."
  echo -e ""
  echo -e "${BOLD_BLUE}Description:${RESET}"
  echo -e "  This script is used to stow and unstow dotfiles in your home directory."
  echo -e "  It will symlink files from a directory named ${BOLD_GREEN}\$HOME/dotfiles${RESET} to their"
  echo -e "  corresponding locations in your home directory."
  echo -e ""
  echo -e "  You can use the ${BOLD_BLUE}stow${RESET} action to create symlinks in your home directory."
  echo -e "  If a file already exists in your home directory, it will be overridden by the symlink."
  echo -e "  Before overriding an existing file, the script will create a backup of the file in the"
  echo -e "  ${BOLD_GREEN}\$HOME/dotfiles/CONFIG_BACKUP${RESET} directory."
  echo -e ""
  echo -e "  You can use the ${BOLD_BLUE}unstow${RESET} action to remove the symlinks from your home directory."
  echo -e "  It will only remove symlinks that were created by the script."
  echo -e ""
  echo -e "  You can use the ${BOLD_BLUE}clean${RESET} action to remove the backup of your original configuration files."
  echo -e ""
  echo -e "${BOLD_BLUE}Options:${RESET}"
  echo -e "  ${BOLD_BLUE}--help${RESET}: Show this help message."
  echo -e ""
  echo -e "${BOLD_BLUE}Examples:${RESET}"
  echo -e "  To stow the dotfiles, run: ${BOLD_GREEN}$0 stow${RESET}"
  echo -e "  To unstow the dotfiles, run: ${BOLD_GREEN}$0 unstow${RESET}"
  echo -e "  To remove the backup of your original configuration files, run: ${BOLD_GREEN}$0 clean${RESET}"
}
if [[ "$1" == "--help" ]]; then
  # help --> 
_help
elif [[ "$1" == "stow" ]]; then
  # create a backup just in case
  backup="./CONFIG_BACKUP"
  if [ -d "$backup" ]; then
    echo -e "${BOLD_YELLOW}[CHECK]: Backup directory already exists. Skipping backup creation.${RESET}"
  else
    mkdir -p "$backup"
    cp -r "$HOME/.config/"* "$backup/"
    echo -e "${BOLD_GREEN}[CHECK]: Backup created in $backup.${RESET}"
  fi
  
  # link dirs
 for dir in "$stow_dir/.config/"*; do
    base_dir=$(basename "$dir")
    if [ -d "$HOME/.config/$base_dir" ]; then
      if [ -z "$(ls -A $HOME/.config/$base_dir)" ]; then
        echo -e "${BOLD_YELLOW}[INFO]: Directory $base_dir exists in $HOME/.config but is empty. Deleting...${RESET}"
        rm -rf "$HOME/.config/$base_dir"
      else
        echo -e "${BOLD_RED}[CHECK]: Directory $base_dir exists in $HOME/.config and will be overridden.${RESET}"
        echo -e "${BOLD_YELLOW}[INFO]: Deleting $HOME/.config/$base_dir...${RESET}"
        rm -rf "$HOME/.config/$base_dir"
      fi
    fi
    if ! ln -sf "$dir" "$HOME/.config/"; then
      echo -e "${BOLD_YELLOW}[INFO]: Failed to link $base_dir. Deleting $HOME/.config/$base_dir and trying again...${RESET}"
      rm -rf "$HOME/.config/$base_dir"
      ln -sf "$dir" "$HOME/.config/" && echo -e "${BOLD_RAINBOW}[SUCCESS]: Linked $base_dir!${RESET}"
    else
      echo -e "${BOLD_PURPLE}[SUCCESS]: Linked $base_dir!${RESET}"
    fi
  done

elif [[ "$1" == "clean" ]]; then
  echo -e "${BOLD_RED}Are you sure you want to delete the config backup?$BOLD_GREEN [ y / n ]$RESET"
  read confirm

  if [[ "$confirm" == "y" ]]; then
    # Delete the backup file
    rm -rf ./CONFIG_BACKUP
    echo -e "${BOLD_GREEN}[INFO]: Backup file $backup has been deleted.${RESET}"
  elif [[ "$confirm" == "n" ]]; then
    # Exit the script
    exit 0
  fi

  # unlink stuff
elif [[ "$1" == "unstow" ]]; then
  # unstow -->
  echo -e "${BOLD_PURPLE}[UNSTOW]:$RESET"
  
  for dir in "$HOME/.config/"*; do
    if [[ -L "$dir" && "$(readlink "$dir")" =~ "$stow_dir/.config/".* ]]; then
      unlink "$dir"
      echo -e "${BOLD_GREEN}[UNLINKED]: $dir${RESET}"
    fi
  done
elif [[ "$1" == "install" ]]; then
  sudo cp stow.sh /usr/bin/stowed
  sudo chmod +x /usr/bin/stowed

  # Define color codes
  GREEN='\033[0;32m'
  NC='\033[0m'

  # Check if fish shell is installed
  if command -v fish >/dev/null 2>&1; then
    # Install completion file for fish shell
    mkdir -p ~/.config/fish/completions
    cp ./stowed-autocomp.fish ~/.config/fish/completions/
    echo "Fish shell auto completion installed"
  fi

  # Notify user that stow.sh has been installed
  echo -e "${GREEN}stow.sh has been installed to /usr/bin as stowed. run stowed for help${NC}"

elif [[ "$1" == "uninstall" ]]; then
  if [ -f /usr/bin/stowed ]; then
    sudo rm -f /usr/bin/stowed
    echo -e "${BOLD_RED}stowed uninstalled${RESET}"
  else
    echo -e "${BOLD_RED}Error: stowed not found in /usr/bin.${RESET}"
  fi

else
  # main -->
  _help
fi
