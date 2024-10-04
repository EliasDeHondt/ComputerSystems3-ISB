![logo](https://eliasdh.com/assets/media/images/logo-github.png)
# 💙🤍Firewalls Iptables🤍💙

## 📘Table of Contents

1. [📘Table of Contents](#📘table-of-contents)
2. [📝Assignment](#📝assignment)
3. [✨Exercises](#✨exercises)
    1. [👉Exercise 0: Preparations](#👉exercise-0-preparations)
    2. [👉Exercise 1: Network preparations](#👉exercise-1-network-preparations)
    3. [👉Exercise 2: Network connection test](#👉exercise-2-network-connection-test)
    4. [👉Exercise 3: Iptables script](#👉exercise-3-iptables-script)
    5. [👉Exercise 4: Iptables command to empty chains](#👉exercise-4-iptables-command-to-empty-chains)
    6. [👉Exercise 5: Iptables command to set default policies](#👉exercise-5-iptables-command-to-set-default-policies)
    7. [👉Exercise 6: Log the UDP request for nslookup](#👉exercise-6-log-the-udp-request-for-nslookup)
    8. [👉Exercise 7: Block IPv6 ping](#👉exercise-7-block-ipv6-ping)
    9. [👉Exercise 8: Install nemesis](#👉exercise-8-install-nemesis)
    10. [👉Exercise 9: Limit the number of ICMP packets](#👉exercise-9-limit-the-number-of-icmp-packets)
    11. [👉Exercise 10: Loop script with nemesis-icmp](#👉exercise-10-loop-script-with-nemesis-icmp)
    12. [👉Exercise 11: DNS request with nemesis](#👉exercise-11-dns-request-with-nemesis)
    13. [👉Exercise 12: Iptables rules for UDP](#👉exercise-12-iptables-rules-for-udp)
    14. [👉Exercise 13: Show the iptables rules](#👉exercise-13-show-the-iptables-rules)
    15. [👉Exercise 14: Strict ACL on Linux](#👉exercise-14-strict-acl-on-linux)
    16. [👉Exercise 15: Apache webserver on port 8080](#👉exercise-15-apache-webserver-on-port-8080)
    17. [👉Exercise 16: FTP server](#👉exercise-16-ftp-server)
    18. [👉Exercise 17: SSH server](#👉exercise-17-ssh-server)
4. [📦Extra](#📦extra)
    1. [📦Extra (Useful firewall rules)](#📦extra-useful-firewall-rules)
    2. [📦Extra (Random)](#📦extra-random)
5. [🔗Links](#🔗links)

---

### 📝Assignment 
> NOTE This is in Dutch

1. 2 Linuxen (mag live),
    - Je kan via het Clone commando eenvoudig een virtuele machine clonen
    - apache2, openssh-server, vsftpd, filezilla, putty, lynx
    - Voor de oefening is het handig om binnen de virtuele machines 8.8.8.8 als DNS server in te stellen.

1. Zorg bij beide virtuele machines minstens voor een netwerkkaart van het type `Host Only` en vboxnet0 (daarbuiten mag je ook nog een `NAT` netwerkkaart hebben, zodat je bijvoorbeeld nog op internet kan. Stel bij de Advanced settings de netwerkkaart in met Promiscuous op Allow All, zodat je kan sniffen. 

2. Netwerkverbinding testen:
    - Ping van de machine A naar `machine B`.
        - Om te kijken of het sniffen werkt start je op `machine B` het programma tcpdump.
        - Stel nu je ping in zodat je 100 pings per seconde doet. Met welk commando kan dit?

    - Doe een nslookup van bv `www.kdg.be`
        - Je moet een antwoord van een DNS server krijgen met het IP adres van www.kdg.be
        - Iptables zit in de kernel gecompileerd. Standaard komt de iptables log dus terecht in de systeemlog `/var/log/syslog` en/of in de kernel log `/var/log/kern.log`

3. Maak het script iptables.sh aan. Hiermee kan je alle firewallregels met één script instellen.

- Start met dit script (dat moet je als root uitvoeren):
    ```bash
    iptables -F INPUT
    iptables -F OUTPUT
    iptables -Z
    iptables -P INPUT DROP
    iptables -P OUTPUT DROP
    iptables -A OUTPUT -p tcp --destination-port 80 -j ACCEPT
    iptables -A INPUT -p tcp --source-port 80 --dport 1025:65535 -j ACCEPT
    iptables -L -n -v
    ```

4. Welke iptables commando's aan het begin van het script maken alle chains leeg?

5. Welke iptables commando's aan het begin van je script stellen alle default policies in op DROP?

6. We gaan nu de UDP aanvraag voor de nslookup loggen met iptables. Zoek zelf op met welke iptables regel je dit kan doen. gebruik een eigen log-prefix `UDP IPTABLES`. Kijk na of je nslookup gelogd wordt.

7. Test op de Host Only interface een ip v6 ping uit tussen de machines (bv `ping -6 -I enp0s8 fe80`......)
    - Schrijf regels die wel een v6 ping blokkeren maar niet een v4 ping


8. Installeer het tooltje nemesis. Opgelet deze gebruikt ook het pakket libnet1 (zie referentie) Zoek op met welk commando je een DNS aanvraag kan doen. Doe opnieuw een DNS aanvraag. (man nemesis-dns geeft een manual page)


9. Maak een iptables regel waarmee je een limiet legt op het aantal icmp pakketten per seconde. Stel maximum 1 per seconde in met een burst van 5. Log dit met prefix `ICMP IPTABLES`. Test nu uit of je ping van 100 per seconde gedetecteerd wordt.

10. Schrijf een loopscriptje in shell dat met nemesis-icmp pings doet (deze pings wachten niet op een reply en zullen dus zo snel mogelijk uitgevoerd worden). 

11. Maak met nemesis nu een DNS request met als SRC en DST adres je eigen adres. Komt er iets speciaal in de log?


12. Schrijf iptables regels voor udp die enkel udp verkeer toelaat naar binnen, dat je zelf hebt aangevraagd. Bij uitbreiding zorg je er ook voor dat deze regel niet geldt voor een lokale interface.

13. Voer het commando `iptables -n -L INPUT` uit. Wat krijg je te zien?

14. Stel een zo strikt mogelijke ACL in op je Linux waarmee je zorgt dat je Linux kan pingen naar een andere computer, maar niemand naar je Linux.

15. Installeer en start de apache webserversudo apt-get install `apache2/etc/init.d/apache2` start(Kijk even na in een browser of er op jou IP adres een website draait) Zorg er nu, via iptables voor dat mensen die op poort 8080 verbinden ook de website te zien krijgen van poort `80`.

16. Installeer een ftp server (bv `vsftpd`) Installeer en start wireshark.
    - Test uit of je een passieve ftp sessie kan starten naar je server (als gui kan je filezilla installeren). Bekijk in wireshark de initiele handshake tussen de client en de `FTP server`. Noteer volgende informatie van alle pakketten en de `richting:SRC IP/SRC PORT/DST IP/DST PORT`
    - Test uit of je actieve ftp kan starten naar de serverBekijk in wireshark de initiele handshake tussen de client en de FTP server. Noteer volgende informatie van alle pakketten en de richting:SRC IP/SRC PORT/DST IP/DST PORT. Schrijf zo strikt mogelijke regels 

17. Installeer en start de ssh server openssh-server
    - Start de apache webserver op poort `8080` in plaats van de standaard poort `80`.
    - Test uit of je vanaf de client kan surfen naar `8080`.
    - Start de openssh server. Test uit of je met je client kan verbinden naar poort `22`.


## ✨Exercises

### 👉Exercise 0: Preparations

- Install the necessary software on both machines.
```bash
sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install apache2 openssh-server vsftpd filezilla putty lynx
```

- Set the DNS server to `8.8.8.8` on both machines.
```bash
sudo nano /etc/resolv.conf
# Add the following line
nameserver 8.8.8.8
```

### 👉Exercise 1: Network preparations

- In each machine there is one network card. Both machines are connected to the same network. 
    - `192.168.1.0/24` for example.

- Machine 1: `192.168.1.210`
- Machine 2: `192.168.1.209`

- Documentation toe kon figuren, Network Cards.
    - [Configuring Host-Only Networking for VirtualBox](https://www.virtualbox.org/manual/ch06.html#network_hostonly)
    - [Configuring Host-Only Networking for Hyper-V](https://docs.microsoft.com/en-us/virtualization/hyper-v-on-windows/user-guide/setup-nat-network)

### 👉Exercise 2: Network connection test

- Ping from machine 1 to machine 2.
    - Machine 1: `ping -i 0.01 192.168.1.209` 100 pings per second.
    - Machine 2: `sudo tcpdump` to sniff the traffic.
    - And analyze the traffic.

- Do an nslookup of `www.kdg.be`.
    - Machine 1: `nslookup www.kdg.be`
    - Check the logs in `/var/log/syslog` and `/var/log/kern.log`.
    ```bash
    cat /var/log/syslog | grep dns
    cat /var/log/kern.log | grep dns
    ```

![Image](/Images/Firewalls-Iptables-1.png)

### 👉Exercise 3: Iptables script

- Create the `iptables.sh` script.
```bash
echo -e '#!/bin/bash' > iptables.sh
echo -e 'iptables -F INPUT' >> iptables.sh
echo -e 'iptables -F OUTPUT' >> iptables.sh
echo -e 'iptables -Z' >> iptables.sh
echo -e 'iptables -P INPUT DROP' >> iptables.sh
echo -e 'iptables -P OUTPUT DROP' >> iptables.sh
echo -e 'iptables -A OUTPUT -p tcp --destination-port 80 -j ACCEPT' >> iptables.sh
echo -e 'iptables -A INPUT -p tcp --source-port 80 --dport 1025:65535 -j ACCEPT' >> iptables.sh
echo -e 'iptables -L -n -v' >> iptables.sh
cat iptables.sh # Check the content of the script
chmod +x iptables.sh # Make the script executable
sudo ./iptables.sh # Run the script
```
> **Note:** If you're using an SSH connection.Please note that your connection will be lost.


### 👉Exercise 4: Iptables command to empty chains

- The following iptables commands at the beginning of the script empty all chains.
```bash
# Flush the INPUT chain (deletes all rules)
iptables -F INPUT
# Flush the OUTPUT chain (deletes all rules)
iptables -F OUTPUT
# Zero the packet and byte counters in all chains (this is equivalent to `iptables -Z INPUT; iptables -Z OUTPUT; iptables -Z FORWARD`)
iptables -Z
```

### 👉Exercise 5: Iptables command to set default policies

- The following iptables commands at the beginning of the script set all default policies to `DROP`.
```bash
# Set the default policy for the INPUT chain to DROP
iptables -P INPUT DROP
# Set the default policy for the OUTPUT chain to DROP
iptables -P OUTPUT DROP
```

### 👉Exercise 6: Log the UDP request for nslookup

- Use the following iptables command to log the UDP request for nslookup.
```bash
sudo iptables -A INPUT -p udp --dport 53 -j LOG --log-prefix "UDP IPTABLES"
```

- Check if the nslookup is logged.
```bash
sudo dmesg | grep "UDP IPTABLES"
```

### 👉Exercise 7: Block IPv6 ping

- Enable IPv6 on Ubuntu.
```bash
sudo nano /etc/sysctl.conf
# Uncomment the following line
net.ipv6.conf.all.disable_ipv6 = 0

# Apply the changes
sudo sysctl -p
```

- Set on both machines IPv6 ip addresses.
```bash
# Machine 1
sudo ip -6 addr add fe80::1/64 dev ens18
# Machine 2
sudo ip -6 addr add fe80::2/64 dev ens18
```

- Write rules that block an IPv6 ping but not an IPv4 ping.
```bash
# Block IPv6 ping
sudo iptables -A INPUT -p icmpv6 --icmpv6-type echo-request -j DROP
```

### 👉Exercise 8: Install nemesis

- Install the nemesis tool.
```bash
wget https://github.com/libnet/nemesis/releases/download/v1.8/nemesis-1.8.tar.gz
tar -xvf nemesis-1.8.tar.gz
cd nemesis-1.8
sudo apt-get install libnet1 libnet1-dev -y
./configure
make
sudo make install
```

- Use the following command to make a DNS request.
```bash
sudo nemesis dns -v -q 1 -d ens18 -S 192.168.1.210 -D 8.8.8.8 -x 12345 -y 53
```

### 👉Exercise 9: Limit the number of ICMP packets

- Clear the logs.
```bash
sudo dmesg -C
```

- Write an iptables rule to limit the number of ICMP packets per second. `machine 1`
```bash
sudo iptables -A INPUT -p icmp --icmp-type echo-request -m limit --limit 1/s --limit-burst 5 -j ACCEPT
sudo iptables -A INPUT -p icmp --icmp-type echo-request -j LOG --log-prefix "ICMP IPTABLES: " --log-level 7
sudo iptables -A INPUT -p icmp --icmp-type echo-request -j DROP
```

- Test if the ping of 100 per second is detected. `machine 2`
```bash
ping -i 0.01 192.168.1.210
```

- Check the logs.
```bash
sudo dmesg | grep "ICMP IPTABLES"
```

### 👉Exercise 10: Loop script with nemesis-icmp

- Create a loop script in shell that uses nemesis-icmp to ping.
```bash
echo -e '#!/bin/bash' > loop.sh
echo -e 'for i in {1..100}; do' >> loop.sh
echo -e 'sudo nemesis icmp -v -S 192.168.1.210 -D "$1" -c 100;' >> loop.sh
echo -e 'done' >> loop.sh
cat loop.sh # Check the content of the script
chmod +x loop.sh # Make the script executable
sudo ./loop.sh 192.168.1.210 # Run the script
```

### 👉Exercise 11: DNS request with nemesis

- Make a DNS request with nemesis.
```bash
# SRC (Source Address)
# DST (Destination Address)
sudo nemesis dns -v -q 1 -d ens18 -S 192.168.1.210 -D 192.168.1.210 -x 12345 -y 53 -T 1 
```

- Check the logs.
```bash
sudo dmesg
```

### 👉Exercise 12: Iptables rules for UDP

- Write iptables rules for UDP that only allow UDP traffic to enter that you have requested yourself. Also, make sure this rule does not apply to a local interface.
```bash
# Drop all incoming UDP traffic
sudo iptables -P INPUT DROP

# Allow loopback traffic (necessary for local applications)
sudo iptables -A INPUT -i lo -j ACCEPT

# Allow all outgoing traffic
sudo iptables -A OUTPUT -j ACCEPT

# Allow incoming UDP traffic on port 12345
sudo iptables -A INPUT -p udp --dport 12345 -m state --state ESTABLISHED,RELATED -j ACCEPT
```

### 👉Exercise 13: Show the iptables rules

- Execute the following command:
```bash
sudo iptables -n -L INPUT # Show the iptables rules (for incoming traffic)
```

### 👉Exercise 14: Strict ACL on Linux

- Write a strict ACL on your Linux so that you can ping another computer, but no one can ping your Linux.
```bash
# Drop all incoming ICMP traffic
sudo iptables -P INPUT DROP

# Allow loopback traffic (necessary for local applications)
sudo iptables -A INPUT -i lo -p icmp -j ACCEPT

# Allow incoming ICMP traffic on the network interface
sudo iptables -A INPUT -i ens18 -p icmp --icmp-type echo-request -j ACCEPT

# Allow all outgoing ICMP traffic
sudo iptables -A OUTPUT -p icmp -j ACCEPT
```

### 👉Exercise 15: Apache webserver on port 8080

- Install and start the apache webserver and lynx.
```bash
sudo apt-get install apache2 lynx -y
sudo systemctl start apache2
```

- Check if the website is running on port 80. `machine 1`
```bash
lynx http://localhost
```

- Check if the website is running on port 80. `machine 2`
```bash
lynx http://192.168.1.210:80
```

- Use iptables to allow people who connect on port 8080 to see the website on port 80.
```bash
sudo iptables -A INPUT -p tcp --dport 8081 -j ACCEPT
sudo iptables -t nat -A PREROUTING -p tcp --dport 8081 -j REDIRECT --to-port 80
```

### 👉Exercise 16: FTP server

- Install and start the FTP server and Wireshark `machine 1`
```bash
sudo apt-get install vsftpd wireshark -y
sudo systemctl start vsftpd
```

- Test if you can start a passive FTP session to the server. `machine 2`
```bash
# Use FileZilla to connect to the FTP server
# Check the traffic in Wireshark between machine 1 and machine 2
```

- Create the necessary firewall rules to deny everything except the passive FTP connections for `machine 1`.
```bash
# Drop all incoming traffic
sudo iptables -P INPUT DROP

# Allow loopback traffic (necessary for local applications)
sudo iptables -A INPUT -i lo -j ACCEPT

# Allow all outgoing traffic
sudo iptables -A OUTPUT -j ACCEPT

# Allow incoming passive FTP traffic (Commands)
sudo iptables -A INPUT -p tcp --dport 21 -m state --state NEW,ESTABLISHED -j ACCEPT

# Allow incoming passive FTP traffic (Data)
sudo iptables -A INPUT -p tcp --dport 1024:65535 -m state --state ESTABLISHED -j ACCEPT
```

### 👉Exercise 17: SSH server

- Install and start the SSH server `machine 1`
```bash
sudo apt-get install openssh-server -y
sudo systemctl start ssh
```

- Delete all firewall rules.
```bash
sudo iptables -P
```

- Create firewall rules to accept 22 & 80 traffic.
```bash
# Allow all outgoing traffic
sudo iptables -A OUTPUT -j ACCEPT

# Allow incoming SSH traffic on port 22
sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT

# Allow incoming HTTP traffic on port 80
sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT

# Allow loopback traffic (necessary for local applications)
sudo iptables -A INPUT -i lo -j ACCEPT
```

## 📦Extra

### 📦Extra (Useful firewall rules)

- Block all incoming/outgoing ICMP traffic.
```bash
sudo iptables -A INPUT -p icmp -j DROP
sudo iptables -A OUTPUT -p icmp -j DROP
```

- Limit the number of ICMP packets to 1 per seconds and drop the rest.
```bash
# The limit-burst allows the first 5 packets to pass through and then the limit of 1 packets per second is applied.
sudo iptables -A INPUT -p icmp --icmp-type echo-request -m limit --limit 1/s --limit-burst 5 -j ACCEPT
sudo iptables -A INPUT -p icmp --icmp-type echo-request -j DROP
```

- Block all incoming/outgoing traffic except SSH traffic.
```bash
# Allow all outgoing traffic
sudo iptables -A OUTPUT -j ACCEPT

# Allow incoming SSH traffic on port 22, but limit to 2 simultaneous connections
sudo iptables -A INPUT -p tcp --dport 22 -m connlimit --connlimit-above 2 -j REJECT

# Allow incoming SSH traffic on port 22 (for up to 2 connections)
sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT

# Drop all other incoming traffic
sudo iptables -A INPUT -j DROP
```

### 📦Extra (Random)

- Switch the hostnames of the machines.
```bash
sudo nano /etc/hostname
sudo nano /etc/hosts
sudo reboot
```

- Reset the firewall rules.
```bash
sudo iptables -F INPUT      # Flush the INPUT chain
sudo iptables -F OUTPUT     # Flush the OUTPUT chain
sudo iptables -Z            # Zero the packet and byte counters
sudo iptables -P INPUT DROP # Set the default policy for the INPUT chain to DROP
sudo iptables -P OUTPUT DROP # Set the default policy for the OUTPUT chain to DROP
```

- Check the iptables rules.
```bash
sudo iptables -n -L INPUT
```

## 🔗Links
- 👯 Web hosting company [EliasDH.com](https://eliasdh.com).
- 📫 How to reach us elias.dehondt@outlook.com