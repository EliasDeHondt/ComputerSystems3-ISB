#!/usr/bin/env python3
############################
# @author Elias De Hondt   #
# @see https://eliasdh.com #
# @since 09/10/2024        #
############################
from scapy.all import *
import time

def syn_scan(target):
    for port in range(1, 65536):
        pkt = IP(dst=target)/TCP(dport=port, flags="S")
        start_time = time.time()
        ans, _ = sr(pkt, timeout=1, verbose=0)

        if ans:
            for _, rcv in ans:
                elapsed_time = time.time() - start_time
                print(f"Datum/tijd: {time.strftime('%Y-%m-%d %H:%M:%S')}")
                print(f"Elapsed time: {elapsed_time:.3f} seconds")
                if hasattr(rcv, 'src'):
                    print(f"IP Address: {rcv.src}")
                else:
                    print("MAC Address: Not available")
                print(f"Port {port}: Open")
        else:
            print(f"Port {port}: Closed/Filtered")

target_ip = "192.168.1.1"

syn_scan(target_ip)