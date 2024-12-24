![logo](https://eliasdh.com/assets/media/images/logo-github.png)
# 💙🤍W4P1 Scapy🤍💙

## 📘Table of Contents

1. [📘Table of Contents](#📘table-of-contents)
2. [📝Assignment](#📝assignment)
3. [✨Exercises](#✨exercises)
    1. [👉Exercise 0: Install necessary software packages](#👉exercise-0-install-necessary-software-packages)
    2. [👉Exercise 1: Sniffing](#👉exercise-1-sniffing)
    3. [👉Exercise 2: Sending packets](#👉exercise-2-sending-packets)
    4. [👉Exercise 3: Sending and receiving](#👉exercise-3-sending-and-receiving)
    5. [👉Exercise 4: Script with arguments](#👉exercise-4-script-with-arguments)
    6. [👉Exercise 5: ARP packet](#👉exercise-5-arp-packet)
    7. [👉Exercise 6: Ping range](#👉exercise-6-ping-range)
    8. [👉Exercise 7: Graphical traceroute](#👉exercise-7-graphical-traceroute)
    9. [👉Exercise 8: DHCP request](#👉exercise-8-dhcp-request)
    10. [👉Exercise 9: Scans](#👉exercise-9-scans)
    11. [👉Exercise 10: Writing PCAP](#👉exercise-10-writing-pcap)
4. [📦Extra](#📦extra)
5. [🔗Links](#🔗links)

---

### 📝Assignment 
> NOTE This is in Dutch

- NODIG:  
    - [Ubuntu 18.04 LTS](http://ftp.belnet.be/ubuntu-releases/18.04): `sudo apt-get install nmap wireshark tcpdump python3-scapy python3-crypto ipython3 python3 graphviz imagemagick`. Voorzie een Host-Only adapter en een NAT adapter! 
    - [Slitaz](http://mirror1.slitaz.org/iso/4.0/slitaz-4.0.iso).
    - [REF1](https://readthedocs.org/projects/scapy/downloads/pdf/latest).
    - [REF2](https://theitgeekchronicles.files.wordpress.com/2012/05/scapyguide1.pdf).

- OPGAVE: 
    - Opgelet! Alle oefeningen moeten werken in python v3 

1. SNIFFING 
- Open een editor en schrijf script `01_sniff.py`:
```python
#!/usr/bin/env python3
from scapy.all import sniff 
about=     "##### "+  __description__ + " #####" 
print(about) 
packets=sniff(count=10) 
packets.summary() 
```
- Maak het bestand executable en start het op als root gebruiker:
```bash
chmod +x 01_sniff.py 
sudo ./01_sniff.py
```
- Als er wat netwerkcommunicatie is, zie je een samenvatting van de 10 volgende pakketten die aankomen of vertrekken. 
- Ideaal kijkt jouw script na of het als rootgebruiker opgestart is. 
- Verder kan je fouten opvangen met een try/except structuur. Probeer script `01b_sniff.py` uit:
```python
#!/usr/bin/env python3 
from scapy.all import sniff 
from os import getuid 
if getuid() != 0 : 
   print("Warning: Starting as non root user!") 
try: 
   packets=sniff(count=10) 
   packets.summary() 
except: 
   print("Error: Unable to sniff packets, try using sudo.") 
   exit(1)
```
```bash
./01_sniff.py 
# Warning: Starting as non root user! 
# Error: Unable to sniff packets, try using sudo. 
```

2. VERZENDEN PAKKETTEN 
- Pakketten kan je versturen met de functies `send()` en `sendp()`. Send verstuurt pakketten op laag 3, 
- Sendp verstuurt pakketten op laag 2. Schrijf het programma `02_send.py`:
```python
#!/usr/bin/env python3 
from scapy.all import * 
send(IP(dst="127.0.0.1")/ICMP()) 
sendp(Ether()/IP(dst="127.0.0.1",ttl=(1,4)))
```
- Het programma stuurt een ICMP pakket op laag 4 (ICMP) en laag 3 (IP). 
- Daarna stuurt het programma 4 pakketten op laag 3 (IP) en laag 2 (Ether). 
- Je krijgt bij uitvoer enkel te zien dat er eerst 1 en daarna 4 pakketten verzonden worden. 

3. ZENDEN EN ONTVANGEN 
- Buiten het verzenden van pakketten, weten we graag welke reactie er komt van het andere systeem. 
- Start hiervoor in Virtualbox of VMware een Live versie op van het mini Linux systeem Slitaz. Kies een Host-Only Adapter als eerste netwerkverbinding. In Slitaz open je een terminal en geef je het commando "ip address" om je adres te zien. In het voorbeeld gebruiken we `192.168.56.101` als adres. 
```plaintext
tux@slitaz:~$ 
 1: lo: <LOOPBACK,UP,LOWER_UP> mtu 16436 qdisc noqueue state UNKNOWN 
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00 
    inet 127.0.0.1/8 scope host lo 
 2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP 
    link/ether 08:a2:d6:42:39:df brd ff:ff:ff:ff:ff:ff 
    inet 192.168.56,101/24 brd 192.168.1.255 scope global eth0
```
- We kunnen met de functie `sr1()` een antwoord ontvangen of met `sr()` meerdere antwoorden. Schrijf 
het script `03_sendreceive.py`:
```python
#!/usr/bin/env python3 
from scapy.all import * 
ans,unans=sr(IP(dst="192.168.56.101",ttl=5)/ICMP())  
ans.nsummary()  
unans.nsummary()  
p=sr1(IP(dst="192.168.56.101")/ICMP()/"XXXXXX")  
p.show()  
```
- Opgelet `sr()` en `sr1()` verzenden enkel pakketten op laag 3. Als je pakketten op laag 2 wil verzenden, kan dat met `srp()` en `srp1()`.

4. SCRIPT MET ARGUMENTEN 
Handiger is als je het ip adres als argument kan meegeven met je script. Schrijf `04_sr_arg.py` met volgende inhoud:
```python
#!/usr/bin/env python3 
import sys 
from scapy.all import sr1,IP,ICMP 
p=sr1(IP(dst=sys.argv[1])/ICMP(),timeout=1) 
if p: 
    p.show()
```
- Start het programma als volgt:
```bash
sudo ./04_sr_arg.py 192.168.56.101 
```

5. ARP PAKKET 
- Je snift 1 ARP pakket met de functie `sniff()`. Om enkel een ARP pakket te krijgen  gebruik je de optie `filter=arp`s. Verder gebruik je de optie `prn=analyze`. De optie prn start een functie op, telkens dat hij een pakket vindt dat overeenkomt.
```python
#!/usr/bin/env python3 
from scapy.all import * 
def analyze(p): 
    p.show() 
packet=sniff(filter="arp",prn=analyze,count=1) 
print(packet)
```
- Start het programma als volgt:
```bash
sudo ./05_sniff_arp.py
```
- Start nu vanuit slitaz een ping op naar een adres in dezelfde range. Hierdoor zal slitaz een ARP pakket moeten sturen om te vragen wat het hardware adres (MAC) is van het ip adres.
```bash
ping -c 1 192.168.56.200 
```
- De sniffer stopt en geeft het ARP pakket weer: 
```plaintext
###[ Ethernet ]### 
    dst       = ff:ff:ff:ff:ff:ff 
    src       = 08:00:27:37:94:a2 
    type      = ARP 
###[ ARP ]### 
    hwtype    = 0x1 
    ptype     = IPv4 
    hwlen     = 6 
    plen      = 4 
    op        = who-has 
    hwsrc     = 08:00:27:37:94:a2 
    psrc      = 192.168.56.101 
    hwdst     = 00:00:00:00:00:00 
    pdst      = 192.168.56.200 
<Sniffed: TCP:0 UDP:0 ICMP:0 Other:1>
```
- Wil je de output nog meer filteren bijvoorbeeld enkel de velden psrc en pdst van het ARP pakket, dan kan dat met de sprintf functie (familie van sprintf in de taal C ).
```python
print(p.sprintf("ARP SRC adres %ARP.psrc% DST adres %ARP.pdst%"))
```
- Probeer dit uit!

6. PING RANGE 
- Voorbeeld met een argument. We sturen een ICMP pakket (default "echo") en bekijken enkel wie antwoord op de ping met een echo-reply. De opmaak van de output doen we in HTML formaat:
```python
#!/usr/bin/env python3 
from scapy.all import sniff 
import sys 
import logging                    
# disable Warnings 
logging.getLogger("scapy.runtime").setLevel(logging.ERROR) 
if len(sys.argv) != 2: 
print("Usage: " + sys.argv[0] + " <network>") 
print("       
eg:"+ sys.argv[0] + " 192.168.56.0/24 \n") 
print("       
eg:"+ sys.argv[0] + " 192.168.56.101-103") 
sys.exit(1) 
ans,unans=sr(IP(dst=sys.argv[1])/ICMP(),timeout=1) 
print("<html><ol>") 
for s,r in ans: 
#r.show() 
print(r.sprintf("<li>received %IP.src% %ICMP.type%</li>\n")) 
print("</ol></html>")
```

7. GRAFISCHE TRACEROUTE 
- Wanneer je graphviz installeert, kan je de functie graph() gebruiken voor de functie traceroute. Deze maakt van opgenomen data een grafiek. 
```python
#!/usr/bin/env python3 
print("##### "+__description__+"#####") 
from scapy.all import * 
res,unans =traceroute(["www.kdg.be"],dport=[80,443],maxttl=20,retry=-2) 
res.graph(target=__output__)
```

8. DHCP REQUEST 
- Gebruik de referenties om een script te schrijven dat op zoek gaat naar alle DHCP servers in het netwerk door een DHCP request te sturen en te kijken wie daar op antwoordt.
- Je kan dit ook testen door een DHCP request te sturen op je Host Only interface. Hierop moet dan 
wel een actieve DHCP server staan.

9. SCANS 
- XMAS SCAN 
    - Schrijf in python v3 een XMAS scan. Bekijk de scan met wireshark. 
    - Zorg ervoor dat je juist dezelfde output krijgt als bij een nmap XMAS scan. -Datum/tijd -Elapsed time -MAC Address 
- SYN SCAN 
    - Schrijf in python v3 een SYN scan. Bekijk de scan met wireshark. 
    - Zorg ervoor dat je juist dezelfde output krijgt als bij een nmap SYN scan.

10. SCHRIJVEN VAN PCAP 
- Schrijf een scapy script dat in python3: - het eerste argument gebruikt als filename voor de log - 10 pakketten snift - deze wegschrijft naar een pcap log - deze log opent in wireshar

## ✨Exercises

### 👉Exercise 0: Install necessary software packages

- Install the necessary software packages
```bash
sudo apt-get update -y && sudo apt-get upgrade -y
sudo apt-get install python3-venv tcpdump python3-scapy python3-cryptography ipython3 python3 graphviz imagemagick -y
```

- Create a virtual environment and install the necessary packages
```bash
python3 -m venv ~/demo_scapy
source ~/demo_scapy/bin/activate
pip3 install pycryptodome scapy
```

- If you want to leave the virtual environment, you can use the following command
```bash
deactivate
```

### 👉Exercise 1: Sniffing

- Open an editor and write the script [01_sniff.py](/Scripts/01_sniff.py)
```bash
sudo nano 01_sniff.py
```
- Copy the following code into the file:
```python
#!/usr/bin/env python3
############################
# @author Elias De Hondt   #
# @see https://eliasdh.com #
# @since 09/10/2024        #
############################
from scapy.all import sniff

__description__ = "Scapy Sniffing Script"
about = "##### " + __description__ + " #####"
print(about)

# Sniff 10 packets
packets = sniff(count=10)
packets.summary()
```
- Make the file executable and run it as root user:
```bash
sudo chmod +x 01_sniff.py
sudo ./01_sniff.py
```
- If there is network communication, you will see a summary of the next 10 packets that arrive or leave.
- Ideally, your script checks whether it is started as a root user.
- You can also catch errors with a try/except structure. Try running script [01b_sniff.py](/Scripts/01b_sniff.py):
```bash
sudo nano 01b_sniff.py
```
- Copy the following code into the file:
```python
#!/usr/bin/env python3
############################
# @author Elias De Hondt   #
# @see https://eliasdh.com #
# @since 09/10/2024        #
############################
from scapy.all import sniff
from os import getuid

if getuid() != 0:
    print("Warning: Starting as non root user!")

try:
    packets = sniff(count=10)
    packets.summary()
except:
    print("Error: Unable to sniff packets, try using sudo.")
    exit(1)
```
- Make the file executable and run it as root user:
```bash
sudo chmod +x 01b_sniff.py
sudo ./01b_sniff.py
```

### 👉Exercise 2: Sending packets

- You can send packets with the functions `send()` and `sendp()`. Send sends packets at layer 3,
- Sendp sends packets at layer 2. Write the program [02_send.py](/Scripts/02_send.py):
```bash
sudo nano 02_send.py
```
- Copy the following code into the file:
```python
#!/usr/bin/env python3
############################
# @author Elias De Hondt   #
# @see https://eliasdh.com #
# @since 09/10/2024        #
############################
from scapy.all import send, sendp, IP, ICMP, Ether

# Send an ICMP packet at layer 4
send(IP(dst="127.0.0.1")/ICMP())

# Send 4 packets at layer 3 and layer 2
sendp(Ether()/IP(dst="127.0.0.1", ttl=(1, 4)))
```
- Make the file executable and run it as root user:
```bash
sudo chmod +x 02_send.py
sudo ./02_send.py
```
- The program sends an ICMP packet at layer 4 (ICMP).
- Then the program sends 4 packets at layer 3 (IP) and layer 2 (Ether).
- You will only see that 1 and then 4 packets are sent.

### 👉Exercise 3: Sending and receiving

- Now we are going to make an ICMP imperf Request to another machine. In the same network.
- Write the script [03_sendreceive.py](/Scripts/03_sendreceive.py):
```bash
sudo nano 03_sendreceive.py
```
- Copy the following code into the file:
```python
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
```
- Make the file executable and run it as root user:
```bash
sudo chmod +x 03_sendreceive.py
sudo ./03_sendreceive.py
```

### 👉Exercise 4: Script with arguments

- It is more convenient if you can pass the IP address as an argument to your script. Write [04_sr_arg.py](/Scripts/04_sr_arg.py) with the following content:
```bash
sudo nano 04_sr_arg.py
```
- Copy the following code into the file:
```python
#!/usr/bin/env python3
############################
# @author Elias De Hondt   #
# @see https://eliasdh.com #
# @since 09/10/2024        #
############################
import sys
from scapy.all import sr1, IP, ICMP

# Send an ICMP packet to the destination IP address
p = sr1(IP(dst=sys.argv[1])/ICMP(), timeout=1)
if p:
    p.show()
```
- Make the file executable and run it as root user:
```bash
sudo chmod +x 04_sr_arg.py
sudo ./04_sr_arg.py 192.168.1.99
```

### 👉Exercise 5: ARP packet

- You sniff 1 ARP packet with the function `sniff()`. To get only an ARP packet, use the option `filter=arp`. Furthermore, use the option `prn=analyze`. The option `prn` starts a function every time it finds a packet that matches.
- Write the script [05_sniff_arp.py](/Scripts/05_sniff_arp.py):
```bash
sudo nano 05_sniff_arp.py
```
- Copy the following code into the file:
```python
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
```
- Make the file executable and run it as root user:
```bash
sudo chmod +x 05_sniff_arp.py
sudo ./05_sniff_arp.py
```
- Now start a ping from a machine in the same range. This will cause the machine to send an ARP packet to ask for the hardware address (MAC) of the IP address.
```bash
# Choose an IP address that the computer does not know yet. For example, you can choose an IP address that's not in use, then you're sure. The ping request will not work, but the scanning tool will detect this ARP request.
ping -c 1 X.X.X.X
```
> **Note:** If you want to filter the output even more, for example, only the fields `psrc` and `pdst` of the ARP packet, you can do this with the `sprintf` function (family of `sprintf` in the C language).
```python
print(p.sprintf("ARP SRC address %ARP.psrc% DST address %ARP.pdst%"))
```

### 👉Exercise 6: Ping range

- Example with an argument. We send an ICMP packet (default "echo") and only look at who responds to the ping with an echo-reply. The output format is in HTML format and the script is [06_ping_range.py](/Scripts/06_ping_range.py):
```bash
sudo nano 06_ping_range.py
```
- Copy the following code into the file:
```python
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
```
- Make the file executable and run it as root user:
```bash
sudo chmod +x 06_ping_range.py
sudo ./06_ping_range.py 192.168.1.1-200
```

### 👉Exercise 7: Graphical traceroute

- When you install graphviz, you can use the `graph()` function for the `traceroute()` function. This creates a graph from the recorded data.
- Write the script [07_graphical_traceroute.py](/Scripts/07_graphical_traceroute.py):
```bash
sudo nano 07_graphical_traceroute.py
```
- Copy the following code into the file:
```python
#!/usr/bin/env python3
############################
# @author Elias De Hondt   #
# @see https://eliasdh.com #
# @since 09/10/2024        #
############################
from scapy.all import traceroute

__description__ = "Graphical Traceroute Script"
__output__ = "traceroute_graph.svg"  # The output file for the graph

print("##### " + __description__ + " #####") # Print the description
res, unans = traceroute(["www.kdg.be"], dport=[80, 443], maxttl=20, retry=-2) # Perform a traceroute to the specified website (e.g., kdg.be)
res.graph(target=__output__) # Generate a graphical output of the traceroute result
print(f"Graphical traceroute saved as {__output__}")
```
- Make the file executable and run it as root user:
```bash
sudo chmod +x 07_graphical_traceroute.py
sudo ./07_graphical_traceroute.py
```

### 👉Exercise 8: DHCP request

- Write the script [08_dhcp_request.py](/Scripts/08_dhcp_request.py) that sends a DHCP request to find all DHCP servers in the network by looking at who responds.
- You can also test this by sending a DHCP request to your Host Only interface. There must be an active DHCP server on this interface.
```bash
sudo nano 08_dhcp_request.py
```
- Copy the following code into the file:
```python
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
```
- Make the file executable and run it as root user:
```bash
sudo chmod +x 08_dhcp_request.py
sudo ./08_dhcp_request.py
```

### 👉Exercise 9: Scans

- This script will perform an XMAS scan [09_xmas_scan.py](/Scripts/scan/xmas_scan.py):
```bash
sudo nano xmas_scan.py
```
- Copy the following code into the file:
```python
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
```
- Make the file executable and run it as root user:
```bash
sudo chmod +x xmas_scan.py
sudo ./xmas_scan.py
```

- This script will perform a SYN scan [syn_scan.py](/Scripts/scan/syn_scan.py):
```bash
sudo nano syn_scan.py
```
- Copy the following code into the file:
```python
#!/usr/bin/env python3
############################
# @author Elias De Hondt   #
# @see https://eliasdh.com #
# @since 09/10/2024        #
############################
from scapy.all import IP, TCP, sr
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
```
- Make the file executable and run it as root user:
```bash
sudo chmod +x syn_scan.py
sudo ./syn_scan.py
```

### 👉Exercise 10: Writing PCAP

- This script will write a PCAP file [10_write_pcap.py](/Scripts/10_write_pcap.py):
```bash
sudo nano 10_write_pcap.py
```
- Copy the following code into the file:
```python
#!/usr/bin/env python3
############################
# @author Elias De Hondt   #
# @see https://eliasdh.com #
# @since 09/10/2024        #
############################
import sys
from scapy.all import sniff, wrpcap
import sys

def write_pcap(filename):
    packets = sniff(count=10)
    wrpcap(filename, packets)

if len(sys.argv) != 2:
    print("Usage: " + sys.argv[0] + " <filename>")
    sys.exit(1)

write_pcap(sys.argv[1])
```
- Make the file executable and run it as root user:
```bash
sudo chmod +x 10_write_pcap.py
sudo ./10_write_pcap.py demo.pcap
```

## 📦Extra

- [XMAS Scan](/Scripts/Scan/xmas_scan.py): 
- [SYN Scan](/Scripts/Scan/syn_scan.py):
- [ACK Scan](/Scripts/Scan/ack_scan.py):
- [FIN Scan](/Scripts/Scan/fin_scan.py):
- [NULL Scan](/Scripts/Scan/null_scan.py):
- [UDP Scan](/Scripts/Scan/udp_scan.py):


- Download all scripts:
```bash
mkdir Scripts && cd Scripts
curl -O https://raw.githubusercontent.com/EliasDeHondt/ComputerSystems3-ISB/refs/heads/main/Scripts/01_sniff.py
curl -O https://raw.githubusercontent.com/EliasDeHondt/ComputerSystems3-ISB/refs/heads/main/Scripts/01b_sniff.py
curl -O https://raw.githubusercontent.com/EliasDeHondt/ComputerSystems3-ISB/refs/heads/main/Scripts/02_send.py
curl -O https://raw.githubusercontent.com/EliasDeHondt/ComputerSystems3-ISB/refs/heads/main/Scripts/03_sendreceive.py
curl -O https://raw.githubusercontent.com/EliasDeHondt/ComputerSystems3-ISB/refs/heads/main/Scripts/04_sr_arg.py
curl -O https://raw.githubusercontent.com/EliasDeHondt/ComputerSystems3-ISB/refs/heads/main/Scripts/05_sniff_arp.py
curl -O https://raw.githubusercontent.com/EliasDeHondt/ComputerSystems3-ISB/refs/heads/main/Scripts/06_ping_range.py
curl -O https://raw.githubusercontent.com/EliasDeHondt/ComputerSystems3-ISB/refs/heads/main/Scripts/07_graphical_traceroute.py
curl -O https://raw.githubusercontent.com/EliasDeHondt/ComputerSystems3-ISB/refs/heads/main/Scripts/08_dhcp_request.py
curl -O https://raw.githubusercontent.com/EliasDeHondt/ComputerSystems3-ISB/refs/heads/main/Scripts/10_write_pcap.py

curl -O https://raw.githubusercontent.com/EliasDeHondt/ComputerSystems3-ISB/refs/heads/main/Scripts/Scan/xmas_scan.py
curl -O https://raw.githubusercontent.com/EliasDeHondt/ComputerSystems3-ISB/refs/heads/main/Scripts/Scan/syn_scan.py
curl -O https://raw.githubusercontent.com/EliasDeHondt/ComputerSystems3-ISB/refs/heads/main/Scripts/Scan/ack_scan.py
curl -O https://raw.githubusercontent.com/EliasDeHondt/ComputerSystems3-ISB/refs/heads/main/Scripts/Scan/fin_scan.py
curl -O https://raw.githubusercontent.com/EliasDeHondt/ComputerSystems3-ISB/refs/heads/main/Scripts/Scan/null_scan.py
curl -O https://raw.githubusercontent.com/EliasDeHondt/ComputerSystems3-ISB/refs/heads/main/Scripts/Scan/udp_scan.py
```

- Make all scripts executable:
```bash
chmod +x 01_sniff.py 01b_sniff.py 02_send.py 03_sendreceive.py 04_sr_arg.py 05_sniff_arp.py 06_ping_range.py 07_graphical_traceroute.py 08_dhcp_request.py 10_write_pcap.py xmas_scan.py syn_scan.py ack_scan.py fin_scan.py null_scan.py udp_scan.py
```

## 🔗Links
- 👯 Web hosting company [EliasDH.com](https://eliasdh.com).
- 📫 How to reach us elias.dehondt@outlook.com