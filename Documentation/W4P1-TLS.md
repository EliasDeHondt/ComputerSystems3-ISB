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

- **DOEL:** Configuratie van TLS met eigen certificate server

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
sudo apt-get install apache2 proftpd proftpd-mod-crypto easy-rsa -y
```

### 👉Exercise 1: Configure Apache2

- Remove the default files
```bash
sudo rm -r /var/www/html
sudo rm -r /etc/apache2/sites-available/default-ssl.conf
sudo rm -r /etc/apache2/sites-available/000-default.conf
```

- Enable the SSL module
```bash
sudo a2enmod ssl
```

- Edit the file `/etc/apache2/apache2.conf` with the following content:
```apache
ServerName cs3.eliasdh.com

DefaultRuntimeDir ${APACHE_RUN_DIR}
PidFile ${APACHE_PID_FILE}
Timeout 300
KeepAlive On
MaxKeepAliveRequests 100
KeepAliveTimeout 5
User ${APACHE_RUN_USER}
Group ${APACHE_RUN_GROUP}
HostnameLookups Off
ErrorLog ${APACHE_LOG_DIR}/error.log
LogLevel warn
IncludeOptional mods-enabled/*.load
IncludeOptional mods-enabled/*.conf
Include ports.conf
<Directory />
        Options FollowSymLinks
        AllowOverride None
        Require all denied
</Directory>

<Directory /usr/share>
        AllowOverride None
        Require all granted
</Directory>

<Directory /var/www/>
        Options Indexes FollowSymLinks
        AllowOverride None
        Require all granted
</Directory>
AccessFileName .htaccess
<FilesMatch "^\.ht">
        Require all denied
</FilesMatch>
LogFormat "%v:%p %h %l %u %t \"%r\" %>s %O \"%{Referer}i\" \"%{User-Agent}i\"" vhost_combined
LogFormat "%h %l %u %t \"%r\" %>s %O \"%{Referer}i\" \"%{User-Agent}i\"" combined
LogFormat "%h %l %u %t \"%r\" %>s %O" common
LogFormat "%{Referer}i -> %U" referer
LogFormat "%{User-agent}i" agent
IncludeOptional conf-enabled/*.conf
IncludeOptional sites-enabled/*.conf
```

- Edit the file `/etc/apache2/sites-available/sslsite.conf` with the following content:
```apache
<VirtualHost *:80>
    ServerName cs3.eliasdh.com
    DocumentRoot /var/www/

    Redirect permanent / https://cs3.eliasdh.com/
</VirtualHost>

<VirtualHost *:443>
    ServerName cs3.eliasdh.com
    DocumentRoot /var/www/

    SSLEngine on
    SSLCertificateFile /etc/pki/tls/certs/cs3.eliasdh.com.crt
    SSLCertificateKeyFile /etc/pki/tls/private/cs3.eliasdh.com.key
    SSLCertificateChainFile /etc/pki/tls/certs/dh.pem
</VirtualHost>
```

- Copy the the [index.html](/Html/index.html) file to the `/var/www/` directory
```bash
sudo curl -s https://raw.githubusercontent.com/EliasDeHondt/ComputerSystems3-ISB/main/Html/index.html -o /var/www/index.html
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

- Preparing a Public Key Infrastructure Directory **(X)**:
    ```bash
    mkdir ~/easy-rsa
    ```
- Create the symlinks with the ln command **(X)**:
    ```bash
    ln -s /usr/share/easy-rsa/* ~/easy-rsa/
    ```
- Edit the parameters in the vars file **(X)**:
    ```bash
    chmod 700 ~/easy-rsa/
    ```
- Initialize the PKI **(1)**:
    ```bash
    ~/easy-rsa/easyrsa init-pki
    ```
- Creating a Certificate Authority **(2)**:
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

    set_var EASYRSA_REQ_ORG        "KdG"
    set_var EASYRSA_REQ_OU         "KdG"
    ```
- Build the Certificate Authority **(3)**:
    ```bash
    ~/easy-rsa/easyrsa build-ca
    ```
    - Enter the passphrase for the CA key.
        - Example: `password`
    - Confirm the CA key details.
        - Example: `password`
    - Enter the common name for the CA.
        - Example: `cs3.eliasdh.com`
- Generate a Certificate and Key Pair for the Server **(4)**:
    ```bash
    ~/easy-rsa/easyrsa gen-req cs3.eliasdh.com nopass
    ```
    - Enter the common name for the server.
        - Example: `cs3.eliasdh.com`
- Sign the Server Certificate **(5)**:
    ```bash
    ~/easy-rsa/easyrsa sign-req server cs3.eliasdh.com
    ```
    - Confirm the request.
        - Example: `yes`
    - Enter the passphrase for the CA key.
        - Example: `password`
- Generate a Diffie-Hellman Key Exchange **(6)**:
    ```bash
    ~/easy-rsa/easyrsa gen-dh
    ```
- Copy the Server Certificates and Keys **(X)**:
    ```bash
    sudo mkdir -p /etc/pki/tls/certs/
    sudo mkdir -p /etc/pki/tls/private/


    sudo cp /home/$USER/pki/issued/cs3.eliasdh.com.crt /etc/pki/tls/certs/
    sudo cp /home/$USER/pki/private/cs3.eliasdh.com.key /etc/pki/tls/private/
    sudo cp /home/$USER/pki/dh.pem /etc/pki/tls/certs/

    sudo chown www-data:www-data /etc/pki/tls/certs/cs3.eliasdh.com.crt
    sudo chown www-data:www-data /etc/pki/tls/private/cs3.eliasdh.com.key
    sudo chown www-data:www-data /etc/pki/tls/certs/dh.pem
    ```
- Restart Apache2 **(X)**:
    ```bash
    sudo systemctl restart apache2
    ```

- Set the domain in the local DNS.
    - For Windows, add the following line to the `C:\Windows\System32\drivers\etc\hosts` file:
        ```bash
        <EXTERNAL_IP> cs3.eliasdh.com
        ```
    - For Linux, add the following line to the `/etc/hosts` file:
        ```bash
        <EXTERNAL_IP> cs3.eliasdh.com
        ```

- Test the certificate in the browser.

![W4P1-TLS-1](/Images/W4P1-TLS-1.png)

### 👉Exercise 3: Configure Apache2 to use TLS 1.2

- Replace the file `/etc/apache2/mods-available/ssl.conf` with the following content:
```apache
# Only allow TLS 1.2 and 1.3, disable older versions
SSLProtocol TLSv1.2 TLSv1.3

# SSL random seed settings
SSLRandomSeed startup builtin
SSLRandomSeed startup file:/dev/urandom 512
SSLRandomSeed connect builtin
SSLRandomSeed connect file:/dev/urandom 512

# AddType for certificates and CRLs
AddType application/x-x509-ca-cert .crt
AddType application/x-pkcs7-crl .crl

# Passphrase dialog at startup
SSLPassPhraseDialog  exec:/usr/share/apache2/ask-for-passphrase

# SSL session cache settings
SSLSessionCache     shmcb:${APACHE_RUN_DIR}/ssl_scache(512000)
SSLSessionCacheTimeout  300

# Limit cipher suites to strong encryptions only
SSLCipherSuite HIGH:!aNULL
SSLProtocol all -SSLv3

# Disable session tickets (security consideration)
SSLSessionTickets off
```

- Restart Apache2
```bash
sudo systemctl restart apache2
```

- Test the TLS version with the following commands:
```bash
openssl s_client -connect cs3.eliasdh.com:443 -tls1 # This should not work
openssl s_client -connect cs3.eliasdh.com:443 -tls1_1 # This should not work
openssl s_client -connect cs3.eliasdh.com:443 -tls1_2 # This should work
openssl s_client -connect cs3.eliasdh.com:443 -tls1_3 # This should work
```

![W4P1-TLS-2](/Images/W4P1-TLS-2.png)

![W4P1-TLS-3](/Images/W4P1-TLS-3.png)

### 👉Exercise 4: Configure ProFTPD

- Copy the Server Certificates and Keys
```bash
sudo mkdir -p /etc/ssl/private/proftpd/
sudo cp /home/$USER/pki/issued/cs3.eliasdh.com.crt /etc/ssl/private/proftpd/
sudo cp /home/$USER/pki/private/cs3.eliasdh.com.key /etc/ssl/private/proftpd/
```

- Replace the file `/etc/proftpd/proftpd.conf` with the following content:
```apache
Include /etc/proftpd/modules.conf
LoadModule mod_tls.c

<IfModule mod_dso.c>
    LoadModule mod_tls.c
</IfModule>

<IfModule mod_tls.c>
    TLSEngine on
    TLSLog /var/ftpd/tls.log
    TLSProtocol TLSv1 TLSv1.1 TLSv1.2
    TLSRequired off
    TLSRSACertificateFile /etc/ssl/private/proftpd/cs3.eliasdh.com.crt
    TLSRSACertificateKeyFile /etc/ssl/private/proftpd/cs3.eliasdh.com.key
    TLSVerifyClient off
    TLSRenegotiate none
</IfModule>

<Limit LOGIN>
    AllowUser elias
    DenyAll
</Limit>

UseIPv6 on
<IfModule mod_ident.c>
    IdentLookups off
</IfModule>
ServerName "Debian"
ServerType standalone
DeferWelcome off
DefaultServer on
ShowSymlinks on
TimeoutNoTransfer 600
TimeoutStalled 600
TimeoutIdle 1200
DisplayLogin welcome.msg
DisplayChdir .message true
ListOptions "-l"
DenyFilter \*.*/
Port 21
<IfModule mod_dynmasq.c>
</IfModule>
MaxInstances 30
User proftpd
Group nogroup
Umask 022 022
AllowOverwrite on
TransferLog /var/log/proftpd/xferlog
SystemLog /var/log/proftpd/proftpd.log
<IfModule mod_quotatab.c>
    QuotaEngine off
