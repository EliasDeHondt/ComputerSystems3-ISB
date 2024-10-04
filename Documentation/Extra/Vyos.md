![logo](https://eliasdh.com/assets/media/images/logo-github.png)
# 💙🤍Vyos🤍💙

## 📘Table of Contents

1. [📘Table of Contents](#📘table-of-contents)
2. [📝Assignment](#📝assignment)

5. [🔗Links](#🔗links)

---

### 📝Assignment 
> NOTE This is in Dutch

2. Installeer VyOS
3. Installeer Ubuntu met apache2 en openssh  (of Slitaz)
4. Test rechtstreeks de verbinding uit naar de webserver van ubuntu of slitaz `http://192.168.57.101`
5. Configureer VyOS zodat deze doorstuurt(routeert) naar ubuntu of slitaz `http://192.168.200.102`
6. Configuratie VyOS firewall:
    - Vyos laat enkel verkeer toe naar poort 80 en 22 van ubuntu/slitaz
    - Voorzie voor terugkerend verkeer enkel related en established verkeer
    - Zorg dat ubuntu/slitaz kan pingen naar je HOST maar NIET andersom

- De webserver en openssh-server op ubuntu staat standaard aan
- De webserver op slitaz staat standaard aan. De ssh server heet dropbear.
- `load ftp://config:vyossecret@192.168.56.1/config.vyos`

## ✨Steps

### 👉Step 1: Configure the network of the server

- Disable IPv6 in 1 command
```bash
sudo sysctl -w net.ipv6.conf.all.disable_ipv6=1
```

- Add ip address to the interfaces `ens33` of the ubuntu server
```bash
sudo ip addr add 192.168.200.102/24 dev ens33
```

- Add the default gateway to the ubuntu server
```bash
sudo ip route add default via 192.168.200.101 dev ens33
```

- Disable the firewall
```bash
sudo ufw disable
```

- Install apache2 && openssh-server
```bash
sudo apt update && sudo apt upgrade -y
sudo apt install apache2 openssh-server -y
```

### 👉Step 2: Configure the network of the VyOS

- Copy the configuration file to the VyOS
```bash
# 0. Enter the configuration mode
configure
# 1. Set the hostname
set system host-name VyOS1
# 2. Show the interfaces
show interfaces
# 3. Set the interfaces
set interfaces ethernet eth0 address 192.168.200.101/24
set interfaces ethernet eth1 address 192.168.56.101/24
# 4. Commit the changes
commit
# 5. Save the changes
save
```

### 👉Step 3: SSH

- Copy the configuration file to the VyOS
```bash
# 0. Enter the configuration mode
configure
# 1. Set the port of the ssh service to 22
set service ssh port 22
# 2. Commit the changes
commit
# 3. Save the changes
save
```

### 👉Step 4: Configure the firewall of the VyOS

- Copy the configuration file to the VyOS
```bash
# 0. Enter the configuration mode
configure
# 1. 
set firewall name OUTSIDE-IN rule 10 action 'accept'
set firewall name OUTSIDE-IN rule 10 destination port '80'
set firewall name OUTSIDE-IN rule 10 protocol 'tcp'
set firewall name OUTSIDE-IN rule 20 action 'accept'
set firewall name OUTSIDE-IN rule 20 destination port '22'
set firewall name OUTSIDE-IN rule 20 protocol 'tcp'
# 2. 
set firewall name OUTSIDE-IN rule 30 action 'accept'
set firewall name OUTSIDE-IN rule 30 state established 'enable'
set firewall name OUTSIDE-IN rule 30 state related 'enable'
# 3. 
set firewall name OUTSIDE-IN rule 40 action 'accept'
set firewall name OUTSIDE-IN rule 40 protocol 'icmp'
set firewall name OUTSIDE-IN rule 40 state new 'enable'
# 4. Commit the changes
commit
# 5. Save the changes
save
```

## 🔗Links
- 👯 Web hosting company [EliasDH.com](https://eliasdh.com).
- 📫 How to reach us elias.dehondt@outlook.com