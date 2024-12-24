#!/usr/bin/env python3
############################
# @author Elias De Hondt   #
# @see https://eliasdh.com #
# @since 09/10/2024        #
############################
from scapy.all import send, sendp, IP, ICMP, Ether

# Send an ICMP packet at layer 4
send(IP(dst="127.0.0.1")/ICMP())

# Send 4 packets at layer 3 and layer 2
sendp(Ether()/IP(dst="127.0.0.1", ttl=(1, 4)))