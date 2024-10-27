![logo](https://eliasdh.com/assets/media/images/logo-github.png)
# 💙🤍W6P1 Loadbalancing🤍💙

## 📘Table of Contents

1. [📘Table of Contents](#📘table-of-contents)
2. [📝Assignment](#📝assignment)
3. [✨Exercises](#✨exercises)
    1. [👉Exercise 0: Install necessary software packages](#👉exercise-0-install-necessary-software-packages)
    2. [👉Exercise 1: Set up basic configuration](#👉exercise-1-set-up-basic-configuration)
    3. [👉Exercise 2: Configure load balancer](#👉exercise-2-configure-load-balancer)
    4. [👉Exercise 3: Configure web servers](#👉exercise-3-configure-web-servers)
    5. [👉Exercise 4: Create a script to test the load balancer](#👉exercise-4-create-a-script-to-test-the-load-balancer)µ
4. [🔗Links](#🔗links)

---

### 📝Assignment 
> NOTE This is in Dutch

- **DOEL:** Configureren en uittesten van een session-aware load-balancer.

- **NODIG:** 1 linux loadbalancer, 2 linux nodes

1. Maak 3 virtuele machines, 1 loadbalancer en 2 nodes (webserver). Elke virtuele machine heeft een extern IP adres en ook een intern IP adres.

2. APACHE MOD PROXY BALANCER
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

    # Do not proxy balancer-manager
    ProxyPass /balancer-manager !
    # The actual ProxyPass
    ProxyPass / balancer://192.168.56.101/ stickysession=BALANCEID nofailover=Off
    # Do not forget ProxyPassReverse for redirects
    ProxyPassReverse / http://192.168.56.102/
    ProxyPassReverse / http://192.168.56.103/
    ```

3. TESTSCRIPT WEBSERVER
    - Schrijf een script dat om de 2 seconden de inhoud van een website opvraagt en dit toont op het scherm.
    - Wanneer `index.html` op `Webserver 1` en op `Webserver 2` bevat, toont het script de naam van de webserver waarvan de inhoud komt.
    - Ga er van uit dat er html code (en niet enkel tekst) staat in het bestand index.html.
    - Bij falen toont het script volgende foutboodschap op het scherm: `Webserver 1 is down, Webserver 2 is down`.
    - Test het script uit op je APACHE PROXY BALANCER, tijdens het afwisselend uitschakelen van `webserver1` en `webserver2`.

## ✨Exercises

### 👉Exercise 0: Install necessary software packages

- Install the necessary software packages
```bash
sudo apt-get update -y && sudo apt-get upgrade -y # On both
sudo apt-get install apache2 nano iputils-ping libapache2-mod-proxy-html -y # On loadbalancer1
```

> **Note:** In the latest Ubuntu versions, load balancing packages are automatically installed when you install Apache2.

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

### 👉Exercise 2: Configure load balancer

- Enable the necessary modules on the load balancer.
```bash
sudo a2enmod proxy proxy_http headers proxy_balance lbmethod_byrequests # On loadbalancer1
sudo systemctl restart apache2 # On loadbalancer1
```

- Remove useless directories.
```bash
sudo rm -r /etc/apache2/sites-available/* # On loadbalancer1
sudo rm -r /etc/apache2/sites-enabled/* # On loadbalancer1
sudo rm -r /var/www/* # On loadbalancer1
```
- Configure the load balancer.
```bash
sudo curl -s https://raw.githubusercontent.com/EliasDeHondt/ComputerSystems3-ISB/main/Scripts/loadbalancer1.conf -o /etc/apache2/sites-available/loadbalancer1.conf
```

- Enable the site and restart Apache.
```bash
echo "ServerName localhost" | sudo tee -a /etc/apache2/apache2.conf > /dev/null # On loadbalancer1
sudo a2ensite loadbalancer1 # On loadbalancer1
sudo systemctl restart apache2 # On loadbalancer1
```

### 👉Exercise 3: Configure web servers

- Remove useless directories
```bash
sudo rm -r /etc/apache2/sites-available/* # On webserver1 and webserver2
sudo rm -r /etc/apache2/sites-enabled/* # On webserver1 and webserver2
sudo rm -r /var/www/* # On webserver1 and webserver2
```

- Configure the web servers.
```bash
sudo curl -s https://raw.githubusercontent.com/EliasDeHondt/ComputerSystems3-ISB/main/Scripts/webserver1.conf -o /etc/apache2/sites-available/webserver1.conf # On webserver1
sudo curl -s https://raw.githubusercontent.com/EliasDeHondt/ComputerSystems3-ISB/main/Scripts/webserver2.conf -o /etc/apache2/sites-available/webserver2.conf # On webserver2
```

- Create the [index.html](/Html/index.html) file.
```bash
sudo curl -s https://raw.githubusercontent.com/EliasDeHondt/ComputerSystems3-ISB/main/Html/index.html -o /var/www/index.html # On webserver1 and webserver2
```

- Enable the sites and restart Apache.
```bash
sudo a2ensite webserver1 # On webserver1
sudo a2ensite webserver2 # On webserver2
sudo systemctl restart apache2 # On webserver1 and webserver2
```

### 👉Exercise 4: Create a script to test the load balancer

- Create the [test.sh](/Scripts/Loadbalancing/test_loadbalancer.sh) script.
```bash
bash <(curl -s https://raw.githubusercontent.com/EliasDeHondt/ComputerSystems3-ISB/main/Scripts/Loadbalancing/test_loadbalancer.sh) # On loadbalancer1
```

- You can also go to the Internet browser on your host computer and go to the public IP address of your load balancer in this case `192.168.70.157`.

## 🔗Links
- 👯 Web hosting company [EliasDH.com](https://eliasdh.com).
- 📫 How to reach us elias.dehondt@outlook.com