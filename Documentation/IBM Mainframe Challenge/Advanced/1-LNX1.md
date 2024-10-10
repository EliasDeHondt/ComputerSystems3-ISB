![logo](https://eliasdh.com/assets/media/images/logo-github.png)
# 💙🤍1 LNX1🤍💙

## 📘Table of Contents

1. [📘Table of Contents](#📘table-of-contents)
2. [📚Reference](#📚reference)
3. [✨Steps](#✨steps)
    1. [👉Step 1: Connect through SSH](#👉step-1-connect-through-ssh)
    2. [👉Step 2: Explore](#👉step-2-explore)
4. [🔗Links](#🔗links)

---

## 📚Reference

- [📚IBM Mainframe Challenge](https://ibmzxplore-static.s3.eu-gb.cloud-object-storage.appdomain.cloud/LNX1.pdf)

![IBM Fundamentals](/Images/IBM-Advanced.png)

## ✨Steps

### 👉Step 1: Connect through SSH

- Open a terminal.
- Run the following command to connect to the USS server:
  ```bash
  ssh user@ipaddress
  ```

### 👉Step 2: Explore

- You are now connected to the USS server. You can navigate through the file system and perform various operations.
```bash
cd ~                        # Go to the home directory
mkdir my_directory          # Create a directory
cd my_directory/            # Go to the directory
touch a_file                # Create a file
touch another_file          # Create another file
ls                          # List files
rm a_file                   # Remove a file
```

- Since you have full access to this system, why not start by going into the top-level directory, also known as the root directory.
```bash
cd /                        # Go to the root directory
ls                          # List files
```

- Permissions denied?
```bash
ls /root                    # List files in the root directory
sudo ls /root               # List files in the root directory with superuser privileges
```

- Edit a file.
```bash
vi a_file                   # Edit a file
# Or
nano a_file                 # Edit a file
```

- Watch a file as it changes.
```bash
tail -f a_file              # Watch a file as it changes
```

## 🔗Links
- 👯 Web hosting company [EliasDH.com](https://eliasdh.com).
- 📫 How to reach us elias.dehondt@outlook.com