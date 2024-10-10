![logo](https://eliasdh.com/assets/media/images/logo-github.png)
# 💙🤍W4P1 Scapy🤍💙

## 📘Table of Contents

1. [📘Table of Contents](#📘table-of-contents)
2. [📝Assignment](#📝assignment)
3. [✨Exercises](#✨exercises)
    1. [👉Exercise 0: Install necessary software packages](#👉exercise-0-install-necessary-software-packages)

4. [🔗Links](#🔗links)

---

### 📝Assignment 
> NOTE This is in Dutch

- **DOEL:** Configuratie van TLS met  eigen certificate server

- **NODIG:** Ubuntu en een goed humeur

- **REFERENTIES:**
    - [REF A](https://www.digitalocean.com/community/tutorials/how-to-set-up-and-configure-a-certificate-authority-on-ubuntu-22-04)
    - [REF B](http://www.proftpd.org/docs/howto/TLS.html)

- Je kan gebruik maken van een standaard apache2 op Ubuntu

1. Activeer je SSL module
- De module mod_ssl zit standaard in het pakket apache-common
    ```bash
    sudo a2enmod ssl
    ```

2. Maak een nieuwe site
    ```bash
    sudo touch /etc/apache2/sites-available/sslsite.conf
    ```

3. Activeer je nieuwe site (ook al is deze nu nog leeg)
    ```bash
    sudo a2ensite sslsite
    ```

4. Pas het bestand `/etc/apache2/sites-available/sslsite.conf` aan met volgende gegevens:
    ```apache
    NameVirtualHost *:443
    <VirtualHost *:443>
        DocumentRoot /var/www/
        SSLEngine on
        SSLCertificateFile /etc/pki/tls/certs/mijnsslserver.crt 
        SSLCertificateKeyFile /etc/pki/tls/private/mijnsslserver.key
    </VirtualHost>
    ```

5. Kijk na in `/etc/apache2/ports.conf` of de server ook op poort 443 zal luisteren

6. Maak je eigen certificaat en sleutel aan (met jouw naam en emailadres van KdG) en zet deze klaar op de plaats die je aangaf in `/etc/apache2/sites-available/sslsite`
- Volg hiervoor volledig het document op [REF A](https://www.digitalocean.com/community/tutorials/how-to-set-up-and-configure-a-certificate-authority-on-ubuntu-22-04)

- Opgelet!
    - Gebruik de zwaarst mogelijke encryptie en sleutels
    - Configureer je eigen interne CA
- Wat is het verschil tussen een key met een passphrase en een key zonder passphrase?
    - Stel openssl.cnf in zodat default BE, Antwerpen,Antwerpen,KdG en uw email adres worden gebruikt

7. Start Apache2 opnieuw op
    ```bash
    systemctl restart apache2
    ```

8. Je kan het certificaat uittesten via de browser op hetzelfde adres.

9. Zorg ervoor dat apache enkel minstens TLS versie 1.2 gebruikt

10. Installeer en configureer proftpd zodat FTP over TLS mogelijk is.
    - Test eerst uit zonder TLS.
    - Test uit met Filezilla met de optie "Require explicit FTP over TLS"

## ✨Exercises

### 👉Exercise 0: Install necessary software packages

- Install the necessary software packages
```bash
sudo apt-get update -y && sudo apt-get upgrade -y
sudo apt-get install apache2 proftpd -y
```

### 👉Exercise 1: 














## 🔗Links
- 👯 Web hosting company [EliasDH.com](https://eliasdh.com).
- 📫 How to reach us elias.dehondt@outlook.com