![logo](https://eliasdh.com/assets/media/images/logo-github.png)
# 💙🤍W5P1 Ansible🤍💙

## 📘Table of Contents

1. [📘Table of Contents](#📘table-of-contents)
2. [📝Assignment](#📝assignment)
3. [✨Exercises](#✨exercises)
    1. [👉Exercise 1: Set up basic configuration](#👉exercise-1-set-up-basic-configuration)

4. [🔗Links](#🔗links)

---

### 📝Assignment 
> NOTE This is in Dutch

- **DOEL:** Configuratie Ansible

- **NODIG:** Twee Ubuntu >=22.04 LTS systemen ( grafische interface optioneel). Kies  minstens 2 processoren ! 

Een alternatieve opzet kan via een docker container als node. De mogelijke configuratie hiervan vind je in de bijlage.

1. Alle nodige pakketten
    - master: `sudo apt install ansible openssh-server`

2. Hostnames in /etc/hosts
    - Indien je geen ip adres gekregen hebt kan dit met het commando dhclient interfacenaam. Pas /etc/hosts aan door de naam en het ip adres van de master en de node(s) toe te voegen:
    ```bash	
    sudo nano /etc/hosts
    # 127.0.0.1 localhost
    # 192.168.57.100 master
    # 192.168.57.101 node1
    ```
    - De naam van je systeem zelf kan je als root aanpassen met het commando:
    ```bash
    hostnamectl set-hostname master
    ```

3. Gebruiker aanmaken voor Ansible
    - master: `groupadd ansible`
    - master: `useradd -m -u 1001 -g ansible ansible`
    - master: `echo ansible:supersecret| chpasswd -c SHA512`

4. IP adres bij login scherm
    ```bash
    #!/bin/bash
    echo '\S' > /etc/issue
    echo 'Kernel \r on an \m'>> /etc/issue
    ip a | grep -o '192.*/' >> /etc/issue
    cp /etc/issue /etc/issue.net
    ```

5. Passwordless on ssh
    - Dit commando doe je op de nodes en de master om ssh te gebruiken.
    ```bash
    sudo apt install openssh-server
    systemctl start sshd
    ```

6. Sleutel genereren
    - Voor de communicatie naar de nodes maken we gebruik van passwoordloze ssh. We loggen in met de nieuwe gebruiker op de master en genereren daar een RSA sleutelpaar. Je mag de default locatie behouden en GEEN paswoord ingeven.
    ```bash
    su - ansible
    ssh-keygen -t rsa
    ssh-copy-id node1
    ```

7. Uittesten SSH verbinding
    - Test of je kan inloggen op de node zonder paswoord.
    ```bash
    ssh node1
    exit
    ```


8. ANSIBLE COMMANDO'S ANSIBLE COMMANDO'S 
    - Test een shell commando uit op de node
    ```bash
    ansible all --inventory "node1," -m shell -a 'echo Ansible '
    ```
    - Schrijf de node in het hosts bestand /etc/ansible/hosts. 
    ```bash
    sudo nano /etc/ansible/hosts
    # [node]
    # node1
    ```
    - Je kan nu zonder --inventory of -i een commando uitvoeren op de shell op een host:
    ```bash
    ansible all -m shell -a 'echo Ansible op ;hostname'
    ```
    - Je kan nu met ansible een ping uitvoeren naar je node. 
    ```bash
    ansible all -m ping
    ```
    - De uptime van de nodes opvragen
    ```bash
    ansible all -m shell -a 'uptime'
    ```
    - Standaard heeft de ansible gebruiker geen rechten om als root iets aan te passen. Voer als root op de node volgend commando uit
    ```bash
    echo "ansible ALL=(ALL) NOPASSWD: ALL"> /etc/sudoers.d/ansi
    ```
    - Normaal gebruik je geen sudo commando om aan te geven dat je dingen als root gaar doen.  Optie --become of -b is om root te worden.
    ```bash
    ansible all -m shell -a 'sudo whoami'
    ansible --become all -m shell -a 'whoami'
    ```
    - Installeren met apt
    ```bash
    ansible all -b -m apt -a "name=stress state=present"
    ansible all -b -m apt -a "name=htop state=present"
    ansible all -m shell -a 'stress --cpu 2 --timeout 30s'
    ansible all -b -m apt -a "name=htop state=absent"
    ```
    - Ansible copy Voer volgende commando's uit op de master in het tekstbestand cmd.sh. Rechten worden overgenomen van de source. Je kan ze ook instellen met de mode parameter.
    ```bash
    echo '#!/bin/bash' > cmd.sh
    echo 'echo Hello world' >> cmd.sh
    echo 'ip a|grep -o 172.*/|cut -d/ -f1' >> cmd.sh
    ansible all -m copy -a 'src=cmd.sh dest=cmd.sh'
    ansible all -m shell -a './cmd.sh'
    ansible all -m copy -a 'src=cmd.sh dest=cmd.sh mode=755'
    ansible all -m shell -a './cmd.sh'
    ```
    - Soms willen we in bestanden variabelen at runtime aanpassen. Om dat te doen hebben we templates nodig. Templates worden in jinja2 geschreven. Variabelen worden ingesloten in dubbele accolades. Maak het bestand cmd-template.sh.j2 met volgende inhoud:
    ```bash
    #!/bin/bash
    echo {{ bericht }}
    ip a|grep -o 172.*/|cut -d/ -f1
    ```
    - Je kan met de module template de variabelen in de template invullen bij het "copieren".  Bij een shellscript zoals hier, geef je best executable rechten mee, zodat het script kan opgestart worden.
    ```bash
    ansible all -m template -a "src=cmd-template.sh.j2 dest=cmd template.sh mode=755" -e "bericht=Hello"
    ansible all -m shell -a './cmd-template.sh'
    ```
    - Ansible kan gebruik maken van rsync om bestanden te synchroniseren tussen source en destination.
    ```bash
    ansible all -b -m apt -a "name=rsync state=present"
    ansible all -m synchronize -a 'src=cmd.sh dest=cmd.sh'
    ```
    - Bestanden kunnen ook vanuit een url binnengehaald worden
    ```bash
    ansible all -m get_url -a "url='https://github.com/luckylittle/ansible-cheatsheet/blob/master/ansible-cheatsheet.txt' dest=."
    ansible all -m shell -a 'ls -al *.txt'
    ```
    - Bestanden kunnen ook vanuit een git repo binnengehaald worden Package git en tree (optioneel) installeren met apt:
    ```bash
    ansible all -b -m apt -a "name=git,tree state=present"
    ansible all -m git -a "repo=https://github.com/luckylittle/ansible-cheatsheet.git dest=./cheatsheet"
    ansible all -m shell -a 'tree cheat*'
    ```


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