![logo](https://eliasdh.com/assets/media/images/logo-github.png)
# 💙🤍W2P1 DNS🤍💙

## 📘Table of Contents

1. [📘Table of Contents](#📘table-of-contents)
2. [📝Assignment](#📝assignment)
3. [✨Exercises](#✨exercises)
    1. [👉Exercise 0: Install necessary software packages](#👉exercise-0-install-necessary-software-packages)
    2. [👉Exercise 1: Configure Primary Master DNS server](#👉exercise-1-configure-primary-master-dns-server)
    3. [👉Exercise 2: Define www.dehondt.localtest and mail.dehondt.localtest](#👉exercise-2-define-wwwdehondtlocaltest-and-maildehondtlocaltest)
    4. [👉Exercise 3: Test DNS configuration](#👉exercise-3-test-dns-configuration)
    5. [👉Exercise 4: Configure DNS server as DNS server](#👉exercise-4-configure-dns-server-as-dns-server)
    6. [👉Exercise 5: Test forward lookup](#👉exercise-5-test-forward-lookup)
    7. [👉Exercise 6: Test reverse lookup](#👉exercise-6-test-reverse-lookup)
    8. [👉Exercise 7: Configure ping via nameserver](#👉exercise-7-configure-ping-via-nameserver)
4. [🔗Links](#🔗links)

---

### 📝Assignment 
> NOTE This is in Dutch

1. Installeer `bind9` en `bind9utils`.
    - Configureer een Primary Master DNS server (`bind9`) op jouw domein (bv achternaam.localtest). Gebruik als IP adres het Host Only adres.

2. Definieer ook `www.achternaam.localtest` (Koppelingen naar een externe site.) en `mail.achternaam.localtest` met hetzelfde IP adres.

3. Test uit of jouw DNS configuratiebestanden juist zijn.

4. Configureer jouw DNS server als DNS server (in `/etc/resolv.conf`).

5. Test uit of een forward lookup werkt (dig, nslookup en host `www.achternaam.localtest` (Koppelingen naar een externe site.))

6. Test uit of een reverse lookup werkt (dig, nslookup en host IP adres)

7. Zorg dat ook een ping via de nameserver werkt (hint: `/etc/nsswitch.conf`)

## ✨Exercises

### 👉Exercise 0: Install necessary software packages

```bash
sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install bind9 bind9utils -y
sudo clear
```

### 👉Exercise 1: Configure Primary Master DNS server

- Open the configuration file for the localtest DNS server
```bash
sudo nano /etc/bind/named.conf.local
```

- Add the following configuration to the file
```bash
zone "dehondt.localtest" {
        type master;
        file "/etc/bind/db.dehondt.localtest";
};
```

- Create the zone file
```bash
sudo nano /etc/bind/db.dehondt.localtest
```

- Add the following configuration to the file
```bash
$TTL    604800
@       IN      SOA     dehondt.localtest. root.dehondt.localtest. (
                              2         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;

; Name servers
@       IN      NS      dehondt.localtest.

; A records
@       IN      A       192.168.1.210 ; IP address of the DNS server (dehondt.localtest)
```

- Restart the DNS server
```bash
sudo systemctl restart bind9
```

### 👉Exercise 2: Define www.dehondt.localtest and mail.dehondt.localtest

- Create the zone file
```bash
sudo nano /etc/bind/db.dehondt.localtest
```

- Add the following configuration to the file
```bash
www     IN      A       142.250.179.142 ; IP address of google.com (www.dehondt.localtest)
mail    IN      A       192.168.1.210 ; IP address of the DNS server (mail.dehondt.localtest)
```

- Restart the DNS server
```bash
sudo systemctl restart bind9
```

### 👉Exercise 3: Test DNS configuration

- Test the DNS configuration (Manual validation)
```bash
dig @192.168.1.210 dehondt.localtest
dig @192.168.1.210 www.dehondt.localtest
dig @192.168.1.210 mail.dehondt.localtest
```

- Test the DNS configuration (Automated validation)
```bash
clear && dig @192.168.1.210 dehondt.localtest | grep -q "QUESTION" && echo -e "\e[32mOK\e[0m - dehondt.localtest" || echo -e "\e[31mFAILED\e[0m - dehondt.localtest"; dig @192.168.1.210 www.dehondt.localtest | grep -q "QUESTION" && echo -e "\e[32mOK\e[0m - www.dehondt.localtest" || echo -e "\e[31mFAILED\e[0m - www.dehondt.localtest"; dig @192.168.1.210 mail.dehondt.localtest | grep -q "QUESTION" && echo -e "\e[32mOK\e[0m - mail.dehondt.localtest" || echo -e "\e[31mFAILED\e[0m - mail.dehondt.localtest"
```

![Image](/Images/W2P1-DNS-1.png)

### 👉Exercise 4: Configure DNS server as DNS server

- Open the configuration file for the DNS server
```bash
sudo nano /etc/resolv.conf
```

- Add the following configuration to the file
```bash
nameserver 192.168.1.210
```

> **NOTE:** Be aware it's possible to have multiple nameservers in the configuration file. But for this exercise, we only need one.

### 👉Exercise 5: Test forward lookup

- Test the forward lookup (Manual validation)
```bash
dig www.dehondt.localtest
nslookup www.dehondt.localtest
host www.dehondt.localtest
```

- Test the forward lookup (Automated validation)
```bash
clear && dig www.dehondt.localtest | grep -q "QUESTION" && echo -e "\e[32mOK\e[0m - www.dehondt.localtest (dig)" || echo -e "\e[31mFAILED\e[0m - www.dehondt.localtest"; nslookup www.dehondt.localtest | grep -q "142.250.179.142" && echo -e "\e[32mOK\e[0m - www.dehondt.localtest (nslookup)" || echo -e "\e[31mFAILED\e[0m - www.dehondt.localtest"; host www.dehondt.localtest | grep -q "142.250.179.142" && echo -e "\e[32mOK\e[0m - www.dehondt.localtest (host)" || echo -e "\e[31mFAILED\e[0m - www.dehondt.localtest"
```

![Image](/Images/W2P1-DNS-2.png)

### 👉Exercise 6: Test reverse lookup

- First, let's configure reverse DNS.
```bash
sudo nano /etc/bind/named.conf.local
```

- Add the following configuration to the file
```bash
zone "1.168.192.in-addr.arpa" {
        type master;
        file "/etc/bind/db.192.168.1";
};
```

- Create the zone file
```bash
sudo nano /etc/bind/db.192.168.1
```

- Add the following configuration to the file
```bash
$TTL    604800
@       IN      SOA     dehondt.localtest. root.dehondt.localtest. (
                              2         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;

; Name servers
@       IN      NS      dehondt.localtest.

; PTR records
210     IN      PTR     dehondt.localtest.
210     IN      PTR     mail.dehondt.localtest.
210     IN      PTR     www.dehondt.localtest.
```

- Restart the DNS server
```bash
sudo systemctl restart bind9
```

- Test the reverse lookup (Manual validation)
```bash
dig -x 192.168.1.210
nslookup 192.168.1.210
host 192.168.1.210
```

- Test the reverse lookup (Automated validation)
```bash
clear && dig -x 192.168.1.210 | grep -q "dehondt.localtest" && echo -e "\e[32mOK\e[0m - dig reverse lookup" || echo -e "\e[31mFAILED\e[0m - dig reverse lookup"; nslookup 192.168.1.210 | grep -q "dehondt.localtest" && echo -e "\e[32mOK\e[0m - nslookup" || echo -e "\e[31mFAILED\e[0m - nslookup"; host 192.168.1.210 | grep -q "dehondt.localtest" && echo -e "\e[32mOK\e[0m - host" || echo -e "\e[31mFAILED\e[0m - host"
```

![Image](/Images/W2P1-DNS-3.png)

### 👉Exercise 7: Configure ping via nameserver

- Open the configuration file for the nameserver
```bash
sudo nano /etc/nsswitch.conf
```

- Add the following configuration to the file
```bash
hosts:          files dns
```

- Test the ping via nameserver
```bash
ping www.dehondt.localtest
```

![Image](/Images/W2P1-DNS-4.png)

## 🔗Links
- 👯 Web hosting company [EliasDH.com](https://eliasdh.com).
- 📫 How to reach us elias.dehondt@outlook.com