#!/usr/bin/env python3
############################
# @author Elias De Hondt   #
# @see https://eliasdh.com #
# @since 09/10/2024        #
############################
from scapy.all import sniff

__description__ = "Scapy Sniffing Script"
about = "##### " + __description__ + " #####"
print(about)

# Sniff 10 packets
packets = sniff(count=10)
packets.summary()