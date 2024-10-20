![logo](https://eliasdh.com/assets/media/images/logo-github.png)
# 💙🤍W6P1 Nagios🤍💙

## 📘Table of Contents

1. [📘Table of Contents](#📘table-of-contents)
2. [📝Assignment](#📝assignment)
3. [✨Exercises](#✨exercises)
    1. [👉Exercise 0: Install necessary software packages](#👉exercise-0-install-necessary-software-packages)

4. [🔗Links](#🔗links)

---

### 📝Assignment 
> NOTE This is in Dutch

- **DOEL:** Installatie en configuratie Nagios en Nagios plugins

- **NODIG:**  
    - Controller: ubuntu 24.04 (schijf 10GB, 3GB ram, NAT en Host-Only) 
    - Managed node: ubuntu 24.04 (schijf 10GB, 512MB ram, NAT en Host-Only)

- **REFERENTIES:**
    - [REF A](https://ubuntu.com/server/docs/tools-nagios)
    - [REF B](https://tecadmin.net/how-to-create-own-nagios-plugin-using-bash-shell-script)
    - [REF C](http://nagios.sourceforge.net/docs/nrpe/NRPE.pdf)

- **Opmerking:** KIJK GOED NAAR WAT JE OP  server01  EN OP server02 MOET UITVOEREN !!

1. Configureer de server (server01)
    - `sudo apt install nagios4 nagios-nrpe-plugin openssh-server nagstamon`
    - Bij vragen over de mailserver, kies je voor "No configuration". Kies ook een paswoord voor de nagiosadmin. Deze kan inloggen via de webinterface http://localhost/nagios4/
    - Test uit of je kan inloggen via de webinterface.
    - Volg de installatieprocedure op de eerste link om nrpe te configureren op Ubuntu 24.04. (Het MySQL gedeelte mag je overslaan)
    - Een paar hints voor de webinterface:
        - Kijk na of de configuratie geenabled is van nagios en voor cgi:
            - `sudo a2enmod cgi nagios4-cgi`
    - Kijk na in  /etc/apache2/confs/nagios-cgi.conf    # EINDSLASHES !
        - `ScriptAlias /cgi-bin/nagios4/ /usr/lib/cgi-bin/nagios4/`
        - `ScriptAlias /nagios4/cgi-bin/ /usr/lib/cgi-bin/nagios4/`
    - `/etc/nagios4/cgi.cfg # authentication moet aan`
        - `use_authentication=1`
        - `default_user_name=nagiosadmin`
    - het bestand `htpasswd` heet nu htdigest
    - Copieer het bestand `/etc/nagios4/objects/localhost.cfg` naar: `/etc/nagios4/conf.d/server02.cfg`
    - Voor de host kan je volgende configuratie nemen:
    ```dns
    define host {
    use                      generic-host            ; Name of host template to use
    host_name                server02
    hostgroups               linux-servers
    address                  192.168.59.103
    max_check_attempts       5
    check_interval           5
    retry_interval           1
    }
    ```
    - De hostgroup definitie mag je in commentaar zetten. 
    - De services mag je allemaal activeren.

2. Configureer de agent (server02)
    - `sudo apt install nagios-nrpe-server openssh-server`
    - Zet alle checks aan in /etc/nagios/nrpe.cfg. Pas de check van de harddisk hda1 naar een command[check_all_disks] zoals  in de eerste referentie

    - Test uit of je de server02 gegevens kan opvragen via http://localhost/nagios4/ op server01. Kies links services om te kijken of alle checks werden uitgevoerd.
    - Handige commando's en logs:
    ```bash
    sudo nagios4 -v /etc/nagios4/nagios.cfg                      # Config check!
    sudo systemctl restart nagios4
    sudo systemctl status nagios4
    sudo cat /var/log/nagios4/nagios.log
    sudo systemctl restart apache2
    sudo systemctl status apache2
    cat /var/log/apache2/error.log
    ```

3. Schrijf je eigen plugin
    - Schrijf in python3 je eigen plugin. 
    - Deze geeft in nagios OK (0)  wanneer zowel de http als de ssh server draaien, een warning (1)  wanneer ssh niet draait en http wel, een critical(2) bericht in andere gevallen.

## ✨Exercises

### 👉Exercise 0: Install necessary software packages

- Install the necessary software packages
```bash
sudo apt-get update -y && sudo apt-get upgrade -y
sudo apt install nagios4 nagios-nrpe-plugin openssh-server nagstamon -y # Install on server01
sudo apt install nagios-nrpe-server openssh-server -y # Install on server02
```

### 👉Exercise 1:








## 🔗Links
- 👯 Web hosting company [EliasDH.com](https://eliasdh.com).
- 📫 How to reach us elias.dehondt@outlook.com