![logo](https://eliasdh.com/assets/media/images/logo-github.png)
# 💙🤍Firewalls Iptables🤍💙

## 📘Table of Contents

1. [📘Table of Contents](#📘table-of-contents)
2. [📝Assignment](#📝assignment)
3. [✨Exercises](#✨exercises)

4. [🔗Links](#🔗links)

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

- Ping from machine A to machine B.
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


## 🔗Links
- 👯 Web hosting company [EliasDH.com](https://eliasdh.com).
- 📫 How to reach us elias.dehondt@outlook.com