</IfModule>
<IfModule mod_ratio.c>
    Ratios off
</IfModule>
<IfModule mod_delay.c>
    DelayEngine on
</IfModule>
<IfModule mod_ctrls.c>
ControlsEngine off
ControlsMaxClients 2
ControlsLog /var/log/proftpd/controls.log
ControlsInterval 5
ControlsSocket /var/run/proftpd/proftpd.sock
</IfModule>
<IfModule mod_ctrls_admin.c>
    AdminControlsEngine off
</IfModule>
Include /etc/proftpd/conf.d/
```
- Restart ProFTPD
```bash
sudo systemctl restart proftpd
```
- Open the firewall for the FTP port
```bash
sudo ufw allow 20 # FTP Data
sudo ufw allow 21 # FTP Control
sudo ufw allow 990 # FTPS Data
sudo ufw allow 989 # FTPS Control
```
- Connect with the terminal using the following command:
```bash
curl --ssl-reqd -u elias:1234 ftp://cs3.eliasdh.com
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
    - Host: `cs3.eliasdh.com`
    - Port: `21`
- Connect to the site

![W4P1-TLS-4](/Images/W4P1-TLS-4.png)

![W4P1-TLS-5](/Images/W4P1-TLS-5.png)

## 🔗Links
- 👯 Web hosting company [EliasDH.com](https://eliasdh.com).
- 📫 How to reach us elias.dehondt@outlook.com