![logo](https://eliasdh.com/assets/media/images/logo-github.png)
# 💙🤍W5P1 Ansible🤍💙

## 📘Table of Contents

1. [📘Table of Contents](#📘table-of-contents)
2. [📝Assignment](#📝assignment)
3. [✨Exercises](#✨exercises)
    1. [👉Exercise 1: Set up basic configuration](#👉exercise-1-set-up-basic-configuration)
    2. [👉Exercise 2: Passwordless SSH](#👉exercise-2-passwordless-ssh)
    3. [👉Exercise 3: Assignment config](#👉exercise-3-assignment-config)
4. [🔗Links](#🔗links)

---

### 📝Assignment 
> NOTE This is in Dutch

- **DOEL:** Configuratie Ansible

- **NODIG:** Twee Ubuntu 24.04 LTS systemen. Kies minstens 2 processoren! 

- Schrijf een `ansible playbook` dat gebruik maakt van een `role`. Voorzie hiervoor de juiste directorystructuur.
- Volgende taken worden uitgevoerd op een node met standaard `ubuntu 24.04`:
    - Installeren van `nginx`, opstarten als service en ook na reboot.
    - Verzekeren dat er geen `apache2` op staat of kan opstarten.
    - Aanpassen van de standaard website met een custom `html` pagina vanuit een template met volgende facts: `hostname`, `ip adres`, `processor` en `RAM`.
    - Installeren van mogelijk extra software die je nodig hebt
    - Schrijven en draaien van een script op de node dat nakijkt of de website draait op poort `80` draait de website, dan toon je `Running`, anders toon je `Not Running`.
    - Zorg dat alle `yml` files voldoen aan `ansible-lint`.
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

- Set default shell to bash for the `ansible` user.
```bash
sudo usermod -s /bin/bash ansible # On both
```

- Set the `ansible` user to have sudo privileges without a password.
```bash
sudo bash -c 'echo "ansible ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/ansible' # On both
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
sudo apt install openssh-server ansible-core -y # On both
sudo apt install ansible-lint -y
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

## 👉Exercise 3: Assignment config

```plaintext
/etc/ansible/
├── playbook-main.yml
├── remove-main.yml
├── roles/
│   └── nginx/
│       ├── meta/
│       │   └── main.yml
│       ├── tasks/
│       │   └── tasks-main.yml
│       └── templates/
│           └── index.html.j2
```

- Create a new directory for the Ansible configuration.
```bash
sudo mkdir /etc/ansible # On master
```

- Create a new inventory file.
```bash
sudo touch /etc/ansible/hosts # On master
sudo bash -c 'echo -e "[nodes]\nnode1" >> /etc/ansible/hosts' # On master
```

- Create a new [playbook file](/Scripts/Ansible/playbook-main.yml).
```bash
sudo curl -s https://raw.githubusercontent.com/EliasDeHondt/ComputerSystems3-ISB/main/Scripts/Ansible/playbook-main.yml -o /etc/ansible/playbook-main.yml # On master
```

- The [playbook file](/Scripts/Ansible/playbook-main.yml) look like this:
```yml
---
- name: Setup Nginx
  hosts: node1
  become: true
  gather_facts: true
  tasks:
    - import_tasks: roles/nginx/tasks/tasks-main.yml
```

- Create a new role.
```bash
sudo mkdir /etc/ansible/roles # On master
sudo ansible-galaxy init /etc/ansible/roles/nginx # On master
```

- Create a new [task file](/Scripts/Ansible/tasks-/main.yml).
```bash
sudo curl -s https://raw.githubusercontent.com/EliasDeHondt/ComputerSystems3-ISB/main/Scripts/Ansible/tasks-main.yml -o /etc/ansible/roles/nginx/tasks/tasks-main.yml # On master
```

- The [task file](/Scripts/Ansible/tasks-main.yml) look like this:
```yml
---
- name: Install Nginx
  ansible.builtin.apt:
    name: nginx
    state: present

- name: Start Nginx
  ansible.builtin.service:
    name: nginx
    state: started
    enabled: true

- name: Ensure Apache2 is not installed
  ansible.builtin.apt:
    name: apache2
    state: absent

- name: Copy custom HTML file
  ansible.builtin.template:
    src: /etc/ansible/roles/nginx/templates/index.html.j2
    dest: /var/www/html/index.html
    mode: '0644' # File permissions

- name: Check if website is running
  ansible.builtin.shell: |
    #!/bin/bash
    if curl -s --head  http://localhost:80 | grep "200 OK" > /dev/null; then
      echo "Running"
    else
      echo "Not Running"
    fi
  register: website
  ignore_errors: true

- name: Show status
  ansible.builtin.debug:
    msg: "Website is running"
  when: website.rc == 0

- name: Show status
  ansible.builtin.debug:
    msg: "Website is not running"
  when: website.rc != 0
```

- Create a new [template file](/Scripts/Ansible/index.html.j2).
```bash
sudo curl -s https://raw.githubusercontent.com/EliasDeHondt/ComputerSystems3-ISB/main/Scripts/Ansible/index.html.j2 -o /etc/ansible/roles/nginx/templates/index.html.j2 # On master
```

- The [template file](/Scripts/Ansible/index.html.j2) look like this:
```html
<!DOCTYPE html>
<!--Author Elias De Hondt-->
<html>
  <head>
      <title>Computer Systems 3</title>
  </head>
  <body>
      <h1>Welcome</h1>
      <p>IP address: {{ ansible_default_ipv4.address }}</p>
      <p>Processor: {{ ansible_processor[1] }}</p>
      <p>RAM: {{ ansible_memtotal_mb }} MB</p>
  </body>
</html>
```

- Replace the `main.yml` file in the `meta` directory of the `nginx` role.
```bash
sudo rm /etc/ansible/roles/nginx/meta/main.yml # On master
sudo curl -s https://raw.githubusercontent.com/EliasDeHondt/ComputerSystems3-ISB/main/Scripts/Ansible/main.yml -o /etc/ansible/roles/nginx/meta/main.yml # On master
```

- Test the yml files with `ansible-lint`.
```bash
ansible-lint /etc/ansible/playbook-main.yml # On master
ansible-lint /etc/ansible/roles/nginx/tasks/tasks-main.yml # On master
```

- Run the playbook.
```bash
ansible-playbook /etc/ansible/playbooks/playbook-main.yml # On master
```

- Test the website (should be running).
```bash
curl http://localhost:80 # On node1
```

- Create a new [playbook file](/Scripts/Ansible/remove-main.yml).
```bash
sudo curl -s https://raw.githubusercontent.com/EliasDeHondt/ComputerSystems3-ISB/main/Scripts/Ansible/remove-main.yml -o /etc/ansible/remove-main.yml # On master
```

- The [playbook file](/Scripts/Ansible/remove-main.yml) look like this:
```yml
---
- name: Remove Nginx
  hosts: node1
  become: true
  gather_facts: true
  tasks:
    - name: Stop Nginx
      ansible.builtin.service:
        name: nginx
        state: stopped
        enabled: false
    - name: Remove Nginx
      ansible.builtin.apt:
        name: nginx
        state: absent
    - name: Remove custom HTML file
      ansible.builtin.file:
        path: /var/www/html/index.html
        state: absent
```

- Test the yml files with `ansible-lint`.
```bash
ansible-lint /etc/ansible/remove-main.yml # On master
```

- Run the playbook.
```bash
ansible-playbook /etc/ansible/remove-main.yml # On master
```

- Test the website (should not be running).
```bash
curl http://localhost:80 # On node1
```

## 🔗Links
- 👯 Web hosting company [EliasDH.com](https://eliasdh.com).
- 📫 How to reach us elias.dehondt@outlook.com