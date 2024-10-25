![logo](https://eliasdh.com/assets/media/images/logo-github.png)
# 💙🤍W6P1 iSCSI🤍💙

## 📘Table of Contents

1. [📘Table of Contents](#📘table-of-contents)
2. [📝Assignment](#📝assignment)
3. [✨Exercises](#✨exercises)
    1. [👉Exercise 0: Install necessary software packages](#👉exercise-0-install-necessary-software-packages)
    2. [👉Exercise 1: Set up basic configuration](#👉exercise-1-set-up-basic-configuration)
    3. [👉Exercise 2: Set up iSCSI Target](#👉exercise-2-set-up-iscsi-target)
    4. [👉Exercise 3: Set up iSCSI Initiator/Node](#👉exercise-3-set-up-iscsi-initiatornode)
    5. [👉Exercise 4: Set up iSCSI Target for Web Server](#👉exercise-4-set-up-iscsi-target-for-web-server)
4. [🔗Links](#🔗links)

---

### 📝Assignment 
> NOTE This is in Dutch

- **DOEL:**  Configuratie iSCSI 

- **NODIG:** 2 Ubuntu 24.04 server systemen (zonder GUI)

- ***Target = Initiator***

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
    - Bij de Access Control List kan je instellen welke initiator is toegelaten. Enkel die naam krijgt toegang. In het voorbeeld hieronder is dat `iqn.2024-10.be.kdg:init1`. Meestal wordt ook een eenvoudige chap authenticatie ingesteld met een username en password.
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
    - In het bestand /etc/iscsi/initiatorname.iscsi geef je de juiste initiator naam `InitiatorName=iqn.2024-10.be.kdg:init1`:
    ```bash
    systemctl restart iscsid
    iscsiadm --mode node --targetname iqn.2024-10.be.kdg:data1--portal 192.168.57.100 --login
    iscsiadm --mode session show
    ```
    - Het programma fdisk geeft nu 1extra schijf:
    ```bash
    fdisk -l
    ```

3. OPDRACHT ISCSI
    - Zorg ervoor dat de iscsi schijf beschikbaar wordt voor een webserver (dat mag de node/initiator zijn) vanuit de directory /www.
    - Plaats hierin een test html pagina `/www/index.html`.
    - Test eerst de webserver uit door manueel de schijf te mappen.
    - Zorg ervoor dat de webserver automatisch bij het opstarten de iscsi schijf gaat mappen.
    - Je mag er initieel van uitgaan dat de iscsi target al is opgestart.
    - Enkele mogelijke commando's bij problemen:
    ```bash
    iscsiadm -m session --rescan
    iscsiadm --mode node --targetname iqn.2024-10.be.kdg:data--portal target --logout
    ```

## ✨Exercises

### 👉Exercise 0: Install necessary software packages

- Install the necessary software packages
```bash
sudo apt-get update -y && sudo apt-get upgrade -y
sudo apt install openssh-server targetcli-fb -y # Target
sudo apt install openssh-server open-iscsi lvm2 -y # Node
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

- Create a directory for the iSCSI target.
```bash
sudo mkdir -p /iscsi # On Target
```

- Remove the `tgt` package as it conflicts with `targetcli`.
```bash
sudo apt remove tgt -y # On Target
```

- Create a file for the iSCSI target.
```bash
sudo targetcli # On Target
# exit
```
```bash
cd backstores/fileio # On Target
create datadisk /iscsi/data1.img 550M # On Target
cd /iscsi # On Target
create iqn.2024-10.be.kdg:data1 # On Target
```

- Create a LUN in `targetcli`.
```bash
cd iqn.2024-10.be.kdg:data1/tpg1/luns # On Target
create /backstores/fileio/datadisk # On Target
```

- Set up the Access Control List.
```bash
cd /iscsi/iqn.2024-10.be.kdg:data1/tpg1/acls # On Target
create iqn.2024-10.be.kdg:init1 # On Target
exit # On Target
```

- View the settings.
```bash
sudo targetcli # On Target
cd /iscsi # On Target
ls # On Target
sudo systemctl --type=service | grep target # On Target
sudo systemctl enable rtslib-fb-targetctl # On Target
sudo targetcli saveconfig /root/target.json # On Target
# sudo targetcli restoreconfig /root/target.json # (This is to restore the configuration) # On Target
```

![Image](/Images/W6P1-iSCSI-1.png)

- Set up the firewall.
```bash
sudo ufw allow 3260/tcp # On Target
sudo ufw reload # On Target
```

- Troubleshoot the target.
```bash
ss -napt | grep 3260 # On Target
```

### 👉Exercise 3: Set up iSCSI Initiator/Node

- Discover the target.
```bash
sudo iscsiadm -m discovery -t sendtargets -p 10.2.0.254 # On Node
```

- Set the initiator name in the `/etc/iscsi/initiatorname.iscsi` file.
```bash
echo "InitiatorName=iqn.2024-10.be.kdg:init1" | sudo tee /etc/iscsi/initiatorname.iscsi > /dev/null # On Node
```

- Restart the `iscsid` service.
```bash
sudo systemctl restart iscsid # On Node
```

- Login to the target.
```bash
sudo iscsiadm --mode node --targetname iqn.2024-10.be.kdg:data1 --portal 10.2.0.254 --login # On Node
# sudo iscsiadm --mode node --targetname iqn.2024-10.be.kdg:data1 --portal 10.2.0.254 --logout # On Node
```

- Show the session.
```bash
sudo iscsiadm --mode session show # On Node
```

- Show the extra disk.
```bash
sudo lsblk # On Node
```

- Format the disk.
```bash
sudo mkfs.ext4 /dev/sdb # On Node
```

- Mount the disk.
```bash
sudo mkdir /mnt/data # On Node
sudo mount /dev/sdb /mnt # On Node
```

- Add the disk to the `/etc/fstab` file.
```bash
echo "/dev/sdb /mnt ext4 defaults 0 0" | sudo tee -a /etc/fstab > /dev/null # On Node
```

- Reboot the server.
```bash
sudo reboot # On Node
```

- Show the extra disk.
```bash
sudo lsblk # On Node
```

### 👉Exercise 4: Set up iSCSI Target for Web Server

> **Note:** The web server is on the Node server. All the commands will be in script form for the target.

- Run the following [script](/Scripts/setUpiSCSIWebDisk.sh) on the target.
```bash
bash <(curl -s https://raw.githubusercontent.com/EliasDeHondt/ComputerSystems3-ISB/main/Scripts/setUpiSCSIWebDisk.sh) -c webDisk 1G # On Target
# bash <(curl -s https://raw.githubusercontent.com/EliasDeHondt/ComputerSystems3-ISB/main/Scripts/setUpiSCSIWebDisk.sh) -r webDisk 1G # On Target
```

- Run the following command on the Node server.
```bash
sudo apt install apache2 -y # On Node
sudo systemctl status apache2 # On Node
sudo ufw allow 80/tcp # On Node
sudo ufw reload # On Node
sudo rm /var/www/html/index.html # On Node
sudo iscsiadm -m discovery -t sendtargets -p 10.2.0.254
echo "InitiatorName=iqn.2024-10.be.kdg:init1" | sudo tee /etc/iscsi/initiatorname.iscsi > /dev/null # On Node
sudo systemctl restart iscsid # On Node
sudo iscsiadm --mode node --targetname iqn.2024-10.be.kdg:webdisk --portal 10.2.0.254 --login
sudo mkfs.ext4 /dev/sdb # On Node
sudo mkdir /etc/www/html/ # On Node
sudo mount /dev/sdb /var/www/html/ # On Node
sudo curl -s https://raw.githubusercontent.com/EliasDeHondt/ComputerSystems3-ISB/main/html/index.html -o /var/www/html/index.html
```

- Open the web server.
```bash
curl -s http://10.2.0.1 # On Node
```

- Unmount the disk to test the web server.
```bash
sudo umount /var/www/html/ # On Node
curl -s http://10.2.0.1 # On Node (This should not work)
```

- How to automatically mount the disk on boot.
```bash
echo "/dev/sdb /var/www/html ext4 defaults 0 0" | sudo tee -a /etc/fstab > /dev/null # On Node
sudo reboot # On Node
```

## 🔗Links
- 👯 Web hosting company [EliasDH.com](https://eliasdh.com).
- 📫 How to reach us elias.dehondt@outlook.com