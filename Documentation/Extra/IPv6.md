![logo](https://eliasdh.com/assets/media/images/logo-github.png)
# 💙🤍IPv6🤍💙

## 📘Table of Contents

1. [📘Table of Contents](#📘table-of-contents)
2. [📝Assignment](#📝assignment)
3. [✨Exercises](#✨exercises)
    1. [👉Exercise 0: Preparations](#👉exercise-0-preparations)
    2. [👉Exercise 1: Start config interface](#👉exercise-1-start-config-interface)
    3. [👉Exercise 2: Apache configuration](#👉exercise-2-apache-configuration)


5. [🔗Links](#🔗links)

---

### 📝Assignment 
> NOTE This is in Dutch

- **DOEL:** Configuratie servers en routers met IPv6
- **NODIG:** Vyos (NAT, Host Only) Linux client (Ubuntu) (NAT, Host-Only) een film bv http://download.opencontent.netflix.com.s3.amazonaws.com/CosmosLaundromat/CosmosLaundromat_2k24p_HDR_P3PQ.mp4

- [REF A](https://wiki.vyos.net/wiki/IPv6_Router_Advertisements)
- [REF B](https://tools.ietf.org/html/rfc4861#section-4.2)
- [REF C](http://wiki.videolan.org/Documentation:Streaming_HowTo/Streaming_over_IPv6)


1. Start als root `tcpdump` op je loopback interface installeer een `openssh server` op linux:
    - Test de verbinding uit naar je ssh server op `127.0.0.1` (IPv4)
    - Maak een verbinding naar je ssh server op `::1`.

2. Pas je `apache` configuratie aan zodat deze ENKEL werkt met ipv6.
    - Hoe geraak je in je browser aan een ipv6 website?

3. Firewall regels
    - Bekijk je IPv6 adres in Linux met het commando ip Zorg dat je enkel de v6 adressen krijgt
    - Geef linux met het commando ip, het adres `2001::1` Geef je host op de juiste interface het adres `2001::2`
    - Ping vanuit linux naar je host IPv6 `2001::2`.
    - Bekijk de default IPv6 firewall regels in Ubuntu.
    - Voeg een regel toe met ip6tables om deze ping (en énkel deze ping) te verbieden.

4. Vyos
    - Stel Vyos in zodat deze via Router Advertisements IPv6 adressen uitdeelt.
    - Opgelet NIET als DHCPv6 server! Laat deze adressen uitdelen in het IPv6 subnet van `student.kdg.be` (`2001:06A8:0540:0101::/64`)
    - Geef de Host-Only netwerkkaart ook een adres in die range.
    - Zorg dat je alle parameters instelt bij de router-advert.
    - Stel de valid-lifetime in op `2592000` en de preferred-lifetime op `2073600`.

5. Voorzie een Linux client (NAT, Host-Only)
    - Zorg er via de commandline voor dat de Linux client een IPv6 adres krijgt van de VyOS Router.
    - Noteer de commando's die je nodig hebt:
    - Om een een ip versie 6 te bekijken:
    - Om via dhcpv6 (of Router Advertisements) een adres te bekomen:
    - Om de ip versie 6 route te bekijken:
    - Om een ip versie 6 ping uit te voeren:

6. Configureer VLC als streaming server
    - Laat vlc (sudo apt-get install vlc) een film over http streamen (IPv6)
    - Gebruik nmap om na te kijken of de IPv6 poort open staat (zoek op met man nmap)
    - Gebruik op dezelfde machine als client smplayer. (sudo apt-get install smplayer) Deze moet de IPv6 stream kunnen bekijken.
    - Gebruik tcpdump of wireshark om te verifiëren dat smplayer IPv6 gebruikt.

7. Multicast?
    - Kijk na of je ook vlc in IPv6 kan laten multicasten (bv via `FF15::1`).

## ✨Exercises

### 👉Exercise 0: Preparations

- Install the necessary software on both machines.
```bash
sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install tcpdump wireshark vlc nmap openssh-server smplayer apache2 -y
```

## 👉Exercise 1: Start config interface

- Start as root `tcpdump` on your loopback interface:
```bash
sudo tcpdump -i lo
```

- Test the connection to your ssh server:
```bash
ssh root@127.0.0.1
ssh root@::1
```

## 👉Exercise 2: Apache configuration

- Show your IPv6 address on interface `ens33`:
```bash
ip -6 addr show dev ens33 | grep -Po 'inet6 \K[\da-f:]+'
```

- Modify your apache configuration to only work with IPv6.
```bash
sudo rm /etc/apache2/sites-available/000-default.conf
sudo curl -s https://raw.githubusercontent.com/EliasDeHondt/ComputerSystems3-ISB/main/html/index.html -o /var/www/index.html
sudo curl -s https://raw.githubusercontent.com/EliasDeHondt/ComputerSystems3-ISB/main/source/ipv6-apache2.conf -o /etc/apache2/sites-available/ipv6-apache2.conf
sudo a2ensite ipv6-apache2.conf
sudo systemctl restart apache2
```










## 🔗Links
- 👯 Web hosting company [EliasDH.com](https://eliasdh.com).
- 📫 How to reach us elias.dehondt@outlook.com