![logo](https://eliasdh.com/assets/media/images/logo-github.png)
# 💙🤍W6P1 Nagios🤍💙

## 📘Table of Contents

1. [📘Table of Contents](#📘table-of-contents)
2. [📝Assignment](#📝assignment)
3. [✨Exercises](#✨exercises)
    1. [👉Exercise 0: Install necessary software packages](#👉exercise-0-install-necessary-software-packages)
    2. [👉Exercise 1: Set up basic configuration](#👉exercise-1-set-up-basic-configuration)
    3. [👉Exercise 2: Configureren server01](#👉exercise-2-configureren-server01)
    4. [👉Exercise 3: Configureren server02](#👉exercise-3-configureren-server02)
    5. [👉Exercise 4: Write your own plugin](#👉exercise-4-write-your-own-plugin)
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

- **Opmerking:** KIJK GOED NAAR WAT JE OP server01 EN OP server02 MOET UITVOEREN !!

1. Configureer de server (server01)
    - `sudo apt install nagios4 nagios-nrpe-plugin openssh-server nagstamon`
    - Bij vragen over de mailserver, kies je voor "No configuration". Kies ook een paswoord voor de nagiosadmin. Deze kan inloggen via de webinterface http://localhost/nagios4/
    - Test uit of je kan inloggen via de webinterface.
    - Volg de installatieprocedure op de eerste link om nrpe te configureren op Ubuntu 24.04. (Het MySQL gedeelte mag je overslaan)
    - Een paar hints voor de webinterface:
        - Kijk na of de configuratie geenabled is van nagios en voor cgi:
            - `sudo a2enmod cgi`
    - Kijk na in `/etc/apache2/confs/nagios-cgi.conf`
        - `ScriptAlias /cgi-bin/nagios4/ /usr/lib/cgi-bin/nagios4/`
        - `ScriptAlias /nagios4/cgi-bin/ /usr/lib/cgi-bin/nagios4/`
    - `/etc/nagios4/cgi.cfg # authentication moet aan`
        - `use_authentication=1`
        - `default_user_name=nagiosadmin`
    - Het bestand `htpasswd` heet nu htdigest
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
    - Zet alle checks aan in `/etc/nagios/nrpe.cfg`. Pas de check van de harddisk `hda1` naar een `check_all_disks` zoals in de eerste referentie
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
# If you get a question about the mail server, choose "No configuration"
# If you get a question about the nagiosadmin password, choose a password
# Test if you can go to the web interface curl http://localhost/nagios4/
sudo apt install nagios-nrpe-server openssh-server -y # Install on server02
```

### 👉Exercise 1: Set up basic configuration

> **Note:** `server01` and `server02` are Ubuntu Server 24.04 LTS.

> **Note:** Internal IP addresses of server01: `10.1.0.254` and IP of server02: `10.1.0.1`.

> **Note:** External IP addresses of server01: `192.168.70.153` and IP of server02: `192.168.70.154`.

- Set time zone to `Europe/Brussels` on both servers.
```bash
sudo timedatectl set-timezone Europe/Brussels # On both
```

- Configure the network interfaces of the `server01` and `server02`.
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
        - 10.1.0.254/24 # For server01
        - 10.1.0.1/24 # For server02
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

- Set the hostname of the server01 to `server01` and the hostname of the server02 to `server02`.
```bash
sudo hostnamectl set-hostname server01 # On server01
sudo hostnamectl set-hostname server02 # On server02
```

- Add the hostnames to the `/etc/hosts` file.
```bash
echo -e "127.0.0.1 localhost\n10.1.0.254 server01\n10.1.0.1 server02" | sudo tee /etc/hosts > /dev/null # On both
```

### 👉Exercise 2: Configureren server01

- Enable the `nagios` and `cgi` modules.
```bash
sudo a2enmod cgi # On server01
sudo a2enconf nagios4-cgi # On server01
```

- Set up user `nagiosadmin` with password `123`.
```bash
sudo htdigest -c /etc/nagios4/htdigest.users nagiosadmin nagiosadmin # On server01
```

- Add `ScriptAlias` in `/etc/apache2/conf-enabled/nagios4-cgi.conf` in the end of the file.
```bash
echo -e "\nScriptAlias /cgi-bin/nagios4/ /usr/lib/cgi-bin/nagios4/\nScriptAlias /nagios4/cgi-bin/ /usr/lib/cgi-bin/nagios4/" | sudo tee -a /etc/apache2/conf-available/nagios4-cgi.conf > /dev/null # On server01
```

- Enable authentication in `/etc/nagios4/cgi.cfg`.
```bash
sudo sed -i 's/^use_authentication=0/use_authentication=1/' /etc/nagios4/cgi.cfg # On server01
sudo sed -i 's/^#default_user_name=guest/default_user_name=nagiosadmin/' /etc/nagios4/cgi.cfg # On server01
```

- Curl from GitHub the `server02.cfg` file and `server01.cfg` file.
```bash
sudo curl -s https://raw.githubusercontent.com/EliasDeHondt/ComputerSystems3-ISB/main/Scripts/Nagios/server01.cfg -o /etc/nagios4/conf.d/server01.cfg # On server01
sudo curl -s https://raw.githubusercontent.com/EliasDeHondt/ComputerSystems3-ISB/main/Scripts/Nagios/server02.cfg -o /etc/nagios4/conf.d/server02.cfg # On server01
```

- Restart the `nagios` and `apache2` services.
```bash
sudo systemctl restart nagios4 # On server01
sudo systemctl restart apache2 # On server01
```

- Check the configuration of `nagios`.
```bash
sudo nagios4 -v /etc/nagios4/nagios.cfg # On server01
```

### 👉Exercise 3: Configureren server02

- Curl from GitHub the `nrpe.cfg` file.
```bash
sudo curl -s https://raw.githubusercontent.com/EliasDeHondt/ComputerSystems3-ISB/main/Scripts/Nagios/nrpe.cfg -o /etc/nagios/nrpe.cfg # On server02
```

> **NOTE:** Change the `allowed_hosts` to the IP address of the `server01` and IPv4,IPv6 (localhost).

- Restart the `nagios-nrpe-server` service.
```bash
sudo systemctl restart nagios-nrpe-server # On server02
```

- Check the status of the `nagios-nrpe-server` service.
```bash
sudo systemctl status nagios-nrpe-server # On server02
```

- Go to the web interface of the `server01` and check if the services are running on the `server02`.

### 👉Exercise 4: Write your own plugin

- Create a Python script that checks if the `http` and `ssh` services are running.
```bash
sudo curl -s https://raw.githubusercontent.com/EliasDeHondt/ComputerSystems3-ISB/main/Scripts/Nagios/check_services.py -o /usr/lib/nagios/plugins/check_services.py # On server02
sudo chmod +x /usr/lib/nagios/plugins/check_services.py # On server02
```

```python
#!/usr/bin/env python3
############################
# @author Elias De Hondt   #
# @see https://eliasdh.com #
# @since 24/10/2024        #
############################
import subprocess

def check_services():
    http = subprocess.run(["systemctl", "is-active", "apache2"], capture_output=True)
    ssh = subprocess.run(["systemctl", "is-active", "ssh"], capture_output=True)

    if http.returncode == 0 and ssh.returncode == 0:
        print("OK")
        exit(0)
    elif http.returncode == 0 and ssh.returncode != 0:
        print("WARNING")
        exit(1)
    else:
        print("CRITICAL")
        exit(2)

if __name__ == "__main__":
    check_services()
```

- Add the following line to the `/etc/nagios/nrpe.cfg` file.
```bash
echo -e "command[check_services]=/usr/lib/nagios/plugins/check_services.py" | sudo tee -a /etc/nagios/nrpe.cfg > /dev/null # On server02
```

- Restart the `nagios-nrpe-server` service.
```bash
sudo systemctl restart nagios-nrpe-server # On server02
```

- Check the status of the `nagios-nrpe-server` service.
```bash
sudo systemctl status nagios-nrpe-server # On server02
```

- Go to the web interface of the `server01` and check if the services are running on the `server02`.

## 🔗Links
- 👯 Web hosting company [EliasDH.com](https://eliasdh.com).
- 📫 How to reach us elias.dehondt@outlook.com