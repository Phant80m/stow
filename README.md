# stowed
Gnu Stow... but mine
---

### auto gen docs:


This is a Bash script that can be used to stow and unstow dotfiles in the home directory. Stowing is the process of creating symlinks from a directory named $HOME/dotfiles to their corresponding locations in the home directory. Unstowing, on the other hand, removes the symlinks that were created by the script. The script can also create a backup of the original configuration files before overriding them with the symlinks.

The script takes one argument, which is the action to perform. The available actions are:

    stow: Stow the dotfiles to the home directory.
    unstow: Unstow the dotfiles from the home directory.
    clean: Remove the backup of the original configuration files.
    --help: help message
    --no-color: no color (some vars may still appear colored)

The script also has an option --help that shows the help message, which includes information on the available actions, options, and examples of how to use the script.

The script checks if the backup directory already exists and skips backup creation if it does. It also checks if a directory to be linked already exists in the home directory and overrides it with the symlink, creating a backup of the original configuration files before doing so. If the directory is empty, it deletes it first before creating the symlink.

To unstow, the script checks if a file is a symlink created by the script and removes it.

Overall, this script is useful for managing dotfiles in the home directory, making it easier to keep track of configuration files.
