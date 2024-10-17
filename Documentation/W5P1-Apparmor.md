![logo](https://eliasdh.com/assets/media/images/logo-github.png)
# 💙🤍W4P1 Scapy🤍💙

## 📘Table of Contents

1. [📘Table of Contents](#📘table-of-contents)
2. [📝Assignment](#📝assignment)
3. [✨Exercises](#✨exercises)
    1. [👉Exercise 0: Install necessary software packages](#👉exercise-0-install-necessary-software-packages)

4. [🔗Links](#🔗links)

---

### 📝Assignment 
> NOTE This is in Dutch

- **DOEL:** Aanmaken van een globaal apparmor profile

- **NODIG:** Ubuntu /Debian (mag zonder grafische interface)

- **REFERENTIES:**
    - [REF A](http://www.mono-project.com/docs/getting-started/application-deployment/)

1. Download het mono programma `getstuff.exe`
    - Dit programma downloadt het python programma `httpserver.py`
    - Volg de Layout Recommendation vanuit `REF A` om dit als een regulier programma op je systeem te voorzien:
        - maak de directory `/usr/lib/getstuff` aan
        - copieer `getstuff.exe` naar `/usr/lib/getstuff/getstuff.exe`
        - schrijf in `/usr/bin/getstuff` dat je `/usr/lib/gestuff/getstuff.exe` met mono opstart 
        - maak `/usr/bin/getstuff` executable 

2. Maak als root een apparmor profiel aan voor getstuff
    - sudo aa-genprof `/usr/bin/getstuff`
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
    - Start nu het programma getstuff op als root.
    - De download mag niet meer lukken (kijk na of het bestand `httpserver.py` geschreven wordt)
    - Kijk na in `/var/log/audit/audit.log`

4. Zorg ervoor dat root nu ook kan downloaden naar de directory /root

5. Maak, gelijkaardig aan getstuff.exe, volgens REF1 een executable /usr/bin/httpserver voor httpserver.py aan. (deze draait niet met mono maar met python3)

6. Maak nu ook een apparmor profiel voor /usr/bin/httpserver. Let erop dat je ook uittest of je de httpserver kan bereiken vanuit je browser vanop http://localhost:1234

Opmerking: Je profiel opnieuw maken kan je door /etc/apparmor.d/usr.bin.getstuff te verwijderen en de machine terug op te starten





## ✨Exercises

### 👉Exercise 0: Install necessary software packages

- Install the necessary software packages
```bash
sudo apt-get update -y && sudo apt-get upgrade -y
sudo apt-get install apparmor-utils auditd mono-complete -y
```

### 👉Exercise 1: Download the mono program getstuff.exe

- Download the mono program getstuff.exe
```bash
sudo curl -s https://raw.githubusercontent.com/EliasDeHondt/ComputerSystems3-ISB/main/source/getstuff.exe -o /usr/lib/getstuff/getstuff.exe
```










## 🔗Links
- 👯 Web hosting company [EliasDH.com](https://eliasdh.com).
- 📫 How to reach us elias.dehondt@outlook.com