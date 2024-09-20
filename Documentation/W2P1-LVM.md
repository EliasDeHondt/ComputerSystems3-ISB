![logo](https://eliasdh.com/assets/media/images/logo-github.png)
# 💙🤍W2P1 LVM🤍💙

## 📘Table of Contents

1. [📘Table of Contents](#📘table-of-contents)
2. [📝Assignment](#📝assignment)
3. [✨Exercises](#✨exercises)
    1. [👉Exercise 1: CentOS 9 Download](#👉exercise-1-centos-9-download)
    2. [👉Exercise 2: Virtual Machine Setup](#👉exercise-2-virtual-machine-setup)
    3. [👉Exercise 3: RAID1 Setup](#👉exercise-3-raid1-setup)
    4. [👉Exercise 4: Extra 100MB Disk](#👉exercise-4-extra-100mb-disk)
    5. [👉Exercise 5: Extra 200MB Disk](#👉exercise-5-extra-200mb-disk)
    6. [👉Exercise 6: Test RAID](#👉exercise-6-test-raid)
    7. [👉Exercise 7: Replace the 1st RAID Disk](#👉exercise-7-replace-the-1st-raid-disk)
4. [🔗Links](#🔗links)

---

### 📝Assignment 
> NOTE This is in Dutch

1. Installatie virtueel CentOS:
    - Download de laatste CentOS 9 Stream image via: (Opgelet 9 GB DVD iso) https://www.centos.org/download/

2. Je virtuele machine heeft volgende opties:
    - RAM: `2048MB`
    - Voorzie 3 dezelfde schijven van 20 GB bv `raiddisk1.vmdk`, `raiddisk2.vmdk` en `raiddisk3.vmdk`
    - Voorzie 1 schijfje van `100MB`
    - Voorzie 1 schijfje van `200MB`
    - Alle schijven mogen dynamisch groeien

3. Volg de installatiestappen van CentOS 9 Stream:
    - Voeg tijdens de installatie ook een netwerkkaart toe!
    - In het kort doe je het volgende tijdens de installatie:
        - raid1 `/dev/md0` met `/dev/sda1` en `/dev/sdb1` (elk 500MB) -> `/boot`
        - raid1 `/dev/md1` met `/dev/sda2` en `/dev/sdb2` (rest van de schijven)
        - VolumeGroup VolGroup van `/dev/md1`
        - Logisch Volume `/dev/VolGroup/LogVol00` swap (1GB)
        - Logisch Volume `/dev/VolGroup/LogVol01` `/` (ext4) (Rest van VolumeGroup)

4. Gebruik nu de extra schijf van `100MB`
    - Maak hierop met `fdisk` 1 grote partitie (`/dev/sdc1`) van het type 8e (Linux LVM)
    - Maak hiervan een Physical Volume
    - Stop dit in een nieuwe `volumegroup` `VolGroupHome`
    - Maak binnen `VolGroupHome` het logische Volume `LogVolHome`. Neem alle vrije plaats in met de optie `--extents 100%FREE`
    - Formatteer de schijf met:
        - `mkfs.ext4 /dev/VolGroupHome/LogVolHome`
    - Mount de schijf met:
        - `mount -t ext4 /dev/VolGroupHome/LogVolHome /home`
    - Kijk met `df -h >> /home/df.txt` na of `/home` gemount is en of het bestand
        - wordt aangemaakt `/home`

5. Gebruik nu de extra schijf van `200 MB`
    - Zorg dat deze schijf als uitbreiding van de bestaande `/home` wordt gebruikt
    - Doe een online resize van de logische volume `LogVolHome`

6. Test RAID:
    - Geef het commando cat `/proc/mdstat >> /root/raidok.txt`
    - Zet de machine af en start op met enkel de 1ste raidschijf
    - (bij de 2de schijf kies je "Remove Attachment")
    - Bekijk het verschil als je terug cat `/proc/mdstat uitvoert`

7. XTRA voor de PRO's : Vervangen van de eerste schijf
    - Opgelet: Hiermee kan je alles overhoop gooien!
    - We gaan er van uit dat de 2de schijf defect is.
    - Volg de procedure op [link4](https://www.howtoforge.com/replacing_hard_disks_in_a_raid1_array) om met jouw raiddisk3 schijf een "nieuwe" schijf te voorzien.
    - Gebruik volgend commando om te zien wanneer de RAID1 terug ok is:
    - watch `cat /proc/mdstat`
    - Als alles klaar is, kan je watch stoppen met CTRL-C

## ✨Exercises

### 👉Exercise 1: CentOS 9 Download

- Download CentOS 9 Stream image via: [CentOS 9 Stream](https://mirrors.centos.org/mirrorlist?path=/9-stream/BaseOS/x86_64/iso/CentOS-Stream-9-latest-x86_64-dvd1.iso&redirect=1&protocol=https)


### 👉Exercise 2: Virtual Machine Setup

- RAM: `2048MB`
- CentOS9TestHDD1.vmdk -> `20GB`
- CentOS9TestHDD2.vmdk -> `20GB`
- CentOS9TestHDD3.vmdk -> `20GB`
- CentOS9TestHDD4.vmdk -> `0.1GB`
- CentOS9TestHDD5.vmdk -> `0.2GB`

> HDD1, HDD2, HDD3 are RAID disks

> HDD4 -> `/home` (100MB)

> RAID1 -> `/boot` (500MB)

> RAID1 -> `Swap` (1GB)

> RAID1 -> `/` (Rest of the VolumeGroup)

### 👉Exercise 3: RAID1 Setup

- [This configuration is in the CentOS 9 UI](https://www.youtube.com/watch?v=4p2TH7Fwvqs)

- Login to the CentOS 9 Stream UI
- Set the user in the `root` group
```bash
su root
usermod -aG root elias
su elias
```
- Open terminal en run the following commands to test the configuration:
```bash
# Check RAID status & Check the location of the /boot and Swap and /
sudo lsblk
```

![Images](/Images/W2P1-LVM-1.png)

### 👉Exercise 4: Extra 100MB Disk

- CentOS9TestHDD4.vmd -> `/home` (100MB)
- Follow the commands to create the disk and mount it to `/home`
```bash
# 1) Create a partition
sudo fdisk /dev/sde # o -> n -> p -> 1 -> enter -> enter -> w
# 2) Create a Physical Volume
sudo pvcreate /dev/sde1
# 3) Create a Volume Group
sudo vgcreate VolGroupHome /dev/sde1
# 4) Create a Logical Volume
sudo lvcreate -l 100%FREE -n LogVolHome VolGroupHome
# 5) Format the disk
sudo mkfs.ext4 /dev/VolGroupHome/LogVolHome
# 6) Mount the disk
sudo mount -t ext4 /dev/VolGroupHome/LogVolHome /home
# 7) Check if the disk is mounted
df -h >> /home/df.txt
```

### 👉Exercise 5: Extra 200MB Disk

- CentOS9TestHDD5.vmd -> `/home` (200MB)
- Follow the commands to create the disk and mount it to `/home`
```bash
# 1) Create a partition
sudo fdisk /dev/sdd # o -> n -> p -> 1 -> enter -> enter -> w
# 2) Create a Physical Volume
sudo pvcreate /dev/sdd1
# 3) Extend the Volume Group
sudo vgextend VolGroupHome /dev/sdd1
# 4) Extend the Logical Volume
sudo lvextend -L +200M /dev/VolGroupHome/LogVolHome
# 5) Resize the disk
sudo resize2fs /dev/VolGroupHome/LogVolHome
# 6) Check if the disk is mounted
df -h >> /home/df.txt
```

![Images](/Images/W2P1-LVM-2.png)

### 👉Exercise 6: Test RAID

- Check the RAID status
```bash
cat /proc/mdstat >> /root/raidok.txt
```

- Shutdown the machine and remove the 2nd RAID disk (`CentOS9TestHDD2.vmdk`)
- Start the machine and check the RAID status
```bash
cat /proc/mdstat >> /root/raidok.txt
```

### 👉Exercise 7: Replace the 1st RAID Disk

- Follow the procedure on [HowToForge](https://www.howtoforge.com/replacing_hard_disks_in_a_raid1_array) to replace the 1st RAID disk
- Check the RAID status
```bash
watch cat /proc/mdstat
```

## 🔗Links
- 👯 Web hosting company [EliasDH.com](https://eliasdh.com).
- 📫 How to reach us elias.dehondt@outlook.com