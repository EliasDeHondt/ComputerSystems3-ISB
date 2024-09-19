#!/bin/bash
############################
# @author Elias De Hondt   #
# @see https://eliasdh.com #
# @since 19/09/2024        #
############################

while true; do
    echo "Hello World $(date)" >> /var/log/helloworld.log;
    sleep 10;
done