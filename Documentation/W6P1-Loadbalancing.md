![logo](https://eliasdh.com/assets/media/images/logo-github.png)
# 💙🤍W6P1 Loadbalancing🤍💙

## 📘Table of Contents

1. [📘Table of Contents](#📘table-of-contents)
2. [📝Assignment](#📝assignment)
3. [✨Exercises](#✨exercises)
    1. [👉Exercise 0: Install necessary software packages](#👉exercise-0-install-necessary-software-packages)
    2. [👉Exercise 1: Set up basic configuration](#👉exercise-1-set-up-basic-configuration)

4. [🔗Links](#🔗links)

---

### 📝Assignment 
> NOTE This is in Dutch

- **DOEL:** Configureren en uittesten van een session-aware load-balancer.

- **NODIG:** 1 linux loadbalancer, 2 linux nodes

- Maak virtueel een kleine linux aan zonder grafische interface.
- Installeer een standaard apache2 server op de nodes.
- Voorzie een NAT en een Host-Only interface.
- Maak 2 linked Clones aan van de machine. Deze 2 clones worden de nodes. Zorg dat het Mac adres van de clone niet hetzelfde is als de originele machine.
- Pas de hostname aan in de machine. Dit doe je met volgende commando's: `hostnamectl set-hostname webserver1`.
- Pas ook in het bestand `/etc/hosts` de vorige naam aan naar de nieuwe naam.
- Log even uit en log terug in.
- Bekijk de ip adressen van je loadbalancer en je node.
- Kijk na of je kan pingen tussen de 3 machines.

1. APACHE MOD PROXY BALANCER
    - Installeer de apache module mod-proxy-html
    - Activeer de apache modules proxy proxy_http headers proxy_balancer
    - Voeg volgende configuratie toe aan je apache server:
    ```apache
    # In dit voorbeeld is de loadbalancer: 192.168.56.101
    # webserver1: 192.168.56.102 en webserver2 192.168.56.103
    # Dit maakt op de loadbalancer een cookie aan, die elke connectie (sessie) onthoudt,
    # waardoor latere requests, terug kunnen doorgestuurd worden naar dezelfde machine
    Header add Set-Cookie "BALANCEID=hej.%{BALANCER_WORKER_ROUTE}e; path=/;"
    env=BALANCER_ROUTE_CHANGED

    # Hiermee krijg je een webinterface voor je load balancer
    <Location /balancer-manager>
        SetHandler balancer-manager
        Order allow,deny
        Allow from all
    </Location>
    ProxyRequests Off

    # Configure members for cluster
    <Proxy balancer://192.168.56.101>
        BalancerMember http://192.168.56.102:80 route=server1
        BalancerMember http://192.168.56.103:80 route=server2
    </Proxy>

    #Do not proxy balancer-manager
    ProxyPass /balancer-manager !
    # The actual ProxyPass
    ProxyPass / balancer://192.168.56.101/ stickysession=BALANCEID nofailover=Off
    # Do not forget ProxyPassReverse for redirects
    ProxyPassReverse / http://192.168.56.102/
    ProxyPassReverse / http://192.168.56.103/
    ```


2. TESTSCRIPT WEBSERVER
    - Schrijf een script dat om de 2 seconden de inhoud van een website opvraagt en dit toont op het scherm.
    - Wanneer `index.html` op node 1 `Webserver 1` en op node 2 `Webserver 2` bevat, toont het script:
    - `Webserver 1`
    - `Webserver 2`
    - Ga er van uit dat er html code (en niet enkel tekst) staat in het bestand index.html.
    - Bij falen toont het script volgende foutboodschap:
        "Verbinding mislukt"
    - Test het script uit op je APACHE PROXY BALANCER, tijdens het afwisselend uitschakelen van `webserver1` en `webserver2`.

## ✨Exercises

### 👉Exercise 0: Install necessary software packages

- Install the necessary software packages
```bash
sudo apt-get update -y && sudo apt-get upgrade -y # On both
sudo apt-get install apache2 nano iputils-ping -y # On both
```

### 👉Exercise 1: Set up basic configuration

> **Note:** `loadbalancer1`and `webserver1` and `webserver2` are Ubuntu Server 24.04 LTS.

> **Note:** Internal IP addresses of loadbalancer1: `10.3.0.254` and IP of webserver1: `10.3.0.1` and IP of webserver2: `10.3.0.2`

> **Note:** External IP addresses of loadbalancer1: `192.168.70.157` and IP of webserver1: `192.168.70.158` and IP of webserver2: `192.168.70.159`.

- Set time zone to `Europe/Brussels` on both servers.
```bash
sudo timedatectl set-timezone Europe/Brussels # On both
```

- Configure the network interfaces of the servers.
```bash
sudo nano /etc/netplan/01-netcfg.yaml # On both
```
```yaml
network:
  version: 2
  ethernets:
    ens33:
      dhcp4: no
      dhcp6: no
      addresses:
        - 10.3.0.254/24 # For loadbalancer1
        - 10.3.0.1/24 # For webserver1
        - 10.3.0.2/24 # For webserver2
      nameservers:
        addresses:
          - 8.8.8.8
          - 8.8.4.4
```
```bash
sudo chmod 600 /etc/netplan/01-netcfg.yaml # On both
sudo netplan apply # On both
```

- No IPv6 on the servers.
```bash
echo "net.ipv6.conf.all.disable_ipv6 = 1" | sudo tee -a /etc/sysctl.conf > /dev/null # On both
sudo sysctl -p # On both
```

- Set the hostname of the servers.
```bash
sudo hostnamectl set-hostname loadbalancer1 # On loadbalancer1
sudo hostnamectl set-hostname webserver1 # On webserver1
sudo hostnamectl set-hostname webserver2 # On webserver2
```

- Add the hostnames to the `/etc/hosts` file.
```bash
echo -e "127.0.0.1 localhost\n10.1.0.254 loadbalancer1\n10.1.0.1 webserver1\n10.1.0.2 webserver2" | sudo tee /etc/hosts > /dev/null # On both
```














## 🔗Links
- 👯 Web hosting company [EliasDH.com](https://eliasdh.com).
- 📫 How to reach us elias.dehondt@outlook.com