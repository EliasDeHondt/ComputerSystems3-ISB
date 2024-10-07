![logo](https://eliasdh.com/assets/media/images/logo-github.png)
# 💙🤍7 Warp Up🤍💙

## 📘Table of Contents

1. [📘Table of Contents](#📘table-of-contents)
2. [📚Reference](#📚reference)
3. [✨Steps](#✨steps)
    1. [👉Step 1: Connect through SSH](#👉step-1-connect-through-ssh)
    2. [👉Step 2: Let's do some coding](#👉step-2-lets-do-some-coding)
    3. [👉Step 3: Finished](#👉step-3-finished)
4. [🔗Links](#🔗links)

---

## 📚Reference

- [📚IBM Mainframe Challenge](https://ibmzxplore-static.s3.eu-gb.cloud-object-storage.appdomain.cloud/WRAPUP.pdf)

![IBM Fundamentals](/Images/IBM-Fundamentals+Concepts.png)

## ✨Steps

### 👉Step 1: Connect through SSH

- Open a terminal.
- Run the following command to connect to the USS server:
    ```bash
    ssh zxxxxx@204.90.115.200
    ```
- You will now be asked for your password, which is the same password you used to log into the z/OS system through `VSCode`.

### 👉Step 2: Let's do some coding

- Run the following command to connect to the USS server:
    ```bash
    decho -a "This line goes at the bottom" 'Z58577.JCL3OUT'

- Edit the `JCL3OUT` dataset in `VSCode`.
- You should see the line you just `decho’d` appended to the bottom of the data set.
- Make sure you have a copy of `dslist.py` in your home directory in USS.
```python
#!/usr/bin/env python3
from zoautil_py import datasets

members_list = datasets.list_members("Z58577.JCL")
for member in range(len(members_list)):
    print(str(member+1) + ": " + members_list[member])
```
- Run the program with:
    ```bash
    python3 dslist.py
    ```

---

- You can get started on a couple of these functions that already work, and your job will be to get the rest of them working smoothly.
- Open up your `members.py` file in your home directory and take a look at the source.
```python
#!/usr/bin/env python3
from zoautil_py import datasets, jobs, zsystem
import sys, os

dsname = input("Enter the Sequential Data Set name: ")
dsname = dsname.upper().replace("'","").replace(os.environ.get('LOGNAME')+".","")
dsname = f"'{os.environ.get('LOGNAME')}.{dsname}'"
print(dsname)

if (datasets.exists(dsname) == True):
    print("Data set found! We will use it")
else:
    create_new = input("Data set not found. Should we create it? (y/n) : ")
    if (create_new.upper() == "Y"):
        datasets.create(dsname,type="SEQ",primary_space="1k",secondary_space="1k")
    else: sys.exit("Without a data set name, we cannot continue. Quitting!")
dsname=dsname.replace("'","")

linklist_output = zsystem.list_linklist()
linklist_output = str(linklist_output).replace(',','\n')
print(linklist_output)

datasets.write(dsname, linklist_output, append=False)
```
- Run the program with:
    ```bash
    python3 members.py
    ```

### 👉Step 3: Finished

- Now submit the job `CHKAUTO` from `ZXP.PUBLIC.JCL` to validate the correct output from code (`CC`) of `0000`.

## 🔗Links
- 👯 Web hosting company [EliasDH.com](https://eliasdh.com).
- 📫 How to reach us elias.dehondt@outlook.com