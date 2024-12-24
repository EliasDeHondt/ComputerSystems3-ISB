#!/usr/bin/env python3
############################
# @author Elias De Hondt   #
# @see https://eliasdh.com #
# @since 09/10/2024        #
############################
import argparse
import time
from scapy.all import sr1, IP, TCP

def xmas_scan(target):
    print(f"Starting XMAS scan on {target}")
    start_time_total = time.time()

    for port in range(1, 65536):
        start_time = time.time()
        pkt = IP(dst=target) / TCP(dport=port, flags="FPU")
        response = sr1(pkt, timeout=1, verbose=0)

        elapsed_time = time.time() - start_time
        print(f"Datum/tijd: {time.strftime('%Y-%m-%d %H:%M:%S')}")
        print(f"Elapsed time: {elapsed_time:.3f} seconds")

        if response:
            if response.haslayer(TCP):
                if response[TCP].flags == "RA": # Response: Reset-Ack
                    print(f"Port {port}: Closed")
                else: # No response
                    print(f"Port {port}: Filtered/Unknown")
            elif response.haslayer(IP): # Response: IP
                print(f"Port {port}: No response but IP reply received.")
        else: # No response
            print(f"Port {port}: No response (Open|Filtered)")

    total_elapsed = time.time() - start_time_total
    print(f"Scan completed in {total_elapsed:.3f} seconds.")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Perform a XMAS scan on a target IP.")
    parser.add_argument("target", help="Target IP address to scan")
    args = parser.parse_args()

    xmas_scan(args.target)