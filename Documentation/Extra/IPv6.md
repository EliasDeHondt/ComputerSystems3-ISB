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
    - Geef linux met het commando ip, het adres `2001::1`.
    - Geef je host op de juiste interface het adres `2001::2`
    - Ping vanuit linux naar je host IPv6 `2001::2`.
    - Bekijk de default IPv6 firewall regels in Ubuntu.
    - Voeg een regel toe met ip6tables om deze ping (en énkel deze ping) te verbieden.

4. Configureer VLC als streaming server
    - Laat vlc een film over http streamen (IPv6)
    - Gebruik nmap om na te kijken of de IPv6 poort open staat
    - Gebruik op dezelfde machine als client smplayer. Deze moet de IPv6 stream kunnen bekijken.
    - Gebruik tcpdump of wireshark om te verifiëren dat smplayer IPv6 gebruikt.

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

- Modify your apache configuration to only work with IPv6.
```bash
sudo systemctl stop apache2
sudo rm /etc/apache2/sites-available/000-default.conf
sudo rm /etc/apache2/sites-available/default-ssl.conf
sudo curl -s https://raw.githubusercontent.com/EliasDeHondt/ComputerSystems3-ISB/main/html/index.html -o /var/www/html/index.html
sudo curl -s https://raw.githubusercontent.com/EliasDeHondt/ComputerSystems3-ISB/main/source/ipv6-apache2.conf -o /etc/apache2/sites-available/ipv6-apache2.conf
sudo a2ensite ipv6-apache2.conf
sudo systemctl start apache2
```

- Open your new website:
```bash
curl -6 http://[::1] # Works
curl -6 http://127.0.0.1 # Doesn't work
```

## 👉Exercise 3: Firewall rules

- Show your IPv6 address on interface `ens33`:
```bash
ip -6 addr show dev ens33 | grep -Po 'inet6 \K[\da-f:]+'
```

- Set the address `2001::1` on interface `ens33` **Linux**:
```bash
sudo ip -6 addr add 2001::1/64 dev ens33
```

- Set the address `2001::2` on interface `VMnet8` **Windows**:
```powershell
netsh interface ipv6 add address "VMware Network Adapter VMnet8" 2001::2
```

- Ping from Linux to Windows:
```bash
ping6 2001::2
```

- Show the default IPv6 firewall rules in Ubuntu:
```bash
sudo ip6tables -L
```

- Add a rule with `ip6tables` to block the ping from `2001::2` (Windows) to `2001::1` (Linux):
```bash
sudo ip6tables -I INPUT -s 2001::2/64 -p icmpv6 -j DROP
# sudo ip6tables -D INPUT -s 2001::2/64 -p icmpv6 -j DROP
```

## 👉Exercise 4: Configure VLC as streaming server

- Download a movie:
```bash
sudo mkdir -p /etc/vlc
sudo curl -s https://raw.githubusercontent.com/EliasDeHondt/ComputerSystems3-ISB/main/videos/disney_bitconnect.mp4 -o /etc/vlc/disney_bitconnect.mp4
```

- Let VLC stream a movie over http (IPv6):
```bash
vlc /etc/vlc/disney_bitconnect.mp4 --sout '#http{mux=ts,dst=:1234}' --http-host=[2001::1]
```

- Check if the IPv6 port is open with `nmap`:
```bash
nmap -6 -p 1234 [2001::1]
```

- Use `smplayer` on the same machine as the client. It should be able to view the IPv6 stream.
```bash
smplayer http://[2001::1]:1234
```

- Use `tcpdump` or `wireshark` to verify that `smplayer` uses IPv6:
```bash
sudo tcpdump -i ens33 ip6
sudo wireshark
```

## 🔗Links
- 👯 Web hosting company [EliasDH.com](https://eliasdh.com).
- 📫 How to reach us elias.dehondt@outlook.com