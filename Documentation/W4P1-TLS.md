![logo](https://eliasdh.com/assets/media/images/logo-github.png)
# 💙🤍W4P1 Scapy🤍💙

## 📘Table of Contents

1. [📘Table of Contents](#📘table-of-contents)
2. [📝Assignment](#📝assignment)
3. [✨Exercises](#✨exercises)
    1. [👉Exercise 0: Install necessary software packages](#👉exercise-0-install-necessary-software-packages)
    2. [👉Exercise 1: Configure Apache2](#👉exercise-1-configure-apache2)
    3. [👉Exercise 2: Create your own certificate](#👉exercise-2-create-your-own-certificate)
    4. [👉Exercise 3: Configure Apache2 to use TLS 1.2](#👉exercise-3-configure-apache2-to-use-tls-1.2)
    5. [👉Exercise 4: Configure ProFTPD](#👉exercise-4-configure-proftpd)
    6. [👉Exercise 5: Test the configuration Filezilla](#👉exercise-5-test-the-configuration-filezilla)
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
sudo apt-get install apache2 proftpd easy-rsa -y
```

### 👉Exercise 1: Configure Apache2

- Enable the SSL module
```bash
sudo a2enmod ssl
```

- Edit the file `/etc/apache2/sites-available/sslsite.conf` with the following content:
```apache
<VirtualHost *:443>
    DocumentRoot /var/www/
    SSLEngine on
    SSLCertificateFile /etc/pki/tls/certs/demo1.cd3.eliasdh.com.crt 
    SSLCertificateKeyFile /etc/pki/tls/private/demo1.cd3.eliasdh.com.key
</VirtualHost>
```

- Copy the the [index.html](/html/index.html) file to the `/var/www/` directory
```bash
sudo curl -s https://raw.githubusercontent.com/EliasDeHondt/ComputerSystems3-ISB/main/html/index.html -o /var/www/index.html
```

- Enable the new site
```bash
sudo a2ensite sslsite
```

- Check in `/etc/apache2/ports.conf` if the server will listen on port 443:
```bash
sudo cat /etc/apache2/ports.conf | grep 443
```

### 👉Exercise 2: Create your own certificate

1. Initialize PKI
2. Create a Certificate Authority
3. Build the Certificate Authority
4. Generate a Certificate and Key Pair for the Server
5. Sign the Server Certificate
6. Generate a Diffie-Hellman Key Exchange

- Preparing a Public Key Infrastructure Directory:
    ```bash
    mkdir ~/easy-rsa
    ```
- Create the symlinks with the ln command:
    ```bash
    ln -s /usr/share/easy-rsa/* ~/easy-rsa/
    ```
- Edit the parameters in the vars file:
    ```bash
    chmod 700 /home/sammy/easy-rsa
    ```
- Initialize the PKI:
    ```bash
    ./easyrsa init-pki
    ```
- Creating a Certificate Authority:
    ```bash
    nano vars
    ```
    - Copy the following content:
    ```bash
    set_var EASYRSA_REQ_COUNTRY    "BE"
    set_var EASYRSA_REQ_PROVINCE   "Antwerpen"
    set_var EASYRSA_REQ_CITY       "Antwerpen"
    set_var EASYRSA_REQ_ORG        "KdG"
    set_var EASYRSA_REQ_EMAIL      "elias.dehondt@student.kdg.be"
    set_var EASYRSA_REQ_OU         "KdG"
    set_var EASYRSA_ALGO           "ec"
    set_var EASYRSA_DIGEST         "sha512" # md5, sha1, sha256, sha224, sha384, sha512
    ```
- Build the Certificate Authority:
    ```bash
    ./easyrsa build-ca
    ```
    - Enter the passphrase for the CA key.
        - Example: `password`
    - Confirm the CA key details.
        - Example: `password`
    - Enter the common name for the CA.
        - Example: `demo1.cd3.eliasdh.com`
- Generate a Certificate and Key Pair for the Server:
    ```bash
    ./easyrsa gen-req demo1.cd3.eliasdh.com nopass
    ```
    - Enter the common name for the server.
        - Example: `demo1.cd3.eliasdh.com`
- Sign the Server Certificate:
    ```bash
    ./easyrsa sign-req server demo1.cd3.eliasdh.com
    ```
    - Confirm the request.
        - Example: `yes`
    - Enter the passphrase for the CA key.
        - Example: `password`
- Generate a Diffie-Hellman Key Exchange:
    ```bash
    ./easyrsa gen-dh
    ```
- Copy the Server Certificates and Keys:
    ```bash
    sudo mkdir -p /etc/ssl/private
    sudo mkdir -p /etc/pki/tls/private
    sudo mkdir -p /etc/pki/tls/certs/
    sudo mkdir -p /etc/pki/tls/private/
    sudo cp /home/elias/easy-rsa/pki/ca.crt /etc/ssl/certs
    sudo cp /home/elias/easy-rsa/pki/dh.pem /etc/ssl/private
    sudo cp /home/elias/easy-rsa/pki/issued/demo1.cd3.eliasdh.com.crt /etc/pki/tls/certs/
    sudo cp /home/elias/easy-rsa/pki/private/demo1.cd3.eliasdh.com.key /etc/pki/tls/private/
    sudo chown www-data:www-data /etc/pki/tls/private/demo1.cd3.eliasdh.com.key
    sudo chown www-data:www-data /etc/pki/tls/certs/demo1.cd3.eliasdh.com.crt
    ```
- Restart Apache2
    ```bash
    systemctl restart apache2
    ```

- Test the certificate in the browser

### 👉Exercise 3: Configure Apache2 to use TLS 1.2

- Edit the file `/etc/apache2/mods-available/ssl.conf` and add the following line:
```apache
SSLProtocol all -SSLv2 -SSLv3 -TLSv1 -TLSv1.1
```
- Restart Apache2
```bash
systemctl restart apache2
```

### 👉Exercise 4: Configure ProFTPD

- Edit the file `/etc/proftpd/proftpd.conf` and add the following lines:
```apache
<IfModule mod_tls.c>
    TLSEngine on
    TLSLog /var/log/proftpd/tls.log
    TLSProtocol TLSv1.2
    TLSOptions NoSessionReuseRequired
    TLSRSACertificateFile /etc/pki/tls/certs/demo1.cd3.eliasdh.com.crt
    TLSRSACertificateKeyFile /etc/pki/tls/private/demo1.cd3.eliasdh.com.key
    TLSVerifyClient off
    TLSRequired on
</IfModule>
<Limit LOGIN>
    AllowUser elias
    DenyAll
</Limit>
```
- Restart ProFTPD
```bash
systemctl restart proftpd
```
- Open the firewall for the FTP port
```bash
sudo ufw allow 20 # FTP Data
sudo ufw allow 21 # FTP Control
```
- Connect with the terminal using the following command:
```bash
curl --ssl-reqd -u elias:1234 ftp://demo1.cd3.eliasdh.com
```
### 👉Exercise 5: Test the configuration Filezilla

- Install Filezilla
```bash
sudo apt-get install filezilla -y
```
- Open Filezilla
- Go to `File` > `Site Manager`
- Add a new site
- Configure the site with the following settings:
    - Protocol: `FTP - File Transfer Protocol`
    - Encryption: `Require explicit FTP over TLS`
    - Logon Type: `Normal`
    - User: `elias`
    - Password: `password`
    - Host: `demo1.cd3.eliasdh.com`
    - Port: `21`
- Connect to the site

## 🔗Links
- 👯 Web hosting company [EliasDH.com](https://eliasdh.com).
- 📫 How to reach us elias.dehondt@outlook.com