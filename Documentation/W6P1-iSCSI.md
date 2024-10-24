![logo](https://eliasdh.com/assets/media/images/logo-github.png)
# 💙🤍W6P1 iSCSI🤍💙

## 📘Table of Contents

1. [📘Table of Contents](#📘table-of-contents)
2. [📝Assignment](#📝assignment)
3. [✨Exercises](#✨exercises)
    1. [👉Exercise 0: Install necessary software packages](#👉exercise-0-install-necessary-software-packages)

4. [🔗Links](#🔗links)

---

### 📝Assignment 
> NOTE This is in Dutch

- **DOEL:**  Configuratie iSCSI 

- **NODIG:** 2 Ubuntu 24.04 server systemen (zonder GUI)

- Herstarten ssh en permanent voorzien: 
    ```bash
    sudo systemctl restart ssh
    sudo systemctl enable ssh
    ```
- Firewall voor ssh open: 
    ```bash
    sudo ufw allow 22/tcp
    sudo ufw enable
    sudo ufw reload
    ```

1. ISCSI TARGET
    - Target iSCSI configureren
    ```bash
    apt install openssh-server targetcli-fb -y 
    apt remove tgt -y                               # vloekt met targetcli
    mkdir -p /iscsi
    ```
    - In dit voorbeeld gebruiken we FileIO (een schijfbestand of image) en maken twee stores aan. Eén voor data en de andere voor fencing:
    ```bash
    targetcli
    cd backstores/fileio
    create datadisk /iscsi/data1.img 550M
    cd /iscsi
    create iqn.2024-10.be.kdg:data1
    ```
    - Aanmaken van een LUN in targetcli:
    ```bash
    cd iqn.2024-10.be.kdg:data1/tpg1/luns
    create /backstores/fileio/datadisk
    ```
    - Bij de Access Control List kan je instellen welke initiator is toegelaten. Enkel die naam krijgt toegang. In het voorbeeld hieronder is dat iqn.`2024-10.be.kdg:init1`. Meestal wordt ook een eenvoudige chap authenticatie ingesteld met een username en password.
    ```bash
    cd /iscsi/iqn.2024-10.be.kdg:data1/tpg1/acls
    create iqn.2024-10.be.kdg:init1
    exit
    ```
    - Bekijken instellingen:
    ```bash
    cd /iscsi
    cd /iscsi/
    ls
    systemctl --type=service | grep target rtslib-fb-targetctl.service
    systemctl enable rtslib-fb-targetctl
    targetcli saveconfig /root/target.json
    targetcli restoreconfig /root/target.json
    ```
    - Instellen firewall:
    ```bash
    ufw allow 3260/tcp
    ufw reload
    ```
    - Troubleshoot target:
    ```bash
    ss -napt | grep 3260
    ```

2. ISCSI INITIATOR
    - **Doe dit op de node !**
    ```bash
    apt install openssh open-iscsi -y
    iscsiadm -m discovery -t sendtargets -p 192.168.57.100 # IP van de target
    ```
    - In het bestand /etc/iscsi/initiatorname.iscsi geef je de juiste initiator naam:
    ```bash
    InitiatorName=iqn.2022-10.be.kdg:init1
    systemctl restart iscsid
    iscsiadm --mode node --targetname iqn.2022-10.be.kdg:data1--portal 192.168.57.100 --login
    iscsiadm --mode session show
    ```
    - Het programma fdisk geeft nu 1extra schijf:
    ```bash
    fdisk -l
    ```

3. OPDRACHT ISCSI
    - Zorg ervoor dat de iscsi schijf beschikbaar wordt voor een webserver (dat mag de node/initiator zijn) vanuit de directory /www.
    - Plaats hierin een test html pagina /www/index.html.
    - Test eerst de webserver uit door manueel de schijf te mappen.
    - Zorg ervoor dat de webserver automatisch bij het opstarten de iscsi schijf gaat mappen.
    - Je mag er initieel van uitgaan dat de iscsi target al is opgestart.
    - Enkele mogelijke commando's bij problemen:
    ```bash
    iscsiadm -m session --rescan
    iscsiadm --mode node --targetname iqn.2022-10.be.kdg:data--portal target --logout
    ```

## ✨Exercises

### 👉Exercise 0: Install necessary software packages

- Install the necessary software packages
```bash
sudo apt-get update -y && sudo apt-get upgrade -y
sudo apt install openssh-server targetcli-fb # Target
sudo apt install openssh-server open-iscsi lvm2 # Node
```

### 👉Exercise 1: Set up basic configuration

> **Note:** `Target` and `Node` are Ubuntu Server 24.04 LTS.

> **Note:** Internal IP addresses of target: `10.2.0.254` and IP of node: `10.2.0.1`.

> **Note:** External IP addresses of target: `192.168.70.155` and IP of node: `192.168.70.156`.

- Set time zone to `Europe/Brussels` on both servers.
```bash
sudo timedatectl set-timezone Europe/Brussels # On both
```

- Configure the network interfaces of the `Target` and `Node`.
```bash
sudo nano /etc/netplan/01-netcfg.yaml # On both
```
```yaml
network:
  version: 2
  ethernets:
    ens34:
      dhcp4: no
      dhcp6: no
      addresses:
        - 10.2.0.254/24 # For Target
        - 10.2.0.1/24 # For Node
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

- Set the hostname of the Target to `Target` and the hostname of the Node to `Node`.
```bash
sudo hostnamectl set-hostname target # On Target
sudo hostnamectl set-hostname node # On Node
```

- Add the hostnames to the `/etc/hosts` file.
```bash
echo -e "127.0.0.1 localhost\n10.2.0.254 target\n10.2.0.1 node" | sudo tee /etc/hosts > /dev/null # On both
```

- Restart the SSH service and enable it to start on boot.
```bash
sudo systemctl restart ssh # On both
sudo systemctl enable ssh # On both
```

- Open the firewall for SSH.
```bash
sudo ufw allow 22/tcp # On both
sudo ufw enable # On both
sudo ufw reload # On both
```

- Reboot the servers.
```bash
sudo reboot # On both
```

### 👉Exercise 2: Set up iSCSI Target














## 🔗Links
- 👯 Web hosting company [EliasDH.com](https://eliasdh.com).
- 📫 How to reach us elias.dehondt@outlook.com