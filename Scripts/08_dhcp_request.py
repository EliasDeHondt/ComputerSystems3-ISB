#!/usr/bin/env python3
############################
# @author Elias De Hondt   #
# @see https://eliasdh.com #
# @since 09/10/2024        #
############################
from scapy.all import sniff, sendp, Ether, IP, UDP, BOOTP, DHCP
import time

found_servers = set()

interface = "ens18"

def handle_dhcp(packet):
    if packet.haslayer(DHCP) and packet[DHCP].options[0][1] == 2:
        dhcp_server_ip = packet[IP].src
        found_servers.add(dhcp_server_ip)
        print(f"[*] DHCP Server found: {dhcp_server_ip}")

def send_dhcp_discover():
    discover = Ether(dst="ff:ff:ff:ff:ff:ff") / IP(src="0.0.0.0", dst="255.255.255.255") / UDP(sport=68, dport=67) / BOOTP(chaddr="12:34:56:78:9a:bc") / DHCP(options=[("message-type", "discover"), "end"])
    sendp(discover, iface=interface)
    print(f"[*] DHCP Discover packet sent via interface {interface}.")

send_dhcp_discover()

print(f"[*] Listening for DHCP responses on {interface}... (press Ctrl+C to stop)")
while True:
    try:
        sniff(filter="udp and (port 67 or port 68)", prn=handle_dhcp, iface=interface, timeout=5)
        time.sleep(1)

        if found_servers:
            print("Found DHCP servers:")
            for server in found_servers:
                print(f"  - {server}")

    except KeyboardInterrupt:
        print("\nStopping...")
        break