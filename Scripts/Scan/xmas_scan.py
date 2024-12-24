#!/usr/bin/env python3
############################
# @author Elias De Hondt   #
# @see https://eliasdh.com #
# @since 09/10/2024        #
############################
from scapy.all import srp, Ether, IP, TCP
import time

def xmas_scan(target):
    for port in range(1, 65536):
        pkt = Ether(dst="ff:ff:ff:ff:ff:ff") / IP(dst=target) / TCP(dport=port, flags="FPU")
        start_time = time.time()
        ans, _ = srp(pkt, timeout=1, verbose=0)

        if ans:
            for snd, rcv in ans:
                elapsed_time = time.time() - start_time
                print(f"Datum/tijd: {time.strftime('%Y-%m-%d %H:%M:%S')}")
                print(f"Elapsed time: {elapsed_time:.3f} seconds")
                if rcv.haslayer(Ether):
                    print(f"MAC Address: {rcv[Ether].src}")
                print(f"Source IP: {rcv[IP].src}")
                print(f"Destination IP: {rcv[IP].dst}")
                print(f"Port {port}: Open")
        else:
            print(f"Port {port}: Closed/Filtered")

target_ip = "192.168.1.1"

xmas_scan(target_ip)