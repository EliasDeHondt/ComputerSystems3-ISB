![logo](https://eliasdh.com/assets/media/images/logo-github.png)
# 💙🤍W5P1 Ansible🤍💙

## 📘Table of Contents

1. [📘Table of Contents](#📘table-of-contents)
2. [📝Assignment](#📝assignment)
3. [✨Exercises](#✨exercises)
    1. [👉Exercise 1: Set up basic configuration](#👉exercise-1-set-up-basic-configuration)
    2. [👉Exercise 2: Passwordless SSH](#👉exercise-2-passwordless-ssh)

4. [🔗Links](#🔗links)

---

### 📝Assignment 
> NOTE This is in Dutch

- **DOEL:** Configuratie Ansible

- **NODIG:** Twee Ubuntu 24.04 LTS systemen. Kies minstens 2 processoren! 

- Schrijf een ansible playbook dat gebruik maakt van een role. Voorzie hiervoor de juiste directorystructuur.
- Volgende taken worden uitgevoerd op een node met standaard ubuntu 24.04:
    - Installeren van `nginx`, opstarten als service en ook na reboot
    - Verzekeren dat er geen `apache2` op staat of kan opstarten
    - Aanpassen van de standaard website met een custom `html` pagina vanuit een template met volgende facts: `hostname`, `ip adres`, `processor` en `RAM`
    - Installeren van mogelijk extra software die je nodig hebt
    - Schrijven en draaien van een script op de node dat nakijkt of de website draait op poort `80`
    - Draait de website, dan toon je `Running`, anders toon je `Not Running`
    - Zorg dat alle `yml` files voldoen aan ansible-lint
- Maak ook een playbook waarin alles gestopt en verwijderd wordt

## ✨Exercises

### 👉Exercise 1: Set up basic configuration
> **Note:** `master` and `node1` are Ubuntu Server 24.04 LTS.

> **Note:** Internal IP addresses of the master: `10.0.0.254` and IP of the node1: `10.0.0.1`.

> **Note:** External IP addresses of the master: `192.168.70.151` and IP of the node1: `192.168.70.152`.

- Update and upgrade the systems:
```bash
sudo apt update -y && sudo apt upgrade -y # On both
```

- Configure the network interfaces of the `master` and `node1`.
```bash
sudo nano /etc/netplan/01-netcfg.yaml # On both
```
```yaml
network:
  version: 2
  ethernets:
    ens34:
      dhcp4: no
      addresses:
        - 10.0.0.254/24 # For master
        - 10.0.0.1/24   # For node1
      nameservers:
        addresses:
          - 8.8.8.8
          - 8.8.4.4
```
```bash
sudo chmod 600 /etc/netplan/01-netcfg.yaml # On both
sudo netplan apply # On both
```

- Set the hostname of the master to `master` and the hostname of the node1 to `node1`.
```bash
sudo hostnamectl set-hostname master # On master
sudo hostnamectl set-hostname node1 # On node1
```

- Add the hostnames to the `/etc/hosts` file.
```bash
echo -e "127.0.0.1 localhost\n10.0.0.254 master\n10.0.0.1 node1" | sudo tee /etc/hosts > /dev/null # On both
```

- Create a new user `ansible` with password `supersecret`.
```bash
sudo groupadd ansible # both
sudo useradd -m -u 1001 -g ansible ansible # both
sudo bash -c 'sudo echo ansible:supersecret | chpasswd -c SHA512' # both
```

- IP address and username are shown when logging in with SSH **(On both)**:
```bash
sudo bash -c 'echo "Banner /etc/motd" >> /etc/ssh/sshd_config'
sudo touch /etc/motd
sudo chmod -x /etc/update-motd.d/*
sudo systemctl restart ssh.service
sudo su - ansible -c 'cat <<EOF > /home/ansible/show_info.sh
#!/bin/bash
echo "Welcome: \$(whoami)!" | sudo tee /etc/motd
echo "Hostname: \$(hostname)" | sudo tee -a /etc/motd
echo "IP address: \$(ip addr show ens34 | awk '\''/inet / {print \$2}'\'' | cut -d'\''/'\'' -f1)" | sudo tee -a /etc/motd
echo "Date: \$(date)" | sudo tee -a /etc/motd
echo "Kernel: \$(uname -r)" | sudo tee -a /etc/motd
echo -e "\n\n" | sudo tee -a /etc/motd
EOF'
sudo su - ansible -c 'chmod +x /home/ansible/show_info.sh'
sudo su - ansible -c 'echo "/home/ansible/show_info.sh" >> /home/ansible/.bashrc'
```

### 👉Exercise 2: Passwordless SSH

- Install the openssh-server on both systems.
```bash
sudo apt install openssh-server -y # On both
sudo systemctl start ssh # On both
```

- Generate a new ssh key pair for the `ansible` user.
```bash
sudo su - ansible # On master
ssh-keygen -t rsa # On master
    # Default location and no password
ssh-copy-id node1 # On master
    # Type yes
    # Enter the password of the ansible user
```

- Test the ssh connection.
```bash
ssh node1 # On master
exit # On master
```















## 🔗Links
- 👯 Web hosting company [EliasDH.com](https://eliasdh.com).
- 📫 How to reach us elias.dehondt@outlook.com