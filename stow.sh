#!/bin/bash

# source"
source colors.sh

stow_dir="$HOME/dotfiles"

if [[ "$1" == "--help" ]]; then
  # help --> 
function help {
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
help
elif [[ "$1" == "stow" ]]; then
  # stow -->
  echo -e "$BOLD_PURPLE[CHECKS $RED X $BOLD_PURPLE / $GREEN  $BOLD_PURPLE]:$RESET"
  
  # test if ~/dotfiles exists:
  if test -d "$stow_dir"; then
    echo -e "$BOLD_GREEN[CHECK]: Directory $stow_dir exists$RESET"
  else
    echo -e "${BOLD_RED}[CHECK]: ~/dotfiles directory does not exist.${RESET}"
  fi
 
  # test if ~/dotfiles/.config exists
  if test -d "$stow_dir/.config"; then
    echo -e "${BOLD_GREEN}[CHECK]: $stow_dir/.config exists.${RESET}"
  else
    echo -e "${BOLD_RED}[CHECK]: $stow_dir/.config does not exist.${RESET}"
  fi

  # link dirs
  # check if conflicting names in ~/dotfiles/.config/* exist in ~/.config
  for dir in "$stow_dir/.config/"*; do
    base_dir=$(basename "$dir")
    if [ -d "$HOME/.config/$base_dir" ]; then
      if [ -z "$(ls -A $HOME/.config/$base_dir)" ]; then
        echo -e "${BOLD_YELLOW}[INFO]: Directory $base_dir exists in $HOME/.config but is empty. Deleting...${RESET}"
        rm -rf "$HOME/.config/$base_dir"
      else
        echo -e "${BOLD_RED}[CHECK]: Directory $base_dir exists in $HOME/.config and will be overridden.${RESET}"
      fi
    fi
    ln -sf "$dir" "$HOME/.config/"
  done

  # create a backup just incase
  backup="./CONFIG_BACKUP"
  if [ -d "$backup" ]; then
    echo -e "${BOLD_YELLOW}[CHECK]: Backup directory already exists. Skipping backup creation.${RESET}"
  else
    mkdir -p "$backup"
    cp -r "$HOME/.config/"* "$backup/"
    echo -e "${BOLD_GREEN}[CHECK]: Backup created in $backup.${RESET}"
  fi
  
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

else
  # main -->
  echo "main"
fi
