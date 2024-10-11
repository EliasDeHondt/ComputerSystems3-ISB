![logo](https://eliasdh.com/assets/media/images/logo-github.png)
# 💙🤍W4P1 Deb🤍💙

## 📘Table of Contents

1. [📘Table of Contents](#📘table-of-contents)
2. [📝Assignment](#📝assignment)
3. [✨Exercises](#✨exercises)
    1. [👉Exercise 0: Install necessary software packages](#👉exercise-0-install-necessary-software-packages)
    2. [👉Exercise 1: Set environment variables](#👉exercise-1-set-environment-variables)
    3. [👉Exercise 2: Make the executable](#👉exercise-2-make-the-executable)
    4. [👉Exercise 3: dh_make](#👉exercise-3-dh_make)
    5. [👉Exercise 4: Edit the control file](#👉exercise-4-edit-the-control-file)
    6. [👉Exercise 5: Changelog](#👉exercise-5-changelog)
    7. [👉Exercise 6: Make the manpage](#👉exercise-6-make-the-manpage)
    8. [👉Exercise 7: pakket.desktop + Icon](#👉exercise-7-pakketdesktop--icon)
    9. [👉Exercise 8: Build the package](#👉exercise-8-build-the-package)
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
èg 
- Install the necessary software packages
```bash
sudo apt-get update -y && sudo apt-get upgrade -y
sudo apt-get install dh-make debhelper fakeroot devscripts zenity menu wget curl dbus-x11 -y
```

- If you want to leave the virtual environment, you can use the following command
```bash
deactivate
```

### 👉Exercise 1: Set environment variables

- Run the following [script](/Scripts/Deb/variables.sh) to set the environment variables:
```bash
bash <(curl -s https://raw.githubusercontent.com/EliasDeHondt/ComputerSystems3-ISB/main/Scripts/Deb/variables.sh )
```
- [script](/Scripts/Deb/variables.sh):
    ```bash
    #!/bin/bash
    cat >>~/.bashrc <<EOF
    DEBEMAIL="elias.dehondt@student.kdg.be"
    DEBFULLNAME="Elias De Hondt"
    export DEBEMAIL DEBFULLNAME
    EOF
    ```
- Log out and log back in the terminal
- Test the environment variables
```bash
echo $DEBEMAIL
echo $DEBFULLNAME
```

### 👉Exercise 2: Make the executable

- Run the following [script](/Scripts/Deb/executable.sh) to make the executable:
```bash
bash <(curl -s https://raw.githubusercontent.com/EliasDeHondt/ComputerSystems3-ISB/main/Scripts/Deb/executable.sh )
```
- [script](/Scripts/Deb/executable.sh):
    ```bash
    #!/bin/bash
    package="pakket"
    version="1"
    mkdir -p "${package}/${package}-${version}"
    cd "${package}/${package}-${version}"
    cat > ${package} <<EOF
    #!/bin/sh
    zenity --warning --text="\`exec uname -a\`"
    EOF
    chmod 755 $package
    cd ..
    tar -cvzf ${package}-${version}.tar.gz ${package}-${version}
    ```

### 👉Exercise 3: dh_make

- Run the following commands:
```bash
cd pakket/pakket-1
dh_make --native
```
- Press `s` to select `single binary`.
- Press `y` to confirm the license.
- Press `y` to confirm the package name.

### 👉Exercise 4: Edit the control file

- Edit the control file
```bash
bash <(curl -s https://raw.githubusercontent.com/EliasDeHondt/ComputerSystems3-ISB/main/Scripts/Deb/control )
mv control debian
```
- Delete the lines that start with `Description:`
```bash
#Vcs-Browser: https://salsa.debian.org/debian/pakket
#Vcs-Git: https://salsa.debian.org/debian/pakket.git
Homepage: <insert the upstream URL, if relevant>
```

- Change the line `Section: unknown` to `Section: misc`.
- Change the line `Depends: ${shlibs:Depends}, ${misc:Depends}` to `Depends: zenity`.
- Change the line:
    ```plaintext
    Description: <insert up to 60 chars description>
     <insert long description, indented with spaces>
    ```
    - To:
    ```plaintext
    Description: This is a snake game
     This is a program that will display the snake game .
     And other things that are not important.
    ```
- Change the line `Architecture: any` to `Architecture: all`.
    - **Note:** Architecture any means compile for any platform and all means one package for all platforms

- Remove the README & copyright file
```bash
rm debian/README
rm debian/README.Debian
rm debian/README.source
```

- Remove all the `#` lins in the dir `debian`.
- Fill in all the `<..>` in the dir `debian`.

### 👉Exercise 5: Changelog

- Create a changelog file
```bash
dch --create
dch -a "Add icon"
# dch -r "Release" # -r is for release
# dch -i "Increment" # -i is for increment
```

### 👉Exercise 6: Make the manpage

- Get the manpage from the github repository:
```bash
wget https://raw.githubusercontent.com/EliasDeHondt/ComputerSystems3-ISB/main/Scripts/Deb/pakket.1
mv pakket.1 debian
```

- Test the manpage
```
man ./debian/pakket.1
```

- Set the reference to the manpage in the control file
```bash
touch debian/manpages
echo "debian/pakket.1" >> debian/manpages
```

### 👉Exercise 7: pakket.desktop + Icon

- Get the [icon](/Images/32x32.png) from the github repository:
```bash
wget https://raw.githubusercontent.com/EliasDeHondt/ComputerSystems3-ISB/main/Images/pakket.png
```

- Get the [pakket.desktop](/Scripts/Deb/pakket.desktop) file from the github repository:
```bash
wget https://raw.githubusercontent.com/EliasDeHondt/ComputerSystems3-ISB/main/Scripts/Deb/pakket.desktop
```

- Get the [install](/Scripts/Deb/install) file from the github repository:
```bash
wget https://raw.githubusercontent.com/EliasDeHondt/ComputerSystems3-ISB/main/Scripts/Deb/install
mv install debian
```

### 👉Exercise 8: Build the package

- Drop the files in the directories .EX and .ex
```bash
sudo rm debian/*.ex debian/*.EX
```

- Build the package
```bash
debuild -us -uc
```

- Install the package
```bash
sudo dpkg -i ../pakket_1_all.deb
# To rm the package
sudo dpkg -r pakket
```

- Run the package
```bash
pakket usr/bin
```

## 🔗Links
- 👯 Web hosting company [EliasDH.com](https://eliasdh.com).
- 📫 How to reach us elias.dehondt@outlook.com