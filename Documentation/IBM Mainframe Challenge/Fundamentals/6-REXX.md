![logo](https://eliasdh.com/assets/media/images/logo-github.png)
# 💙🤍6 REXX🤍💙

## 📘Table of Contents

1. [📘Table of Contents](#📘table-of-contents)
2. [📚Reference](#📚reference)
3. [✨Steps](#✨steps)
    1. [👉Step 1: Install Zowe on Linux/Windows](#👉step-1-install-zowe-on-linuxwindows)
    2. [👉Step 2: Set default profiles](#👉step-2-set-default-profiles)
    3. [👉Step 3: Run a REXX program](#👉step-3-run-a-rexx-program)
    4. [👉Step 4: Start an address space](#👉step-4-start-an-address-space)
    5. [👉Step 5: Create a REXX program](#👉step-5-create-a-rexx-program)
    6. [👉Step 6: Finished](#👉step-6-finished)
4. [🔗Links](#🔗links)

---

## 📚Reference

- [📚IBM Mainframe Challenge](https://ibmzxplore-static.s3.eu-gb.cloud-object-storage.appdomain.cloud/REXX1.pdf)

![IBM Fundamentals](/Images/IBM-Fundamentals.png)

## ✨Steps

### 👉Step 1: Install Zowe on Linux/Windows

- Open a terminal.
- Run the following command to install Zowe for Linux:
    ```bash
    sudo apt-get update && sudo apt-get install -y
    sudo apt install nodejs npm -y
    npm config set prefix '~/.npm-global'
    echo "export PATH=~/.npm-global/bin:$PATH" >> ~/.bashrc
    source ~/.bashrc
    npm install -g @zowe/cli
    zowe --version
    ```

- Run the following command to install Zowe for Windows:
    ```bash
    npm install -g @zowe/cli
    zowe --version
    ```

### 👉Step 2: Set default profiles

- Get started on your REXX programming journey by copying two members from `ZXP.PUBLIC.SOURCE` to your own `SOURCE` data set.
- Specifically, you are looking for `SOMEREXX` and `GUESSNUM`.
- Enter the following command to see what profiles are already defined:
    - You should see a print-out that shows your z/OSMF profile.
    ```bash
    zowe config list
    ```

- Test your default connection:
    ```bash
    zowe files list ds "ZXP.PUBLIC.*"
    ```

### 👉Step 3: Run a REXX program

- Run the `SOMEREXX` program:
    ```bash
    zowe tso issue command "exec 'Z58577.SOURCE(somerexx)'" --ssm
    ```

### 👉Step 4: Start an address space

- This time, instead of a single command, you will run an interactive `REXX` program to make that work, you will need to create a server "address space" to start and run the `REXX` command until you are finished.
- Start an address space with the following command:
    ```bash
    zowe tso start address-space
    ```
- This will create an address space for you, and tell you its key, which will begin with your userid (as you can see above).
- You can choose to stop an address space with the command:
    ```bash
    zowe tso stop address-space {Z58577-118-aaboaaat}
    ```

- Run the same `REXX` program from step 3, but this time, direct the input towards the address space (and remember, you can probably press the Up arrow to recall previous commands):
    ```bash
    zowe tso send address-space {Z58577-118-aaboaaat} --data "exec 'Z58577.SOURCE(somerexx)'"
    ```
- The big difference here is that you’re now issuing these commands to a semi-persistent TSO Address Space, which will make more sense in the next steps.

### 👉Step 5: Create a REXX program

- Assuming your `TSO` address space is active, run the program `GUESSNUM` using the same command (just change the member name from `SOMEREXX` to `GUESSNUM`):
    ```bash
    zowe tso send address-space {Z58577-118-aaboaaat} --data "exec 'Z58577.SOURCE(guessnum)'"
    ```

- If you haven’t already done so, open up the code for that program in your VSCode editor
- It is not a complicated program by any means, but you might be noticing just how simple this REXX code really is.
    ```rexx
    /* REXX */
    say "I'm thinking of a number between 1 and 10."
    secret = RANDOM(1,10)
    tries = 1

    do while (guess \= secret)
        say "What is your guess?"
        pull guess
        if (guess \= secret) then
        do
            say "That's not it. Try again"
            tries = tries + 1
        end
    end
    say "You got it! And it only took you" tries "tries!"
    exit
    ```
- Now you can send your guesses to the program by replacing everything between the double-quotes with a number.
- You can see that the commands use the Address Space Key to ensure your input keeps going to the correct TSO address space, which is sitting there waiting for the next input.
```bash
zowe tso send address-space {Z58577-118-aaboaaat} --data "5"
```

### 👉Step 6: Finished

- Now submit the job `CHKREXX1` from `ZXP.PUBLIC.JCL` to validate the correct output from code (`CC`) of `0000`.

## 🔗Links
- 👯 Web hosting company [EliasDH.com](https://eliasdh.com).
- 📫 How to reach us elias.dehondt@outlook.com