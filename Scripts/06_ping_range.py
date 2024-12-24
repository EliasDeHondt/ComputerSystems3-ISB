#!/usr/bin/env python3
############################
# @author Elias De Hondt   #
# @see https://eliasdh.com #
# @since 09/10/2024        #
############################
from scapy.all import sr, IP, ICMP
import sys
import logging

logging.getLogger("scapy.runtime").setLevel(logging.ERROR)
if len(sys.argv) != 2:
    print("Usage: " + sys.argv[0] + " <network>")
    print(" eg:"+ sys.argv[0] + " 192.168.1.0/24 \n")
    print(" eg:"+ sys.argv[0] + " 192.168.1.101-103")
    sys.exit(1)
ans,unans=sr(IP(dst=sys.argv[1])/ICMP(),timeout=1)
print("<html><ol>")
for s,r in ans:
    #r.show()
    print(r.sprintf("<li>received %IP.src% %ICMP.type%</li>\n"))
print("</ol></html>")