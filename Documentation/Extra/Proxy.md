![logo](https://eliasdh.com/assets/media/images/logo-github.png)
# 💙🤍Proxy🤍💙

## 📘Table of Contents

1. [📘Table of Contents](#📘table-of-contents)
2. [📝Assignment](#📝assignment)
3. [✨Exercises](#✨exercises)
    1. [👉Exercise 0: Preparations](#👉exercise-0-preparations)
    2. [👉Exercise 1: Preparations](#👉exercise-1-preparations)
    3. [👉Exercise 2: Configure squid3](#👉exercise-2-configure-squid3)
    4. [👉Exercise 3: Block .kdg.be](#👉exercise-3-block-kdgbe)
    5. [👉Exercise 4: Remove ads](#👉exercise-4-remove-ads)
    6. [👉Exercise 5: Content filtering](#👉exercise-5-content-filtering)
    7. [👉Exercise 6: Prox cache](#👉exercise-6-prox-cache)
    8. [👉Exercise 7: Real-time virus check](#👉exercise-7-real-time-virus-check)
    9. [👉Exercise 8: Install webmin](#👉exercise-8-install-webmin)
4. [🔗Links](#🔗links)

---

### 📝Assignment 
> NOTE This is in Dutch

- **NODIG:** Ubuntu
- **DOELSTELLING:** Installatie en configuratie van een proxy server
- **REF:**
    - [REF 1](https://calomel.org/squid_adservers.html)
    - [REF 2](http://www.squid-cache.org/Misc/redirectors.html)
    - [REF 3](http://www.squid-cache.org/Doc/config/cache_dir/)
    - [REF 4](http://ubuntuserverguide.com/2012/06/how-to-install-webmin-on-ubuntu-server-12-04-lts.html)
    - [REF 5](http://www.visolve.com/uploads/resources/squid30.pdf)
    - [REF 6](https://computingforgeeks.com/how-to-setup-squid-proxy-server-on-ubuntu-18-04-ubuntu-16-04-centos7)

- **OPGAVE:**
1. Doe een `apt install squid curl e2guardian clamav-daemon clamav-testfiles`

2. Stel squid3 in zodat deze draait op poort `8080`
    - Eventuele foutmeldingen staan in `/var/log/syslog` of krijg je via journactl -u squid
    - Logs van squid staan in de directory `/var/log/squid/`
    - Test uit door je browser in te stellen met jezelf als proxy

3. Schrijf een acl zodat alles van `.kdg.be` verboden wordt Test uit!

4. Weg met reclame! Installeer en configureer een ad blocker voor squid. volg de procedure op de eerste referentie.

5. Content filtering:
    - Laat e2guardian draaien op poort `8888` en doorverwijzen naar je proxy server.
    - Herstart e2guardian (`systemctl restart e2guardian; systemctl status e2guardian`)
    - Test nu uit door als proxypoort `8888` te geven. Het verkeer gaat nu eerst via e2guardian en dan langs de proxy.

6. Zorg nu dat je proxy een lokale disk cache van `1024MB` gebruikt. Stel ook de maximum object size in op `100000 KB` zodat ook grote bestanden gecached worden. Herstart de proxy server.
    - Test de proxy uit met volgend commando (bestand van `62MB`): time wget `http://download.blender.org/peach/bigbuckbunny_movies/BigBuckBunny_320x180.mp4`
    - Kijk ook na of in `/var/spool/squid` de cachefiles zijn gezet

7. Stel e2guardian in, zodat deze ook realtime op virussen nakijkt met clamav-daemon.
    - clamav staat al auto ingesteld in `/etc/e2guardian/contentscanners` maar moet je in `/etc/e2guardian/e2guardian.conf` activeren.
    - Activeer clamdscan.conf.
    - Pas de e2guardian user aan naar de clamav daemon user.
    - Je kan via de proceslijst kijken met welke user clamav draait.
    - `In /etc/e2guardian/e2guardian.conf`
    - `daemonuser = 'clamav'`
    - `daemongroup = 'clamav'`
    - root@kdguntu# `systemctl stop e2guardian`
    - root@kdguntu# `rm /tmp/.e2guardian*`
    - root@kdguntu# `systemctl start e2guardian`
    - Los eventuele Permission Denied problemen op door chgrp (geen chmod 777!)

8. Extra Installeer webmin (pakket op `sourceforge.net`) en zorg dat je via de webinterface squid kan instellen.

## ✨Exercises

### 👉Exercise 1: Preparations

- Install the necessary software on both machines.
```bash
sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install squid curl e2guardian clamav-daemon clamav-testfiles libauthen-pam-perl apt-show-versions python3 -y
```

### 👉Exercise 2: Configure squid3

- Configure squid3 to run on port 8080.
```bash
sudo rm /etc/squid/squid.conf
sudo touch /etc/squid/squid.conf
sudo bash -c 'echo "http_port 8080" >> /etc/squid/squid.conf'
```

### 👉Exercise 3: Block .kdg.be

- Write an acl so that everything from .kdg.be is prohibited. Test it out!
```bash
sudo bash -c 'echo "acl kdg dstdomain .kdg.be" >> /etc/squid/squid.conf'
sudo bash -c 'echo "http_access deny CONNECT kdg" >> /etc/squid/squid.conf'
```

### 👉Exercise 4: Remove ads

- Write an acl for squid to block ads.
```bash
sudo wget -O /etc/squid/ad_block.txt http://pgl.yoyo.org/adservers/serverlist.php?hostformat=nohtml&showintro=0&mimetype=plaintext
sudo bash -c 'echo "acl ads dstdom_regex  \"/etc/squid/ad_block.txt\"" >> /etc/squid/squid.conf'
sudo bash -c 'echo "http_access deny CONNECT ads" >> /etc/squid/squid.conf'
```

- Restart squid.
```bash
sudo systemctl restart squid
```

### 👉Exercise 5: Content filtering

- Let e2guardian run on port 8888 and redirect to your proxy server.
```bash
sudo sed -i 's/filterports = 8080/filterports = 8888/g' /etc/e2guardian/e2guardian.conf
sudo sed -i 's/#proxyip = 127.0.0.1/proxyip = 127.0.0.1/g' /etc/e2guardian/e2guardian.conf
sudo sed -i 's/#proxyport = 3128/proxyport = 8080/g' /etc/e2guardian/e2guardian.conf
```

- Restart e2guardian and squid.
```bash
sudo systemctl restart e2guardian
sudo systemctl restart squid
```

### 👉Exercise 6: Prox cache

- Make sure your proxy uses a local disk cache of 1024MB.
```bash
sudo bash -c 'echo "cache_dir ufs /var/spool/squid 1024 16 256" >> /etc/squid/squid.conf'
sudo bash -c 'echo "maximum_object_size 100000 KB" >> /etc/squid/squid.conf'
```

- Restart squid.
```bash
sudo systemctl stop squid
sudo squid -z
sudo systemctl start squid
```

- Test the proxy with the following command (file of 62MB).
```bash
time wget -e use_proxy=yes -e http_proxy=http://localhost:8080 http://tinycorelinux.net/15.x/x86/release/TinyCore-current.iso # 23MB
```

- Check if the cache files are set in `/var/spool/squid`:
```bash
sudo du -sh /var/spool/squid
```

### 👉Exercise 7: Real-time virus check

- Set the user and group of e2guardian to the clamav daemon user.
```bash
sudo sed -i 's/#daemonuser = 'e2guardian'/daemonuser = 'clamav'/g' /etc/e2guardian/e2guardian.conf
sudo sed -i 's/#daemongroup = 'e2guardian'/daemongroup = 'clamav'/g' /etc/e2guardian/e2guardian.conf
```

- Set the clamdscan.conf file.
```bash
sudo rm /etc/e2guardian/contentscanners/clamdscan.conf
sudo touch /etc/e2guardian/contentscanners/clamdscan.conf
sudo bash -c 'echo "plugname = \"clamdscan\"" >> /etc/e2guardian/contentscanners/clamdscan.conf'
sudo bash -c 'echo "clamdudsfile = \"/run/clamav/clamd.ctl\"" >> /etc/e2guardian/contentscanners/clamdscan.conf'
```

- Restart e2guardian.
```bash
sudo systemctl stop e2guardian
sudo rm /tmp/.e2guardian*
sudo systemctl start e2guardian
```

- Solve any Permission Denied problems by chgrp (no chmod 777!).
```bash
sudo chgrp clamav /var/log/e2guardian
sudo chgrp clamav /var/log/e2guardian/access.log
sudo chgrp clamav /var/log/e2guardian/error.log
sudo chgrp clamav /var/log/e2guardian/e2guardian.log
sudo chgrp clamav /var/log/e2guardian/e2guardianf1.log
sudo chgrp clamav /var/log/e2guardian/e2guardianf2.log

sudo chgrp clamav /var/log/clamav
sudo chgrp clamav /var/log/clamav/clamav.log
sudo chgrp clamav /var/log/clamav/freshclam.log
```

- Check the clamav user.
```bash
ps aux | grep clamav
```

- Check the e2guardian user.
```bash
ps aux | grep e2guardian
```

- Check the squid user.
```bash
ps aux | grep squid
```

### 👉Exercise 8: Install webmin

- Install webmin.
```bash
sudo sh -c 'echo "deb http://download.webmin.com/download/repository sarge contrib" > /etc/apt/sources.list.d/webmin.list'
wget -qO - http://www.webmin.com/jcameron-key.asc | sudo apt-key add -
sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install webmin -y
```

- Access webmin via your browser `http://localhost:10000`.
    - Login with your user and password.

- Test in the terminal.
```bash
wget -O - http://localhost:10000
```

## 🔗Links
- 👯 Web hosting company [EliasDH.com](https://eliasdh.com).
- 📫 How to reach us elias.dehondt@outlook.com