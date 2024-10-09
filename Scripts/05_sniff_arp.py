#!/usr/bin/env python3
############################
# @author Elias De Hondt   #
# @see https://eliasdh.com #
# @since 09/10/2024        #
############################
from scapy.all import sniff

# Define a callback function to process each packet
def process_packet(packet):
    if packet.haslayer("ARP"):
        print(packet.sprintf("ARP SRC address %ARP.psrc% DST address %ARP.pdst%"))

# Sniff ARP packets
packets = sniff(filter="arp", count=5)

# Process each packet
for packet in packets:
    process_packet(packet)