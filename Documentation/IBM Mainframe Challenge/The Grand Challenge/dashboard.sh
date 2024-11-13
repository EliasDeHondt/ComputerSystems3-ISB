#!/bin/bash
############################
# @author Elias De Hondt   #
# @see https://eliasdh.com #
# @since 12/11/2024        #
############################
# dashboard.sh

# UI variables
reset="\e[0m"                                           # Reset
red="\e[0;31m"                                          # Red
green="\e[0;32m"                                        # Green

# ASCII logo
ASCII_LOGO="
______   _       ___       _      _____   _____    _   _ \n
| ____| | |     |_ _|     / \    /  ___|  |  _ \  | | | |\n
| |_    | |      | |     / _ \   |  |__   | | | | | |_| |\n
|  _|   | |      | |    / /_\ \   \___ \  | | | | |  _  |\n
| |___  | |___   | |   /  ___  \   ___) | | |_| | | | | |\n
|_____| |_____| |___| /_/     \_\ |_____/ |____/  |_| |_|\n
\n
This script is executed locally on this machine. EliasDH is not responsible for any damages.\n
\n
Privacy Policy: https://eliasdh.com/assets/pages/privacy-policy.html\n
\n
Legal Guidelines: https://eliasdh.com/assets/pages/legal-guidelines.html\n
"

function error_exit() { # Functie: Error afhandeling.
    dialog --title "Error" --msgbox "\n$1\n" 10 20
    clear
    exit 1
}

function success_exit() { # Functie: Succes afhandeling.
    dialog --title "Success" --msgbox "\n$1\n" 10 20
    clear
    exit 0
}

function check_privileges() { # Function: Check that the script is not executed with elevated privileges.
    if [ "$EUID" -eq 0 ]; then error_exit "Do not run this script as root."; fi
}

function check_options() { # Functie: Checks if there were any options given to the script.
    case "$1" in
        --help|-h) echo -e "*\n* ${yellow}Usage:${reset}\n*   ./dashboard.sh [OPTION]\n*"
        success_exit;;
    esac
}

function check_dependencies() { # Function: Check for required dependencies.
    local REQUIRED_DEPENDENCIES=("$@")
    local MISSING_DEPENDENCIES=()

    if [ ! -f "./dashboard-script.log" ]; then touch ./dashboard-script.log; fi

    for dep in "${REQUIRED_DEPENDENCIES[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            MISSING_DEPENDENCIES+=("$dep")
        fi
    done

    if [ ${#MISSING_DEPENDENCIES[@]} -eq 0 ]; then
        echo -e "${green}All required dependencies are installed!${reset}"
    else
        echo -e "${red}Missing dependencies:${reset}"
        for dep in "${MISSING_DEPENDENCIES[@]}"; do
            echo -e "- ${red}$dep${reset}"
        done
        error_exit "Install the missing dependencies and try again."
    fi
}

function wait_for_job() { # Functie: Wacht tot de job klaar is.
    local JOB_ID="$1"
    local JOB_STATUS=""

    while [ "$JOB_STATUS" != "OUTPUT" ] && [ "$JOB_STATUS" != "ABEND" ] && [ "$JOB_STATUS" != "ENDED" ]; do
        JOB_STATUS=$(zowe jobs view job-status-by-jobid "$JOB_ID" --rff status --rft string)
        sleep 5
    done

    if [ "$JOB_STATUS" == "ABEND" ]; then
        error_exit "The job ended with an error."
    fi
}

function statistics() { # Functie: Collects statistics from mainframe.
    #local IBM_USER=$(jq -r '.profiles.zosmf.properties.user' ~/.zowe/zowe.config.json)
    #local IBM_PASSWORD=$(jq -r '.profiles.zosmf.properties.password' ~/.zowe/zowe.config.json)
    local JOB_OUTPUT_FILE="job_output.txt"


    # Submit JCL job to collect statistics en get id
    local JOB_ID=$(zowe jobs submit data-set "Z58577.JCL(STATS)" --rff jobid --rft string)

    wait_for_job "$JOB_ID"

    # Get job output
    zowe jobs dl output "$JOB_ID"

    # TODO: Create a JCL that gives statistics back from Mainframe
}









function credits() { # Functie: Credits of the developers.
    dialog --title "Credits" --msgbox "\n\nDeveloped by:\n    Elias De Hondt\n      https://github.com/EliasDeHondt" 10 62
    main
}

function main() { # Functie: Main functie.
    check_privileges
    check_options "$1"
    check_dependencies "dialog" "curl"

    dialog --title "Welcome to The Grand Challenge" --msgbox "\n$ASCII_LOGO\n" 20 62

    local CHOICE=$(dialog --title "Select an option" --menu "Choose one of the following options:" 15 50 3 \
        1 "View statistics" \
        2 "Credits" \
        3 "Exit" 3>&1 1>&2 2>&3)

    case "$CHOICE" in
        1) statistics;;
        2) credits;;
        3) success_exit "Exiting script.";;
        *) error_exit "Invalid choice.";;
    esac
}

main "$1" # Start the script.