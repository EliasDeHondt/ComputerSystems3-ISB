#!/usr/bin/env python3
############################
# @author Elias De Hondt   #
# @see https://eliasdh.com #
# @since 09/10/2024        #
############################
import sys
from scapy.all import sniff, wrpcap

def save_packets(filename):
    packets = sniff(count=10)
    wrpcap(filename, packets)
    print(f"[*] {len(packets)} packets saved to {filename}")

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: sudo python3 sniff_and_save.py <filename>")
        sys.exit(1)

    pcap_filename = sys.argv[1]
    save_packets(pcap_filename)

    os.system(f"wireshark {pcap_filename} &")