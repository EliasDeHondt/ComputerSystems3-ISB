![logo](https://eliasdh.com/assets/media/images/logo-github.png)
# 💙🤍W1P1 Linux Systemd🤍💙

## 📘Table of Contents

1. [📘Table of Contents](#📘table-of-contents)
2. [📝Assignment](#📝assignment)
3. [✨Exercises](#✨exercises)

4. [🔗Links](#🔗links)

---

### 📝Assignment 
> NOTE This is in Dutch

1. Chkservice
    - Installeer chkservice
    - Het commando dat je daarvoor gebruikt is:
    - Met welk commando zie je de bestanden die chkservice installeert:
    - Zorg dat de `nginx` server opgestart is, maar niet automatisch opstart bij het opstarten van de machine.
    - Welke tekens worden er gebruikt om aan te geven dat dit juist is ingesteld?

2. Gebruik systemd om de services weer te geven die de langste opstarttijd hebben.
    - Welk commando gebruik je hiervoor?
    - Welke 4 services nemen het meeste tijd in beslag?

3. Stop en start de `nginx` service met systemctl. Dit doe je met commando:

4. Bekijk de log van `nginx` Dit doe je met commando:

5. Schrijf `helloworldd` een script (service) die om de tien seconden Hello World en de datum en tijd toont.
    - Het script moet luisteren naar het eerste argument `start` om op te starten en het eerste argument `stop` om de opgestarte service te stoppen.
    - Test dit script eerst commandline uit!
    - Zet `helloworldd` in `/usr/local/sbin`
    - Schrijf in `/etc/systemd/system/` een `helloworldd.service` die zorgt dat jouw script wordt opgestart. Je kan als inspiratie `/lib/systemd/system/nginx.service` gebruiken.
    - Zet wel het Type op simple (forking start een kind op, maar dat doen wij niet)
    - Geef het commando `systemctl daemon-reload` om de veranderingen in te laten.

    - Test nu uit of je de `helloworldd` service kan `opstarten`, `stoppen` & `status` bekijken via systemctl.

6. Op Centos/Redhat systemen bestaat een systemd service en die heet firewalld. Op Debian systemen bestaat die nog niet. Straks wel, want jij gaat die maken!

Deze bash functie veegt alle regels van de firewall en laat alles toe:
```bash
firewalld_stop() {
    iptables -F
    iptables -X
    iptables -P INPUT ACCEPT
    iptables -P FORWARD ACCEPT
    iptables -P OUTPUT ACCEPT
}
```

Deze bash functie veegt alle regels van de firewall, verbiedt alle icmp versie 4 pakketten en laat de rest toe
```bash
firewalld_start() {
    iptables -F
    iptables -X
    iptables -P INPUT ACCEPT
    iptables -P FORWARD ACCEPT
    iptables -P OUTPUT ACCEPT
    iptables -A INPUT -p icmp -j DROP
    iptables -A OUTPUT -p icmp -j DROP
}
```
Schrijf het script `/usr/local/sbin/firewalld` dat deze functies gebruikt.
Voorzie ook dat je script een restart en een reload kan doen (doe voor beide een stop en start)
Test uit met een ping versie 4.

Schrijf nu een firewalld service

Test nu uit of je de firewalld service kan opstarten/stoppen/status bekijken via systemctl.


## ✨Exercises

### 👉Exercise 1: User software package chkservice

- Install chkservice
```bash
sudo apt install chkservice
```

- Command to see the files that chkservice installs
```bash
dpkg -L chkservice
```

- Install nginx
```bash
sudo apt install nginx
```

- Or `chkservice` can be used to disable nginx from starting automatically
```bash
chkservice # Select nginx and set the value to '' (empty)
```

### 👉Exercise 2: Collecting test data for analytics purposes with systemd

- Command to see the services that take the longest to start
```bash
systemd-analyze blame

# The 4 services that take the longest to start
systemd-analyze blame | head -4 | awk '{print $2}'
```

### 👉Exercise 3: Stop and start the nginx service with systemctl

- Stop the nginx service
```bash
sudo systemctl stop nginx
```

- Start the nginx service
```bash
sudo systemctl start nginx
```

### 👉Exercise 4: View the nginx log

- View the nginx log
```bash
sudo journalctl -u nginx
```

### 👉Exercise 5: Create a service that displays "Hello World" every 10 seconds

- Create a script that displays "Hello World" every 10 seconds in the color blue in a log file [Script/helloworldd.sh](helloworldd.sh)
```bash
echo -e '#!/bin/bash\nwhile true; do echo "Hello World $(date)" >> /var/log/helloworld.log; sleep 10; done' | sudo tee /usr/local/sbin/helloworldd
sudo chmod +x /usr/local/sbin/helloworldd
```

- Create a service that starts the script [Service/helloworldd.service](helloworldd.service)
```bash
echo -e '[Unit]\nDescription=Hello World Service - Making the world a better place, one hello at a time!\n\n[Service]\nExecStartPost=/bin/bash -c 'echo "Service started: Hello World is on duty!"'\nExecStart=/usr/local/sbin/helloworldd\nExecStartPost=/bin/bash -c 'echo "Service is running like a well-oiled machine!"'\nType=simple\n\n[Install]\nWantedBy=multi-user.target' | sudo tee /etc/systemd/system/helloworldd.service
```

- Reload the daemon
```bash
sudo systemctl daemon-reload
```

- Test the service
```bash
sudo systemctl start helloworldd
sudo systemctl status helloworldd
sudo systemctl stop helloworldd

cat /var/log/helloworld.log
```

- Remove the service
```bash
sudo rm /usr/local/sbin/helloworldd
sudo rm /etc/systemd/system/helloworldd.service
sudo systemctl daemon-reload
```

### 👉Exercise 6: Create a firewalld service

- Create a script that stops and starts the firewall [Script/firewalld.sh](firewalld.sh)
```bash
echo -e '#!/bin/bash; firewalld_stop() { iptables -F; iptables -X; iptables -P INPUT ACCEPT; iptables -P FORWARD ACCEPT; iptables -P OUTPUT ACCEPT; echo "Firewall stopped: All rules flushed and all traffic allowed."; }; firewalld_start() { iptables -F; iptables -X; iptables -P INPUT ACCEPT; iptables -P FORWARD ACCEPT; iptables -P OUTPUT ACCEPT; iptables -A INPUT -p icmp -j DROP; iptables -A OUTPUT -p icmp -j DROP; echo "Firewall started: ICMP packets dropped."; }; firewalld_reload() { firewalld_stop; firewalld_start; echo "Firewall reloaded."; }; firewalld_restart() { firewalld_stop; firewalld_start; echo "Firewall restarted."; }; case "$1" in start) firewalld_start ;; stop) firewalld_stop ;; restart) firewalld_restart ;; reload) firewalld_reload ;; *) echo "Usage: $0 {start|stop|restart|reload}"; exit 1 ;; esac' | sudo tee /usr/local/sbin/firewalld
sudo chmod +x /usr/local/sbin/firewalld
```

- Create a service that starts the script [Service/firewalld.service](firewalld.service)
```bash
echo -e '[Unit]\nDescription=Firewall Service - Protecting the world from the dangers of the internet!\n\n[Service]\nExecStartPost=/bin/bash -c 'echo "Service started: Firewall is up and running!"'\nExecStart=/usr/local/sbin/firewalld start\nExecStartPost=/bin/bash -c 'echo "Service is running like a well-oiled machine!"'\nType=simple\n\n[Install]\nWantedBy=multi-user.target' | sudo tee /etc/systemd/system/firewalld.service
```

- Reload the daemon
```bash
sudo systemctl daemon-reload
```

- Test the service
```bash
sudo systemctl start firewalld
sudo systemctl status firewalld
ping -c 1 google.com
sudo systemctl stop firewalld
```

- Remove the service
```bash
sudo rm /usr/local/sbin/firewalld
sudo rm /etc/systemd/system/firewalld.service
sudo systemctl daemon-reload
```








## 🔗Links
- 👯 Web hosting company [EliasDH.com](https://eliasdh.com).
- 📫 How to reach us elias.dehondt@outlook.com