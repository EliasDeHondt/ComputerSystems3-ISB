#!/usr/bin/env python3
############################
# @author Elias De Hondt   #
# @see https://eliasdh.com #
# @since 09/10/2024        #
############################
import sys
from scapy.all import sr1, IP, ICMP

# Send an ICMP packet to the destination IP address
p = sr1(IP(dst=sys.argv[1])/ICMP(), timeout=1)
if p:
    p.show()