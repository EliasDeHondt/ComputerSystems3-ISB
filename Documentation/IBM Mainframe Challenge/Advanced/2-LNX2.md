![logo](https://eliasdh.com/assets/media/images/logo-github.png)
# 💙🤍2 LNX2🤍💙

## 📘Table of Contents

1. [📘Table of Contents](#📘table-of-contents)
2. [📚Reference](#📚reference)
3. [✨Steps](#✨steps)
    1. [👉Step 1: Connect through SSH](#👉step-1-connect-through-ssh)
    2. [👉Step 2: Install the web server](#👉step-2-install-the-web-server)
    3. [👉Step 3: Firewall](#👉step-3-firewall)
    4. [👉Step 4: Testing](#👉step-4-testing)
    5. [👉Step 5: Let's build a game](#👉step-5-lets-build-a-game)
    6. [👉Step 6: Finished](#👉step-6-finished)
4. [🔗Links](#🔗links)

---

## 📚Reference

- [📚IBM Mainframe Challenge](https://ibmzxplore-static.s3.eu-gb.cloud-object-storage.appdomain.cloud/LNX2.pdf)

![IBM Fundamentals](/Images/IBM-Advanced.png)

## ✨Steps

### 👉Step 1: Connect through SSH

- Open a terminal.
- Run the following command to connect to the USS server:
  ```bash
  ssh user@ipaddress
  ```

### 👉Step 2: Install the web server

- Run the following command to install the Apache web server:
    ```bash
    yum search apache
    # Or for ubuntu
    apt search apache
    ```

- Run the following command to install the Apache web server:
    ```bash
    sudo yum install httpd.s390x
    # Or for ubuntu
    sudo apt install apache2
    ```

- Run the following command to start the Apache web server:
    ```bash
    sudo systemctl start httpd
    # Or for ubuntu
    sudo systemctl start apache2
    ```

- Create a simple HTML file:
    ```bash
    sudo rm /var/www/html/index.html
    sudo curl -s https://raw.githubusercontent.com/EliasDeHondt/ComputerSystems3-ISB/main/Html/index.html -o /var/www/index.html
    ```

- Create a configuration file and enable:
    - Remove the default configuration files:
    ```bash
    sudo rm /etc/apache2/sites-available/000-default.conf
    sudo rm /etc/apache2/sites-available/default-ssl.conf
    sudo nano /etc/apache2/sites-available/default.conf
    ```
    - Add the following content:
    ```apache
    <VirtualHost *:80>
        DocumentRoot /var/www/html
        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined
    </VirtualHost>
    ```
    - Enable the site:
    ```bash
    sudo a2ensite default
    sudo systemctl reload apache2
    ```

### 👉Step 3: Firewall

- Open firewall for Z/Os
    ```bash
    sudo systemctl start firewalld
    sudo firewall-cmd --zone=public --add-port=80/tcp --permanent
    sudo firewall-cmd --reload
    sudo systemctl enable firewalld
    ```
- Open firewall for Ubuntu
    ```bash
    sudo ufw allow 80/tcp
    ```

### 👉Step 4: Testing

- Open a browser and navigate to `http://ipaddress`
- Open the log files:
    ```bash
    sudo tail -f /var/log/apache2/access.log
    sudo tail -f /var/log/apache2/error.log
    ```

### 👉Step 5: Let's build a game

- Download the game files:
    ```bash
    curl -LO https://github.com/vicgeralds/vitetris/archive/v0.58.0.tar.gz
    ```
- Extract the files:
    ```bash
    tar -xvf v0.58.0.tar.gz
    ```
- Install the build dependencies:
    ```bash
    yum install make gcc
    # Or for ubuntu
    apt install make gcc
    ```
- Build the game:
    ```bash
    cd vitetris-0.58.0
    make
    ```
- Run the game:
    ```bash
    ./tetris
    ```

### 👉Step 6: Finished

- You mark this challenge completed by running another curl command:
```bash
curl -X POST -d email={your-ibmzxplore-email} http://192.86.32.12:1880/LNX2
```

## 🔗Links
- 👯 Web hosting company [EliasDH.com](https://eliasdh.com).
- 📫 How to reach us elias.dehondt@outlook.com