#!/bin/bash

# source"
source colors.sh

stow_dir="$HOME/dotfiles"


if [[ "$1" == "--help" ]]; then
  # help --> 
  echo -e "Usage: $BOLD_GREEN./script.sh$RESET [arguments]"
  
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
            echo -e "${BOLD_YELLOW}[INFO]: Directory $base_dir exists in $HOME/.config but is empty.${RESET}"

        else
            echo -e "${BOLD_RED}[CHECK]: Directory $base_dir exists in $HOME/.config and will be overridden.${RESET}"
            ln -sf "$dir" "$HOME/.config/"
        fi
    else
        ln -sf "$dir" "$HOME/.config/"
    fi
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

# clean function
  
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



  # unstow dirs

  elif [[ "$1" == "unstow" ]]; then
  # unstow -->
  for dir in "$stow_dir/.config/"*; do
    if [ -L "$HOME/.config/$(basename "$dir")" ]; then
      rm "$HOME/.config/$(basename "$dir")"
      echo -e "${BOLD_GREEN}[INFO]: Symlink removed for $(basename "$dir").${RESET}"
    fi
  done
  echo -e "${BOLD_GREEN}[INFO]: All stowed directories have been unlinked.${RESET}"

    
else
  # main -->
  echo "main"
fi
fi