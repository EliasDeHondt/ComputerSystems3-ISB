![logo](https://eliasdh.com/assets/media/images/logo-github.png)
# 💙🤍3 PDS1🤍💙

## 📘Table of Contents

1. [📘Table of Contents](#📘table-of-contents)
2. [📚Reference](#📚reference)
3. [✨Steps](#✨steps)
    1. [👉Step 1: Copy and Paste](#👉step-1-copy-and-paste)
    2. [👉Step 2: Run that job](#👉step-2-run-that-job)
    3. [👉Step 3: Give it new name](#👉step-3-give-it-new-name)
    4. [👉Step 4: Finished](#👉step-4-finished)
4. [🔗Links](#🔗links)

---

## 📚Reference

- [📚IBM Mainframe Challenge](https://ibmzxplore-static.s3.eu-gb.cloud-object-storage.appdomain.cloud/PDS1.pdf)

![IBM Fundamentals](/Images/IBM-Advanced.png)

## ✨Steps

### 👉Step 1: Copy and Paste

- When you hold your mouse over any data set or member, a Star icon shows up to the right of its name.
- Try this with your `SOURCE` data set, as you’ll be using it in upcoming challenges.

---

- Within the `ZXP.PUBLIC.INPUT` dataset, right-click on the `PDSPART1` member and select `Copy`.
- Then right-click on your `SOURCE` data set, which you added to your Favorites earlier, and select `Paste Member`.
- When prompted for a name, give it the same name it had before - `PDSPART1`.
- Do the same for `PDSPART2`.
- Finally, look in the `ZXP.PUBLIC.JCL` dataset for `PDS1CCAT`.
- Copy that into your JCL dataset.

### 👉Step 2: Run that job

- Right-click on the `PDS1CCAT` member in your JCL dataset and select `Submit Job`.
- After a few moments, collapse the `SOURCE` folder view using the small arrow to the left of it and then re-expand it.
- This will cause VSCode to refresh the view of contents of the PDS, where you should now see a brand new member created, called `PDS1OUT`.

### 👉Step 3: Give it new name

- Right-click on `PDS1OUT` and select `Rename`. Give it the new name of `RECIPE`.
- This will make it easier to find later, and is required for the validation job to mark this challenge as complete.

### 👉Step 4: Finished

- Now submit the job `CHKAPDS1` from `ZXP.PUBLIC.JCL` to validate the correct output from code (`CC`) of `0000`.

## 🔗Links
- 👯 Web hosting company [EliasDH.com](https://eliasdh.com).
- 📫 How to reach us elias.dehondt@outlook.com