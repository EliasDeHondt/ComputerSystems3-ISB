![logo](https://eliasdh.com/assets/media/images/logo-github.png)
# 💙🤍8 USS8🤍💙

## 📘Table of Contents

1. [📘Table of Contents](#📘table-of-contents)
2. [📚Reference](#📚reference)
3. [✨Steps](#✨steps)
    1. [👉Step 1: Connect through SSH](#👉step-1-connect-through-ssh)
    2. [👉Step 2: Setup](#👉step-2-setup)
    3. [👉Step 3: Scripting](#👉step-3-scripting)
    4. [👉Step 4: Finished](#👉step-2-finished)
4. [🔗Links](#🔗links)

---

## 📚Reference

- [📚IBM Mainframe Challenge](https://ibmzxplore-static.s3.eu-gb.cloud-object-storage.appdomain.cloud/USS2.pdf)

![IBM Fundamentals](/Images/IBM-Advanced.png)

## ✨Steps

### 👉Step 1: Connect through SSH

- Open a terminal.
- Run the following command to connect to the USS server:
    ```bash
    ssh zxxxxx@204.90.115.200
    # if you did not complete it USS1, you need to run the following command:
    uss-setup
    ```
- You will now be asked for your password, which is the same password you used to log into the z/OS system through `VSCode`.

### 👉Step 2: Setup

- A quick practice of creating a directory and putting files within it.
- Move back to your home directory in the terminal (/z/zxxxxx) and create a directory called `USSmovies`.
- Create three files in `USSmovies` named after your favorite movies.
```bash
cd ~ && mkdir USSmovies && cd USSmovies && touch "The Matrix" "The Lord of the Rings" "The Shawshank Redemption"
```
- If you successfully created the directory and files, now it is time to delete them. Do you remember how to do this?
```bash
cd ~ && rm -r USSmovies
```

### 👉Step 3: Scripting

- Look in your home directory and try to find `animals.sh`. This should have been copied over in the USS Fundamentals challenge, when you ran the script uss-setup.
- Open up the shell script and look around. There is a large portion of the script that lives within an `IF` statement, and a lot of it will only run correctly if certain conditions are met.
- Read the comments for additional information and try to figure out what is going on in the script before proceeding.
- The script has lots of clues about what it requires to run.
- Create three files (`animal1`, `animal2`, and `animal3`) and a directory below your home directory called `uss2output`.
- Enter in every file one line with an animal name. Remember to complete each line with an Enter or Return so it is a `line`, not just a `word`!
- Run the following command to execute this the creation of the structure:
```bash
cd ~ && touch animal1 animal2 animal3 && mkdir uss2output
echo "cat" > animal1 && echo "dog" > animal2 && echo "bird" > animal3
```
- Make sure the script is executable and run it.
```bash
chmod +x animals.sh && ./animals.sh Dog
```
- Check the output in the `uss2output` directory:
```bash
cat ~/uss2output/message
```

### 👉Step 4: Finished

- Now submit the job `CHKUSS2` from `ZXP.PUBLIC.JCL` to validate the correct output from code (`CC`) of `0000`.

## 🔗Links
- 👯 Web hosting company [EliasDH.com](https://eliasdh.com).
- 📫 How to reach us elias.dehondt@outlook.com