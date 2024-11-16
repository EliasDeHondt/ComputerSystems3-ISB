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
yellow="\e[0;33m"                                       # Yellow

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

function create_log() { # Functie: Create log file.
    local LOG_FILE="./dashboard-script.log"
    local DATE=$(date)
    local MESSAGE="$1"

    if [ ! -f "$LOG_FILE" ]; then touch "$LOG_FILE"; fi
    echo -e "[$DATE] $MESSAGE" >> "$LOG_FILE"
}

function error_exit() { # Functie: Error afhandeling.
    dialog --title "Error" --msgbox "\n$1\n" 10 20
    create_log "$1"
    clear
    exit 1
}

function success_exit() { # Functie: Succes afhandeling.
    dialog --title "Success" --msgbox "\n$1\n" 10 20
    create_log "$1"
    clear
    exit 0
}

function check_privileges() { # Function: Check that the script is not executed with elevated privileges.
    if [ "$EUID" -eq 0 ]; then error_exit "Do not run this script as root."; fi
}

function check_options() { # Functie: Checks if there were any options given to the script.
    printf "%.0s*" {1..40}
    case "$1" in
        --help|-h)
        echo -e "\n*\n* ${yellow}Usage:${reset}\n*   ./dashboard.sh [OPTION]\n*"
        echo -e "* ${yellow}Options:${reset}\n*   ${green}--help${reset},       ${green}-h${reset}   Display this help message\n*   ${green}--statistics${reset}, ${green}-s${reset}   Collect statistics from mainframe\n*   ${green}--logs${reset},       ${green}-l${reset}   View logs\n*   ${green}--credits${reset},    ${green}-c${reset}   View credits\n*";;
        --submit-job|-j) submit_job;;
        --statistics|-s) statistics;;
        --logs|-l) logs;;
        --credits|-c) credits;;
        *) return;;
    esac
    printf "%.0s*" {1..40}
    echo -e
    exit 0
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

    dialog --title "Job Status" --msgbox "The job has ended successfully.\nPress OK to continue." 8 50
}

function statistics() { # Functie: Collects statistics from mainframe.
    dialog --title "Statistics" --msgbox "This process may take a while.\nPress OK to continue." 8 50

    local IBM_USER=$(jq -r '.profiles.zosmf.properties.user' ~/.zowe/zowe.config.json)
    local IBM_USER_LOWERCASE=$(echo "$IBM_USER" | tr '[:upper:]' '[:lower:]')
    local JOB_ID=$(zowe jobs submit data-set "$IBM_USER.JCL(STATS)" --rff jobid --rft string)

    wait_for_job "$JOB_ID"

    zowe files download data-set "$IBM_USER.METRICS"

    if [ ! -f "$IBM_USER_LOWERCASE/metrics.txt" ]; then error_exit "Download failed."; fi

    local METRICS=$(cat $IBM_USER_LOWERCASE/metrics.txt)
    rm -r $IBM_USER_LOWERCASE

    zowe files delete data-set "$IBM_USER.METRICS" -f

    dialog --title "Statistics" --msgbox "$METRICS" 35 62
    main
}

function submit_job() { # Functie: Submit job to mainframe.
    local IBM_USER=$(jq -r '.profiles.zosmf.properties.user' ~/.zowe/zowe.config.json)
    local JOBS_LIST=$(zowe files list all-members "$IBM_USER.JCL")
    local MENU_ITEMS=()
    local COUNT=1

    while IFS= read -r JOB; do
        MENU_ITEMS+=("$COUNT" "$JOB")
        ((COUNT++))
    done <<< "$JOBS_LIST"

    if [ ${#MENU_ITEMS[@]} -eq 0 ]; then
        error_exit "No jobs found in $IBM_USER.JCL"
    fi

    local CHOICE=$(dialog --title "Select A Job To Submit" --menu "Choose one of the following jobs:" 15 50 3 "${MENU_ITEMS[@]}" 3>&1 1>&2 2>&3)

    dialog --title "Selected Job" --msgbox "You have selected the job: ${MENU_ITEMS[$CHOICE]}\nPress OK to continue." 8 50

    local JOB_ID=$(zowe jobs submit data-set "$IBM_USER.JCL(${MENU_ITEMS[$CHOICE]})" --rff jobid --rft string)

    wait_for_job "$JOB_ID"

    main
}

function logs() { # Functie: View logs.
    dialog --title "Logs" --textbox "./dashboard-script.log" 20 62
    main
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
        2 "Submit job" \
        3 "View logs" \
        4 "Credits" \
        5 "Exit" 3>&1 1>&2 2>&3)

    case "$CHOICE" in
        1) statistics;;
        2) submit_job;;
        3) logs;;
        4) credits;;
        5) success_exit "Exiting script.";;
        *) error_exit "Invalid choice.";;
    esac
}

main "$1" # Start the script.