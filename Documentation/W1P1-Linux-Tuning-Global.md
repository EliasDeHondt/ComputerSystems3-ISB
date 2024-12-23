![logo](https://eliasdh.com/assets/media/images/logo-github.png)
# 💙🤍W1P1 Linux Tuning Global🤍💙

## 📘Table of Contents

1. [📘Table of Contents](#📘table-of-contents)
2. [📝Assignment](#📝assignment)
3. [✨Exercises](#✨exercises)
    1. [👉Exercise 0: Install packages](#👉exercise-0-install-packages)
    2. [👉Exercise 1: Copy large file](#👉exercise-1-copy-large-file)
    3. [👉Exercise 2: Process accounting](#👉exercise-2-process-accounting)
    4. [👉Exercise 3: vmstat](#👉exercise-3-vmstat)
    5. [👉Exercise 4: Kernel cache](#👉exercise-4-kernel-cache)
    6. [👉Exercise 5: IPC applications](#👉exercise-5-ipc-applications)
    7. [👉Exercise 6: vi editor](#👉exercise-6-vi-editor)
    8. [👉Exercise 7: hdparm](#👉exercise-7-hdparm)
    9. [👉Exercise 8: lsof](#👉exercise-8-lsof)
    10. [👉Exercise 9: ip](#👉exercise-9-ip)
    11. [👉Exercise 10: Shell script](#👉exercise-10-shell-script)
    12. [👉Exercise 11: Swapfile](#👉exercise-11-swapfile)
    13. [👉Exercise 12: Kernel parameter](#👉exercise-12-kernel-parameter)
    14. [👉Exercise 13: Compile source files](#👉exercise-13-compile-source-files)
4. [🔗Links](#🔗links)

---

### 📝Assignment 
> NOTE This is in Dutch

**NODIG:** Voor deze oefeningen zal je wat extra softwarepakketten nodig hebben. Voor de laatste oefening moet je compileren. Installeer hiervoor gcc, g++ en build-essential

1. Copieer met `time` een groot bestand vanaf je cdrom of usb naar je schijf. Doe dit 2 keer. Vergelijk de 2 metingen.

2. Schakel process accounting aan. Kijk welk proces het meest gebruikt wordt.

3. Draai het tooltje `vmstat` (om de 2 seconden, 10 metingen).
    - Hoeveel processen staan er maximaal te wachten om te draaien?
    - Hoeveel processen staan er maximaal te wachten op I/O?

4. Bekijk de cache die de kernel gebruikt. Welke cache gebruikt het meeste geheugen?

5. Draaien er applicaties die `ipc` gebruiken op je systeem?

6. Start een `vi` editor op.
    - Gebruik `ldd` om te kijken welke libraries `vi` gebruik.
    - Gebruik `pmap` om te kijken hoeveel geheugen `vi` gebruikt.
    - Wat is het verschil tussen de bibliotheken die `pmap` toont en de bibliotheken die `ldd` toont?

7. Test met `hdparm` de prestaties uit van je schijf

8. Gebruik `lsof` om te kijken welke processen (al-dan-niet gewenst) het netwerk gebruiken.

9. Gebruik het tooltje `ip` om een extra netwerkkaart aan te maken met de naam `dummy1`. Deze krijgt het adres `1.2.3.4/24`.
    - Test uit of je deze kan pingen. Verwijder dan deze interface.

10. Schrijf een korte oneindige loop in shell script.
    - Zorg met `cpulimit` dat de oneindige loop zo weinig mogelijk cputijd gebruikt. Lukt dit?

11. Maak een extra swapfile met de naam `pagefile.sys`. Zorg dat het systeem deze swapfile ook gebruikt. Waarom gebruikt linux een swapartitie en meestal geen swapfile?

12. Verander een kernelparameter zodat deze zo veel mogelijk swapt. Start enkele programma's en zorg ervoor dat je swapfile gebruikt wordt (zoek zelf uit hoe je dat kan zien).

13. Compileer de voorziene `c` en `cpp` source bestanden en start de gecompileerde programma's op.
    - Zoek zelf uit wat er fout loopt wanneer je het programma opstart.
    - Voor bestand `b.c` moet je lokaal een apache server draaien.

## ✨Exercises

### 👉Exercise 0: Install packages

```bash
# Test VM 1 (Ubuntu24Test1)
sudo apt-get install gcc g++ build-essential
```

### 👉Exercise 1: Copy large file

```bash
# Create large test file in home directory
dd if=/dev/zero of=~/testfile bs=1M count=1000

# Check that the file was created with the correct size
ls -lh ~/testfile

# Copy file to /tmp
time cp ~/testfile /tmp/testfile1

# Copy file to /tmp again
time cp ~/testfile /tmp/testfile2
```
> Do you see the time difference?

### 👉Exercise 2: Process accounting

```bash
# Install acct package
sudo apt-get install acct

# Create log directory
mkdir -p /var/log/account

# Enable process accounting
sudo accton /var/log/account/pacct

# Check which process is used the most (Log file is in /var/log/account/pacct)
sudo sa

# Disable process accounting
sudo accton off
```

> **Note:** What does process accounting do: So the program `accton` keeps track of the resources used by each process. In the folder `/var/log/account/pacct` you can find the log files.

### 👉Exercise 3: vmstat

```bash
# Run vmstat every 2 seconds for 10 times
vmstat 2 10

# How many processes are waiting to run at most?
# How many processes are waiting for I/O at most?
vmstat 2 10 | awk 'NR>2 { if($1>max_r) max_r=$1; if($2>max_b) max_b=$2 } END { print "Max processes waiting to run:", max_r; print "Max processes waiting for I/O:", (max_b=="" ? 0 : max_b) }' # This takes 20 seconds :)
```

### 👉Exercise 4: Kernel cache

```bash
# Check the cache used by the kernel
sudo slabtop
```

### 👉Exercise 5: IPC applications

```bash
# Check if there are applications using IPC
sudo ipcs
```

> **Note:** IPC stands for Inter-Process Communication. It is the communication between processes/threads.

### 👉Exercise 6: vi editor

```bash
# Start vi editor in the background
sudo vi &

# Check which libraries vi uses
ldd /usr/bin/vi

# Check how much memory vi uses
pmap $(pgrep vi)
```

- Difference between libraries shown by pmap and ldd
    - The libraries shown by `pmap` are the libraries that are currently `loaded in memory`. 
    - The libraries shown by `ldd` are the libraries that are `linked to the executable`.

### 👉Exercise 7: hdparm

```bash
# Test the performance of your disk
sudo hdparm -tT /dev/sda
# -t: Timing buffered disk reads
# -T: Timing cached reads
```

### 👉Exercise 8: lsof

```bash
# Check which processes are using the network
sudo lsof -i
```

### 👉Exercise 9: ip

```bash
# Create a dummy network interface
sudo ip link add dummy1 type dummy
sudo ip address add dev dummy1 1.2.3.4/24

# Check if you can ping the interface
ping 1.2.3.4

# Remove the interface
sudo ip link delete dummy1
```

### 👉Exercise 10: Shell script

```bash
# Create a shell script with an infinite loop
echo "while true; do echo 'Hello World'; sleep 1; done" > infinite.sh
sudo chmod +x infinite.sh

# Install cpulimit
sudo apt-get install cpulimit

# Run the shell script with cpulimit
cpulimit -l 10 ./infinite.sh # The is limited to 10% CPU usage

# Kill the process
pkill infinite.sh
```

### 👉Exercise 11: Swapfile

```bash
# Create a swapfile
sudo dd if=/dev/zero of=/pagefile.sys bs=1M count=1024

# Change the permissions of the swapfile
sudo chmod 600 /pagefile.sys

# Format the swapfile
sudo mkswap /pagefile.sys

# Enable the swapfile
sudo swapon /pagefile.sys

# Disable default swapfile (if it exists)
sudo swapoff /swap.img

# Check if the swapfile is being used
sudo swapon -s
# Or
sudo swapon --show
```

### 👉Exercise 12: Kernel parameter

```bash
# Change the kernel parameter to swap as much as possible
sudo sysctl vm.swappiness=100

# Start some programs to use the swapfile...
```

- Repair the damage :/
```bash
# Change the kernel parameter back to the default value
sudo sysctl vm.swappiness=60

# Enable the default swapfile
sudo swapon /swap.img

# Disable the swapfile
sudo swapoff /pagefile.sys

# Remove the swapfile
sudo rm /pagefile.sys
```

### 👉Exercise 13: Compile source files

```bash
# Install apache2
sudo apt-get install apache2 -y

# Start apache2
sudo systemctl start apache2

# Compile the source files
# ./source/a.c
# ./source/b.c
# ./source/c.c
# ./source/d.c
# ./source/b.cpp

gcc -o programma_a ./source/a.c
gcc -o programma_b ./source/b.c
gcc -o programma_c ./source/c.c
gcc -o programma_d ./source/d.c
g++ -o programma_z ./source/b.cpp

# Run the compiled programs
./programma_a
./programma_b
./programma_c
./programma_d
./programma_z
```
- Problem 1 (programma_a): It's attempting to utilize too much memory. Also too much iterations in a loop for the CPU to handle.

- Problem 2 (programma_b): The program creates an infinite loop that repeatedly sends HTTP requests to a local server, potentially causing a Denial of Service (DoS) by overloading the server with continuous connections and requests.

- Problem 3 (programma_c): This program runs an infinite loop without any exit condition, which will cause the CPU to be fully utilized and can lead to the system becoming unresponsive.

- Problem 4 (programma_d): This program enters an infinite loop that repeatedly copies the `/boot/vmlinuz` file to `/tmp/` with different names, which will quickly fill up the `/tmp` directory and can lead to a lack of disk space and potential system instability.

- Problem 5 (programma_z): This program configures a network interface, then initiates multiple flood pings to a specified IP address in the background, which can overwhelm the target with excessive traffic, potentially leading to a Denial of Service (DoS) condition. After a set number of pings, it terminates all ping processes.

- The source files are provided in the [source](/source) folder.

```bash
# Stop apache2
sudo systemctl stop apache2

# Remove apache2
sudo apt-get remove apache2 -y
```

## 🔗Links
- 👯 Web hosting company [EliasDH.com](https://eliasdh.com).
- 📫 How to reach us elias.dehondt@outlook.com