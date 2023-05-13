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

# rnbw
# Define a function that outputs a rainbow-colored string
function bold_rainbow {
  # Define the color palette
  colors=("\033[31m" "\033[33m" "\033[32m" "\033[36m" "\033[34m" "\033[35m")
  
  # Loop through each character in the string argument
  for (( i=0; i<${#1}; i++ )); do
    # Get the color code based on the index in the color palette
    color="${colors[$i % ${#colors[@]}]}"
    
    # Output the character in the color
    echo -ne "${color}${1:$i:1}"
  done
  
  # Reset the color to default
  echo -e "\033[0m"
}
