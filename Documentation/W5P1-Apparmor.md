![logo](https://eliasdh.com/assets/media/images/logo-github.png)
# 💙🤍W5P1 Apparmor🤍💙

## 📘Table of Contents

1. [📘Table of Contents](#📘table-of-contents)
2. [📝Assignment](#📝assignment)
3. [✨Exercises](#✨exercises)
    1. [👉Exercise 0: Install necessary software packages](#👉exercise-0-install-necessary-software-packages)
    2. [👉Exercise 1: Download the mono program getstuff](#👉exercise-1-download-the-mono-program-getstuff)
    3. [👉Exercise 2: Create an apparmor profile for getstuff](#👉exercise-2-create-an-apparmor-profile-for-getstuff)
    4. [👉Exercise 3: Allow root to download to the directory `/root`](#👉exercise-3-allow-root-to-download-to-the-directory-root)
    5. [👉Exercise 4: Make sure that root can now also download to the `/root` directory.](#👉exercise-4-make-sure-that-root-can-now-also-download-to-the-root-directory)
4. [🔗Links](#🔗links)

---

### 📝Assignment 
> NOTE This is in Dutch

- **DOEL:** Aanmaken van een globaal apparmor profile

- **NODIG:** Ubuntu /Debian (mag zonder grafische interface)

- **REFERENTIES:**
    - [REF A](http://www.mono-project.com/docs/getting-started/application-deployment/)

- **Opmerking:** Je profiel opnieuw maken kan je door `sudo rm /etc/apparmor.d/usr.bin.getstuff` te gebruiken.

1. Download het mono programma `getstuff.exe`
    - Dit programma downloadt het python programma `httpserver.py`
    - Volg de Layout Recommendation vanuit `REF A` om dit als een regulier programma op je systeem te voorzien:
        - Maak de directory `/usr/lib/getstuff` aan
        - Copieer `getstuff.exe` naar `/usr/lib/getstuff/getstuff.exe`
        - Schrijf in `/usr/bin/getstuff` dat je `/usr/lib/gestuff/getstuff.exe` met mono opstart 
        - Maak `/usr/bin/getstuff` executable 

2. Maak als root een apparmor profiel aan voor getstuff `sudo aa-genprof /usr/bin/getstuff`
    - Start nu de applicatie
        - IN EEN ANDERE TERMINAL
        - ALS GEWONE GEBRUIKER. 
    - Doe dit vanuit de homedirectory van de gebruiker.
    - Het profiel werkt nu in complain mode
    - Kies Scan en duid alles aan wat je nodig hebt!
        - Let er op dat getstuff moet werken voor alle gebruikers!
        - Let op temp files en procesnummers
    - Finish (profiel werkt in enforce mode)

3. Doe sudo su en tik cd `/root`
    - Start nu het programma `getstuff` op als root.
    - De download mag niet meer lukken (kijk na of het bestand `httpserver.py` geschreven wordt)
    - Kijk na in `/var/log/audit/audit.log`

4. Zorg ervoor dat root nu ook kan downloaden naar de directory `/root`.

5. Maak, gelijkaardig aan `getstuff.exe`, volgens REF A een executable `/usr/bin/httpserver` voor `httpserver.py` aan.

6. Maak nu ook een apparmor profiel voor `/usr/bin/httpserver`. Let erop dat je ook uittest of je de httpserver kan bereiken vanuit je browser vanop `http://localhost:1234`

## ✨Exercises

### 👉Exercise 0: Install necessary software packages

- Install the necessary software packages
```bash
sudo apt-get update -y && sudo apt-get upgrade -y
sudo apt-get install apparmor-utils auditd mono-complete curl -y
```

### 👉Exercise 1: Download the mono program getstuff

- Download the mono program getstuff
```bash
sudo mkdir /usr/lib/getstuff
sudo curl -s https://raw.githubusercontent.com/EliasDeHondt/ComputerSystems3-ISB/main/source/getstuff.exe -o /usr/lib/getstuff/getstuff.exe
sudo chmod +x /usr/lib/getstuff/getstuff.exe
```

- Create the `/usr/bin/getstuff` file
```bash
sudo touch /usr/bin/getstuff
sudo bash -c 'cat << EOF > /usr/bin/getstuff
#!/bin/bash
mono /usr/lib/getstuff/getstuff.exe "$@"
EOF'
sudo chmod +x /usr/bin/getstuff
```

### 👉Exercise 2: Create an apparmor profile for getstuff

- Create an apparmor profile for getstuff ***(Terminal 1)***
```bash
sudo aa-genprof /usr/bin/getstuff
# Things you have to handle manually:
    # /dev/shm/mono.2627 to /dev/shm/mono.*
    # owner /proc/2627/maps r, to /proc/*/maps r,
    # owner /home/elias/ r, to /home/* r,
# These are not all of them, but you get the idea. And then S for seve and F for finish.
```

- Start the application ***(Terminal 2)***
```bash
cd ~
getstuff
```

- Reload the apparmor profile ***(Terminal 1)***
```bash
sudo apparmor_parser -r /etc/apparmor.d/usr.bin.getstuff
```

> **Note:** If you get a contradiction error make sure to fix the following:
```bash
sudo nano /etc/apparmor.d/usr.bin.getstuff
# Remove include <abstractions/evince> and include <abstractions/opencl-pocl>
```

### 👉Exercise 3: Allow root to download to the directory `/root`

- Allow root to download to the directory `/root`
```bash
sudo su
cd /root && getstuff
```

- Check the audit log
```bash
cat /var/log/audit/audit.log | grep getstuff
```

### 👉Exercise 4: Make sure that root can now also download to the `/root` directory.

- Make sure that root can now also download to the `/root` directory.
```bash
sudo aa-logprof # Allow all the necessary permissions
```

### 👉Exercise 5: Create an profile `/usr/bin/httpserver` for `httpserver.py`

- Download the httpserver.py file
```bash
sudo mkdir /usr/lib/httpserver
sudo curl -s https://raw.githubusercontent.com/EliasDeHondt/ComputerSystems3-ISB/main/source/httpserver.py -o /usr/lib/httpserver/httpserver.py
sudo chmod +x /usr/lib/httpserver/httpserver.py
```

- Create the `/usr/bin/httpserver` file
```bash
sudo touch /usr/bin/httpserver
sudo bash -c 'cat << EOF > /usr/bin/httpserver
#!/bin/bash
python3 /usr/lib/httpserver/httpserver.py
EOF'
sudo chmod +x /usr/bin/httpserver
```

- Create an apparmor profile for getstuff ***(Terminal 1)***
```bash
sudo aa-genprof /usr/bin/httpserver
```

- Start the application ***(Terminal 2)***
```bash
httpserver
```

- Check if you can reach the httpserver from your browser at `http://localhost:1234`

## 🔗Links
- 👯 Web hosting company [EliasDH.com](https://eliasdh.com).
- 📫 How to reach us elias.dehondt@outlook.com