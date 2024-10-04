![logo](https://eliasdh.com/assets/media/images/logo-github.png)
# 💙🤍W3P1 Portscan🤍💙

## 📘Table of Contents

1. [📘Table of Contents](#📘table-of-contents)
2. [📝Assignment](#📝assignment)
3. [✨Exercises](#✨exercises)
    1. [👉Question 1](#👉question-1)
    2. [👉Question 2](#👉question-2)
    3. [👉Question 3](#👉question-3)
    4. [👉Question 4](#👉question-4)
    5. [👉Question 5](#👉question-5)
    6. [👉Question 6](#👉question-6)
    7. [👉Question 7](#👉question-7)
    8. [👉Question 8](#👉question-8)
    9. [👉Question 9](#👉question-9)
4. [🔗Links](#🔗links)

---

### 📝Assignment 
> NOTE This is in Dutch

1. Hoe werd het binaire logbestand [Portscan-2021.pcap](/source/Portscan-2021.pcap) aangemaakt?

2. Wat is het IP adres van de aanvaller? (De persoon die SYN packets stuurt naar de target)

3. Wat is het IP adres van de target? (De persoon die SYN+ACK packets stuurt naar de aanvaller)

4. Welke poorten staan open op de target? (Externe poorten)

5. De target werd op minstens 4 manieren gescand. Geef de 4 methodes en leg uit hoe ze werken.

6. Welke scantool werd gebruikt om de target te scannen? Hoe weet je dit?

7. Welke commando's heeft de aanvaller gebruikt? (geef deze zo volledig mogelijk met alle parameters)

8. Welk besturingssysteem draait de aanvaller?

9. Stel snort in (zorg dat portscans gedetecteerd worden) en laat snort de portscan analyseren. Welke aanval(len) zie je in de logs?

## ✨Questions

### 👉Question 1

- Install tshark with the following command:
```bash
sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install tshark -y # In the UI press YES
sudo apt-get install snort -y # In the UI select the network interface
sudo apt install p0f -y
```

The binary log file [Portscan-2021.pcap](/source/Portscan-2021.pcap) was created using the following command:

```bash
sudo tcpdump -i ens18 -w Portscan-2021.pcap # ens18 is the network interface (So not the same for your machine)
```

### 👉Question 2

- With this command you can analyze the log file.
```bash
tshark -r Portscan-2021.pcap -Y "tcp.flags.syn == 1 && tcp.flags.ack == 1" -T fields -e ip.src | sort | uniq -c | sort -nr | head -n 1 | awk '{print $2}'
```

### 👉Question 3

- With this command you can analyze the log file.
```bash
tshark -r Portscan-2021.pcap -Y "tcp.flags.syn == 1 && tcp.flags.ack == 1" -T fields -e ip.dst | sort | uniq -c | sort -nr | head -n 1 | awk '{print $2}'
```

### 👉Question 4

- With this command you can analyze the log file.
```bash
tshark -r Portscan-2021.pcap -Y "tcp.flags.syn == 1 && tcp.flags.ack == 1" -T fields -e tcp.srcport | sort | uniq -c | sort -nr | awk '{print $2}'
```

### 👉Question 5

- Method 1: Port sweep (ACK scan)
    - A port sweep is a scan that scans all ports on a target.

        ![Image](/Images/W3P1-Portscan-1.png)
- Method 2: Stealth scan
    - If the target responds with a SYN/ACK packet, the port is open. If the target responds with a RST packet, the port is closed.

        ![Image](/Images/W3P1-Portscan-2.png)
- Method 3: XMAS scan
    - A XMAS scan is a scan that sends a packet with the FIN, URG, and PSH flags set to 1. If the target responds with a RST packet, the port is closed. If the target does not respond, the port is open.

        ![Image](/Images/W3P1-Portscan-3.png)
- Method 4: FIN scans
    - A FIN scan is a scan that sends a packet with the FIN flag set to 1. If the target responds with a RST packet, the port is closed. If the target does not respond, the port is open.

        ![Image](/Images/W3P1-Portscan-4.png)

### 👉Question 6

- ???

### 👉Question 7

- ???

### 👉Question 8

- With this command you can analyze the log file (p0f).
```bash
# Get the IP address of the attacker
ip=$(tshark -r Portscan-2021.pcap -Y "tcp.flags.syn == 1 && tcp.flags.ack == 1" -T fields -e ip.src | sort | uniq -c | sort -nr | head -n 1 | awk '{print $2}')

# Get the OS of the attacker
p0f -r Portscan-2021.pcap | awk -v ip="$ip" '$0 ~ ip { getline; print $0 } $0 ~ /os/ { print $0 }' | awk '{print $4}' | grep -i "Windows" && echo "Windows" || echo "Linux"
```

### 👉Question 9

- The following command is needed to analyze the log file.
```bash
#  Stel snort in (zorg dat portscans gedetecteerd worden) en laat snort de portscan analyseren. Welke aanval(len) zie je in de logs?
sudo snort -A console -q -c /etc/snort/snort.conf -r Portscan-2021.pcap
```

## 🔗Links
- 👯 Web hosting company [EliasDH.com](https://eliasdh.com).
- 📫 How to reach us elias.dehondt@outlook.com