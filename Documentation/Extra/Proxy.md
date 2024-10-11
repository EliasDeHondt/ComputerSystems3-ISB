![logo](https://eliasdh.com/assets/media/images/logo-github.png)
# 💙🤍Firewalls Iptables🤍💙

## 📘Table of Contents

1. [📘Table of Contents](#📘table-of-contents)
2. [📝Assignment](#📝assignment)
3. [✨Exercises](#✨exercises)
    1. [👉Exercise 0: Preparations](#👉exercise-0-preparations)
    
5. [🔗Links](#🔗links)

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
1. Doe een apt install squid curl e2guardian clamav-daemon clamav-testfiles

2. Stel squid3 in zodat deze draait op poort 8080
    - Eventuele foutmeldingen staan in /var/log/syslog of krijg je via journactl -u squid
    - Logs van squid staan in de directory /var/log/squid/

3. Test uit door je browser in te stellen met jezelf als proxy

4. Schrijf een acl zodat alles van .kdg.be verboden wordt Test uit!

5. Weg met reclame! Installeer en configureer een ad blocker voor squid. volg de procedure op de eerste referentie.

6. Content filtering:
- Laat e2guardian draaien op poort 8888 en doorverwijzen naar je proxy server.
- Herstart e2guardian (systemctl restart e2guardian; systemctl status e2guardian)
- Test nu uit door als proxypoort 8888 te geven. Het verkeer gaat nu eerst via e2guardian en dan langs de proxy.

7. Zorg nu dat je proxy een lokale disk cache van 1024MB gebruikt. Stel ook de maximum object size in op 100000 KB zodat ook grote bestanden gecached worden.Herstart de proxy server.
    - Test de proxy uit met volgend commando (bestand van 62MB): time wget `http://download.blender.org/peach/bigbuckbunny_movies/BigBuckBunny_320x180.mp4`
    - Kijk ook na of in /var/spool/squid de cachefiles zijn gezet

8. Stel e2guardian in, zodat deze ook realtime op virussen nakijkt met clamav-daemon.
    - clamav staat al auto ingesteld in /etc/e2guardian/contentscanners maar moet je in /etc/e2guardian/e2guardian.conf activeren.
    - Activeer clamdscan.conf.
    - Pas de e2guardian user aan naar de clamav daemon user.
    - Je kan via de proceslijst kijken met welke user clamav draait.
    - In /etc/e2guardian/e2guardian.conf
    - daemonuser = 'clamav'
    - daemongroup = 'clamav'
    - root@kdguntu# systemctl stop e2guardian
    - root@kdguntu# rm /tmp/.e2guardian*
    - root@kdguntu# systemctl start e2guardian
    - Los eventuele Permission Denied problemen op door chgrp (geen chmod 777!)

9. Extra Installeer webmin (pakket op sourceforge.net) en zorg dat je via de webinterface squid kan instellen.

## ✨Exercises

### 👉Exercise 0: Preparations

- Install the necessary software on both machines.
```bash
sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install squid curl e2guardian clamav-daemon clamav-testfiles -y
```

### 👉Exercise 1: 





## 🔗Links
- 👯 Web hosting company [EliasDH.com](https://eliasdh.com).
- 📫 How to reach us elias.dehondt@outlook.com