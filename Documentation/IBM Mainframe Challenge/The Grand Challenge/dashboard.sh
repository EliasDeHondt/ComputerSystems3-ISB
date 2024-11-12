#!/bin/sh
############################
# @author Elias De Hondt   #
# @see https://eliasdh.com #
# @since 12/11/2024        #
############################
# dashboard.sh

# UI variables
reset="\e[0m"                                                               # Reset
red="\e[0;31m"                                                              # Red
blue="\e[0;34m"                                                             # Blue
yellow="\e[0;33m"                                                           # Yellow
green="\e[0;32m"                                                            # Green
global_staps=21                                                             # Number of steps


function error_exit() { # Functie: Error afhandeling.
    echo -e "\n*\n* ${red}$1${reset}\n*\n* Exiting script.\n${line}"
    exit 1
}

function success_exit() { # Functie: Succes afhandeling.
    echo -e "*\n* ${green}$1${reset}\n*\n${line}"
    exit 0
}

function success() { # Functie: Succes afhandeling.
    echo -e "\n*\n* ${green}$1${reset}\n*"
}

function skip() { # Functie: Skip afhandeling.
    echo -e "\n*\n* ${yellow}$1${reset}\n*"
}

function banner_message() { # Functie: Banner message.
    clear
    local MESSAGE="$1"
    local LENGTH=$(( ${#MESSAGE} + 2 ))
    line="*$(printf "%${LENGTH}s" | tr ' ' '*')*"
    local LINE1="*$(printf "%${LENGTH}s" | tr ' ' ' ')*"
    echo "$line" && echo "$LINE1"
    echo -e "* ${blue}$MESSAGE${reset} *"
    echo "$LINE1" && echo "$line"
}

function options_check() { # Functie: Checks if there were any options given to the script.
    case "$1" in
        --help) echo -e "*\n* ${yellow}Usage:${reset}\n*   ./dashboard.sh [OPTION]\n*"
        success_exit;;
        -h) echo -e "*\n* ${yellow}Usage:${reset}\n*   ./dashboard.sh [OPTION]\n*"
        success_exit;;
        *) error_exit "Invalid option. Use --help for more information.";;
    esac
}

function bash_validation() { # Functie: Bash validatie.
    if [ ! -f "./dashboard-script.log" ]; then touch ./dashboard-script.log; fi
}

function loading_icon() { # Functie: Print the loading icon.
    local load_interval="${1}"
    local loading_message="${2}"
    local elapsed=0
    local loading_animation=( '⠾' "⠷" '⠯' '⠟' '⠻' '⠽' )
    echo -n "${loading_message} "
    tput civis
    trap "tput cnorm" EXIT
    while [ "${load_interval}" -ne "${elapsed}" ]; do
        for frame in "${loading_animation[@]}" ; do
            printf "%s\b" "${frame}"
            sleep 0.25
        done
        elapsed=$(( elapsed + 1 ))
    done
    printf " \b"
    exit 1
}

function statistics { # Functie: Collects statistics
    
}

function credits() { # Functie: Credits of the developers.
    local COLOR_ELIAS_DE_HONDT="\033[96m"             # Light cyan
    local GITGUB_URL_ELIAS_DE_HONDT="https://github.com/EliasDeHondt"
    banner_message "          Credits          "
    echo -e "*\n* ${COLOR_ELIAS_DE_HONDT}Elias De Hondt${reset}"
    echo -e "*   | ${COLOR_ELIAS_DE_HONDT}GitHub: ${GITGUB_URL_ELIAS_DE_HONDT}${reset}"
    echo -e "${line}"
    sleep 10
    main
}

function main() { # Functie: Main functie.
    banner_message "Welcome to The Grand Challenge!"
    bash_validation
    options_check "$1"

    echo -e "*\n* ${blue}[1]${reset} View statistics\n* ${blue}[2]${reset} Credits\n* ${blue}[3]${reset} Exit"
    read -p "* Enter the number of your choice: " choice
    echo -e "*"
    case "$choice" in
        1)
        banner_message "Statistics"
        statistics
        ;;
        2) credits;;
        3) success_exit "Exiting script.";;
        *) error_exit "Invalid choice.";;
    esac
}

main "$1" # Start the script.