#!/usr/bin/env python3
############################
# @author Elias De Hondt   #
# @see https://eliasdh.com #
# @since 09/10/2024        #
############################
from scapy.all import *

target_ip = "192.168.1.1"  # Replace with your target IP
ports = [53, 69, 123, 161]  # Replace with the UDP ports you want to scan

def udp_scan(target_ip, port):
    packet = IP(dst=target_ip) / UDP(dport=port)
    response = sr1(packet, timeout=1, verbose=0)

    if response is None:
        print(f"Port {port} is open or filtered (no response).")
    elif response.haslayer(ICMP) and response[ICMP].type == 3 and response[ICMP].code == 3:
        print(f"Port {port} is closed (ICMP port unreachable).")
    else:
        print(f"Port {port}: No ICMP layer in response.")

for port in ports:
    udp_scan(target_ip, port)