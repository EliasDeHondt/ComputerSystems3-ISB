#!/usr/bin/env python3
############################
# @author Elias De Hondt   #
# @see https://eliasdh.com #
# @since 09/10/2024        #
############################
from scapy.all import sr, sr1, IP, ICMP

# Send an ICMP packet to the destination IP address
ans, unans = sr(IP(dst="192.168.1.99", ttl=5)/ICMP())
ans.nsummary()
unans.nsummary()
p = sr1(IP(dst="192.168.1.99")/ICMP()/b"XXXXXX")
p.show()