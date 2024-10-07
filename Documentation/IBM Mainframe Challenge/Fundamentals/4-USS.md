![logo](https://eliasdh.com/assets/media/images/logo-github.png)
# 💙🤍4 USS🤍💙

## 📘Table of Contents

1. [📘Table of Contents](#📘table-of-contents)
2. [📚Reference](#📚reference)
3. [✨Steps](#✨steps)
  1. [👉Step 1: Connect through SSH](#👉step-1-connect-through-ssh)
  2. [👉Step 2: Setup USS](#👉step-2-setup-uss)
  3. [👉Step 3: Getting Orientated](#👉step-3-getting-orientated)
  4. [👉Step 4: Navigating the Filesystem](#👉step-4-navigating-the-filesystem)
  5. [👉Step 5: Creating a File and folders](#👉step-5-creating-a-file-and-folders)
  6. [👉Step 6: I've got a secret](#👉step-6-ive-got-a-secret)
  7. [👉Step 7: Redirecting the output](#👉step-7-redirecting-the-output)
  8. [👉Step 8: Space Exploration](#👉step-8-space-exploration)
  9. [👉Step 9: Make it count](#👉step-9-make-it-count)
  10. [👉Step 10: Finished](#👉step-10-finished)
4. [🔗Links](#🔗links)

---

## 📚Reference

- [📚IBM Mainframe Challenge](https://ibmzxplore-static.s3.eu-gb.cloud-object-storage.appdomain.cloud/USS1.pdf)

![IBM Fundamentals](/Images/IBM-Fundamentals.png)

## ✨Steps

### 👉Step 1: Connect through SSH

- Open a terminal.
- Run the following command to connect to the USS server:
  ```bash
  ssh zxxxxx@204.90.115.200
  ```
- You will now be asked for your password, which is the same password you used to log into the z/OS system through `VSCode`.

### 👉Step 2: Setup USS

- Run the following command;
  ```bash
  uss-setup
  ls -l
  ```

- To clear the screen, run the following command:
  ```bash
  clear
  ```

### 👉Step 3: Getting Orientated

- In addition to looking around with `ls` , you may also want to know "Where am I?".
- The default command prompt will usually show you where you are in the directory structure, but you can also type `pwd` to see the full path to your current location.
-  This will be useful shortly when you will start using `cd` to Change Directory to move around the filesystem.
- Right now, you’re in your home directory, which is where your `USS` files live.
- You can get back to this directory at any time by typing `cd ~`.

### 👉Step 4: Navigating the Filesystem

- To navigate into another directory, type `cd`, followed by the name of the directory.
- For example, we can type `cd directory1` and we’ll go into `directory1`, assuming that’s a directory we can see with the `ls` command.
- Try it out, then type `pwd` to see where you are.
- To go back to your home directory, you need to go back one level. You can do this by typing `cd ..` or `cd ~`.

### 👉Step 5: Creating a File and folders

- The `touch` command is commonly used to update the "last modified" timestamp of a file but can also be used to create an empty file.
- Enter the command `touch mynewfile` and follow that up with a `ls` to see the brand new file.
- You can create brand new directories with the `mkdir` command.
- Try creating a new directory called `mynewdirectory` by typing `mkdir mynewdirectory` and then `ls` to see the new directory.

### 👉Step 6: I've got a secret

- You have a program called `scramble.sh` in your home directory.
- You can tell this is an executable program because when you enter the command `ls –l` it shows up with an "x" in the fourth spot of the permissions. This means that in addition to you being able to Read and Write it, you can also eXecute it.
- For now, just know that you can run the program with the command:
```bash
./scramble.sh
```
- And the output of the program will tell you everything you need to know. Good luck!
```plaintext
Usage Example: ./scramble.sh file.txt 13

This program takes the input from a file (first argument)
and rotates the letters by a number of positions (second argument)
If only works for lowercase characters.
The first argument needs to be a file.

Your task is to figure out the correct number of rotations needed
to decode the secret message in /z/public/secret.txt. Good luck!
```
- Answer to the question:
```bash
./scramble.sh /z/public/secret.txt 17
```
### 👉Step 7: Redirecting the output

- Now you have cracked the code, put the output of the program into a file. This is super easy to do, using "redirection".
- Type, or recall, your recent successful scramble command with the correct values, and add `> ussout.txt` to the end of it.
```bash
./scramble.sh /z/public/secret.txt 17 > ussout.txt
cat ussout.txt
```
- You can use `>>` to redirect the output to append to the bottom/end of the output file.

### 👉Step 8: Space Exploration

- Once you have the decoded output in your `ussout.txt` file, use redirection to append to the end of that file (do not overwrite!) with the output of `du –ak`.
- The `du` command outputs the Disk Usage of the directory you are currently in, as well as all of the directories inside/below that directory (if you specify the `-a` option) and will give you the output in kilobytes (that is what the `-k` option is for).
```bash
du -ak >> ussout.txt
cat ussout.txt
```

### 👉Step 9: Make it count

- Finally, use redirection to append the output of the `date` command into the same file.
```bash
date >> ussout.txt
cat ussout.txt
```

### 👉Step 10: Finished

- Now submit the job `CHKUSS1` from `ZXP.PUBLIC.JCL` to validate the correct output from code (`CC`) of `0000`.

## 🔗Links
- 👯 Web hosting company [EliasDH.com](https://eliasdh.com).
- 📫 How to reach us elias.dehondt@outlook.com