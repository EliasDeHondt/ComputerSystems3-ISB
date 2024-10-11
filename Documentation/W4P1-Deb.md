![logo](https://eliasdh.com/assets/media/images/logo-github.png)
# 💙🤍W4P1 Deb🤍💙

## 📘Table of Contents

1. [📘Table of Contents](#📘table-of-contents)
2. [📝Assignment](#📝assignment)
3. [✨Exercises](#✨exercises)

4. [🔗Links](#🔗links)

---

### 📝Assignment 
> NOTE This is in Dutch

- **DOEL:**  Aanmaken van deb bestand.

- **NODIG:** Ubuntu /Debian (met grafische interface!) snake.py (een python3 script) apt-get install dh-make debhelper fakeroot devscripts

- [REF 1](https://www.debian.org/doc/debian-policy/).

1. Download het python3 programma snake.py
    - Start het programma op. Je hebt waarschijnlijk python3 en python3-tk nodig

2. Maak een pakket snake aan
    - snake.py voorzie je in /usr/lib/snake/snake.py
    - snake voorzie je in /usr/bin

3. Volg de Rich man’s deb instructies (gemarkeerd met OEF) Zorg voor een ikoontje en een .desktop bestand. Zorg dat het programma opstart en dat lintian geen enkele fout en geen enkele warning geeft op je pakket.

## ✨Exercises

### 👉Exercise 0: Install necessary software packages

- Install the necessary software packages
```bash
sudo apt-get update -y && sudo apt-get upgrade -y
sudo apt-get install dh-make debhelper fakeroot devscripts python3-venv python3 -y
```

- Create a virtual environment and install the necessary packages
```bash
python3 -m venv ~/demo_snake
source ~/demo_snake/bin/activate
```

- If you want to leave the virtual environment, you can use the following command
```bash
deactivate
```

### 👉Exercise 1: Set environment variables

- Run the following [script](/Scripts/Deb/variables.sh) to set the environment variables:
```bash
wget https://raw.githubusercontent.com/EliasDeHondt/main/Scripts/Deb/variables.sh
sudo chmod +x variables.sh
./variables.sh
```


















## 🔗Links
- 👯 Web hosting company [EliasDH.com](https://eliasdh.com).
- 📫 How to reach us elias.dehondt@outlook.com