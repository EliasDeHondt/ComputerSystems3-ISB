#!/usr/bin/env python3
############################
# @author Elias De Hondt   #
# @see https://eliasdh.com #
# @since 09/10/2024        #
############################
from scapy.all import *

target_ip = "192.168.1.1"  # Replace with your target IP
ports = [80, 443, 22, 25]  # Replace with the ports you want to scan

def ack_scan(target_ip, port):
    packet = IP(dst=target_ip) / TCP(dport=port, flags="A")
    response = sr1(packet, timeout=1, verbose=0)

    if response is None:
        print(f"Port {port} is filtered (no response).")
    elif response.haslayer(TCP):
        if response[TCP].flags == "R":
            print(f"Port {port} is unfiltered (RST received).")
        else:
            print(f"Port {port} returned unexpected flags: {response[TCP].flags}")
    else:
        print(f"Port {port}: No TCP layer in response.")

for port in ports:
    ack_scan(target_ip, port)