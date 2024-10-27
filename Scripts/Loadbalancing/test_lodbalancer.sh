#!/bin/bash
############################
# @author Elias De Hondt   #
# @see https://eliasdh.com #
# @since 25/10/2024        #
############################
# test_lodbalancer.sh

# URLs of the web servers
URL1="http://10.3.0.1/index.html"
URL2="http://10.3.0.2/index.html"

while true; do
    # Try to fetch content from web server 1
    response1=$(curl -s --max-time 2 "$URL1")
    if [[ $? -eq 0 && -n "$response1" ]]; then
        echo "Content is from Webserver 1"
    else
        echo "Webserver 1 is down"
    fi

    # Try to fetch content from web server 2
    response2=$(curl -s --max-time 2 "$URL2")
    if [[ $? -eq 0 && -n "$response2" ]]; then
        echo "Content is from Webserver 2"
    else
        echo "Webserver 2 is down"
    fi

    # Check if both web servers are unreachable
    if [[ -z "$response1" && -z "$response2" ]]; then
        echo "Webserver 1 is down, Webserver 2 is down"
    fi

    # Wait 2 seconds before the next attempt
    sleep 2
done