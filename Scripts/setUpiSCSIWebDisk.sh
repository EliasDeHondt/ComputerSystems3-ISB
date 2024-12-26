#!/bin/bash
############################
# @author Elias De Hondt   #
# @see https://eliasdh.com #
# @since 25/10/2024        #
############################

# UI variables
reset="\e[0m"                                           # Reset
red="\e[0;31m"                                          # Red
green="\e[0;32m"                                        # Green

function error_exit() { # Function: Error handling.
    echo -e "${red}$1${reset}"
    exit 1
}

function check_privileges() { # Function: Check if the script is run as root.
    if [ "$EUID" -ne 0 ]; then
        error_exit "Please run this script as root."
    fi
}

function check_dependencies() { # Function: Check for required dependencies.
    local REQUIRED_DEPENDENCIES=("$@")
    local MISSING_DEPENDENCIES=()

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

function ufw_firewall() { # Function: Open the firewall for a specific port.
    local PORT="$1"
    local AS="$2"
    sudo ufw $AS "$PORT"/tcp
    sudo ufw reload
}

function CreateDisk() { # Function: Create the iSCSI disk.
    sudo mkdir -p /iscsi
    sudo targetcli <<EOF
    cd /backstores/fileio
    create "$1" /iscsi/"$1".img "$2"
    cd /iscsi
    create iqn.2024-10.be.kdg:"$1"
    cd /iscsi/iqn.2024-10.be.kdg:"$1"/tpg1/luns
    cd iqn.2024-10.be.kdg:"$1"/tpg1/luns
    create /backstores/fileio/"$1"
    cd /iscsi/iqn.2024-10.be.kdg:"$1"/tpg1/acls
    create iqn.2024-10.be.kdg:init1
    exit
EOF
    sudo systemctl enable rtslib-fb-targetctl
    sudo targetcli saveconfig /root/target.json
}

function RemoveDisk() { # Function: Remove the iSCSI disk.
    targetcli <<EOF
    cd /iscsi
    delete iqn.2024-10.be.kdg:"$2"
    exit
EOF
    sudo systemctl enable rtslib-fb-targetctl
    sudo targetcli saveconfig /root/target.json
}

function Main() {
    check_privileges
    check_dependencies "ssh" "targetcli"
    local NAME_DISK="$2"
    local DISK_SIZE="$3"

    if [ -z "$NAME_DISK" ]; then
        error_exit "Please provide a name for the disk."
    fi

    case "$1" in
        -c)
            CreateDisk $NAME_DISK $DISK_SIZE $INDEX
            ufw_firewall 3260 "allow"
            ;;
        -r)
            RemoveDisk $NAME_DISK
            ufw_firewall 3260 "delete"
            ;;
        *)
            error_exit "Invalid option."
            ;;
    esac
}

Main "$@"