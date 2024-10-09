#!/usr/bin/env python3
############################
# @author Elias De Hondt   #
# @see https://eliasdh.com #
# @since 09/10/2024        #
############################
from scapy.all import sniff
from os import getuid

if getuid() != 0:
    print("Warning: Starting as non root user!")

try:
    packets = sniff(count=10)
    packets.summary()
except:
    print("Error: Unable to sniff packets, try using sudo.")
    exit(1)