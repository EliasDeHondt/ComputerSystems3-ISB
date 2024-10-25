![logo](https://eliasdh.com/assets/media/images/logo-github.png)
# 💙🤍HTTP3🤍💙

## 📘Table of Contents

1. [📘Table of Contents](#📘table-of-contents)
2. [📝Assignment](#📝assignment)
3. [✨Exercises](#✨exercises)
    1. [👉Exercise 1: Info](#👉exercise-1-info)
    2. [👉Exercise 2: Nginx](#👉exercise-2-nginx)
5. [🔗Links](#🔗links)

---

### 📝Assignment 
> NOTE This is in Dutch

- HTTP3 bij google.com
    - Open firefox
    - Geef about:config als URL in
    - Kijk volgende settings na:
        - `network.http.http3.enable true`
        - `network.http.http3.enable_0rtt true`
        - `security.tls13.aes_128_gcm_sha256 true`
        - `security.tls13.aes_256_gcm_sha384 true`
        - `security.tls13.chacha20_poly1305_sha256 true`
    - Open de Web Developer Tools (CTRL-SHIFT-L)
    - Kies het menu item Network
    - Surf naar `https://google.com`
    - Kies eventueel voor reload moest er niets verschijnen
    - De eerste aanvraag is HTTP/2
    - Hoe weet de browser dat hij daarna HTTP/3 kan proberen?
    - Leg de aanvraag vast met `tcpdump` (enkel die interface). Schrijf de pakketten weg naar een pcap bestand. Welk commando geef je hiervoor?
    - Open dit bestand in wireshark. Zijn alle pakketten HTTP3? Vind je nog fouten in de afhandeling?

- HTTP3 bij nginx
- [REF](https://www.humankode.com/ssl/create-a-selfsigned-certificate-for-nginx-in-5-minutes/) naar een externe site.
- Volg de installatie van de REF om nginx met https te configureren.
- Gebruik `nginx -V` om na te kijken of nginx met HTTP3 ondersteuning is gecompileerd.
- Configureer `/etc/nginx/sites-available/default.conf` zodat nginx op poort `8443` HTTP3 ondersteund.
- Gebruik de Web Developer Tools / Netwerk TAB om na te kijken of nginx echt omschakelt naar HTTP3.


## ✨Exercises

### 👉Exercise 1: Info

- Open `firefox`.
- Go to `about:config`.
- Check the following settings:
    - `network.http.http3.enable true`
    - `network.http.http3.enable_0rtt true`
    - `security.tls13.aes_128_gcm_sha256 true`
    - `security.tls13.aes_256_gcm_sha384 true`
    - `security.tls13.chacha20_poly1305_sha256 true`
- Open the Web Developer Tools (CTRL-SHIFT-L).
- Choose the menu item Network.
- Surf to `https://google.com`.
- Choose reload if nothing appears.
- The first request is HTTP/2.
- How does the browser know that it can try HTTP/3 afterwards?
    - **Answer**: The browser knows it can try HTTP/3 afterwards because of the `Alt-Svc` header in the response.
- Capture the request with `tcpdump` (only that interface). Write the packets to a pcap file. What command do you give for this?
    - **Answer**: `sudo tcpdump -i ens33 -w google.pcap`
- Open this file in wireshark. Are all packets HTTP3? Do you find any errors in the handling?
    - How to open the file in wireshark `wireshark google.pcap`.
    - **Answer**: Not all packets are HTTP3. The first request is HTTP/2. The browser knows it can try HTTP/3 afterwards because of the `Alt-Svc` header in the response.

### 👉Exercise 2: Nginx

- Generate a Self-Signed Certificate using OpenSSL.
```bash
sudo curl -s https://raw.githubusercontent.com/EliasDeHondt/ComputerSystems3-ISB/main/Scripts/http3/localhost.conf -o ./localhost.conf
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout localhost.key -out localhost.crt -config localhost.conf
```

- Copy the Certificate Key Pair to the Certificates folder on Ubuntu.
```bash
sudo cp localhost.crt /etc/ssl/certs/localhost.crt
sudo cp localhost.key /etc/ssl/private/localhost.key
```

- Update the Nginx Configuration File to Load the Certificate Key Pair.
```bash
sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get remove apache2 -y # Remove Apache2
sudo apt-get remove nginx -y
sudo curl -s https://raw.githubusercontent.com/EliasDeHondt/ComputerSystems3-ISB/main/html/index.html -o /var/www/html/index.html
sudo curl -s https://raw.githubusercontent.com/EliasDeHondt/ComputerSystems3-ISB/main/Scripts/http3/nginx.conf -o /etc/nginx/sites-available/default
sudo service nginx stop && sudo service nginx start
```

- Open up the Google Chrome to Verify that Nginx Loads the Site Over HTTP and HTTPS.
    - Since I haven't added the self-signed certificate to Chrome's CA Root store, Chrome shows the site as insecure.
    - Click proceed to Localhost to verify that Nginx is correctly configured.
    - Nginx is Serving the Self-Signed Certificates, But Google Chrome is Showing the Site as Not Secure

- Configure Chrome to Trust the Certificate and to Show the Site as Secure.
```bash
sudo apt-get update && sudo apt-get upgrade -y
sudo apt install libnss3-tools -y
mkdir -p ~/.pki/nssdb
certutil -N -d sql:$HOME/.pki/nssdb # NO PASSWORD!!!
certutil -d sql:$HOME/.pki/nssdb -A -t "P,," -n "localhost" -i localhost.crt
sudo service nginx reload
```
- Google Chrome Shows the Site as Secure

- Check if Nginx is Compiled with HTTP3 Support.
```bash
nginx -V
```

## 🔗Links
- 👯 Web hosting company [EliasDH.com](https://eliasdh.com).
- 📫 How to reach us elias.dehondt@outlook.com