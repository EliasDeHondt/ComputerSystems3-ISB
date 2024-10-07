![logo](https://eliasdh.com/assets/media/images/logo-github.png)
# 💙🤍5 Code🤍💙

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

- [📚IBM Mainframe Challenge](https://ibmzxplore-static.s3.eu-gb.cloud-object-storage.appdomain.cloud/CODE1.pdf)

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

- Check your home directory for a file called `code1.py`.
- Next, run the program with:
    ```bash
    python3 code1.py
    ```
- Open up the `code1.py` in an editor window within VSCode.
```python
#!/usr/bin/env python3
from datetime import datetime
import time
import getpass

print("Welcome to the CODE challenge!\n")
my_number = 5

while (my_number > 0):
    print("The current time is " + datetime.now().strftime("%H:%M:%S"))
    my_number = my_number - 1
    time.sleep(1)

your_userid = getpass.getuser()
print("We hope you have fun in this challenge, " + your_userid)

total_number = 0
for char in your_userid: 
    if (char.isnumeric()):
        total_number = total_number + int(char)

print("By the way, if you add up all the numbers in your userid, you get " + str(total_number) + "\nThat's pretty neat, right?")
```

---

- Make sure you have a copy of over `code2.py` in your home directory.
- This Python program takes a word and figures out if the letter "z" is in it.
- Next, run the program with:
    ```bash
    python3 code2.py
    ```
- Open up the `code2.py` in an editor window within VSCode.
```python
#!/usr/bin/env python3
the_letter = "z"
the_word = "pizza" # pumpkin for the else statement

if the_letter in the_word:
    print("Yes! The letter " + the_letter + " is in the word " + the_word)
else:
    print("Nope. The letter " + the_letter + " is NOT in the word " + the_word)
```

---

- Make sure you have a copy of over `marbles.py` in your home directory.
- This Python program takes a list of marbles and figures out how many of them are blue.
- Next, run the program with:
    ```bash
    python3 marbles.py
    ```
- Open up the `marbles.py` in an editor window within VSCode.
```python
#!/usr/bin/env python3
marbles = 10
marble_dots = "**********"

while (marbles > 0):
    print(marble_dots[:marbles])
    print("You have " + str(marbles) + " marbles left.")

    if (marbles <= 3):
        print("Warning: You are running low on marbles!!")

    marbles -= 1 

    print("")

print("You are all out of marbles")
```

### 👉Step 3: Finished

- Now submit the job `CHKCODE` from `ZXP.PUBLIC.JCL` to validate the correct output from code (`CC`) of `0000`.

## 🔗Links
- 👯 Web hosting company [EliasDH.com](https://eliasdh.com).
- 📫 How to reach us elias.dehondt@outlook.com