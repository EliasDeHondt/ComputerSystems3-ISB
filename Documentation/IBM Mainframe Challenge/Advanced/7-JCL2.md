![logo](https://eliasdh.com/assets/media/images/logo-github.png)
# 💙🤍7 JCL2🤍💙

## 📘Table of Contents

1. [📘Table of Contents](#📘table-of-contents)
2. [📚Reference](#📚reference)
3. [✨Steps](#✨steps)
    1. [👉Step 1: Create a JCL](#👉step-1-create-a-jcl)
    2. [👉Step 2: Finished](#👉step-2-finished)
4. [🔗Links](#🔗links)

---

## 📚Reference

- [📚IBM Mainframe Challenge](https://ibmzxplore-static.s3.eu-gb.cloud-object-storage.appdomain.cloud/JCL2.pdf)

![IBM Fundamentals](/Images/IBM-Advanced.png)

## ✨Steps

### 👉Step 1: Create a JCL

- Look in `ZXP.PUBLIC.JCL` for a member called `JES2JOB1`.
- This is the JCL you will be working with for this challenge.
- Right-click on it and select `Copy`.
- Locate your own `Zxxxxx.JCL` data set, right-click on it, and select `Paste`.
- This will, aof course, put a new copy of the `JES2JOB1` member into your JCL data set, so you can edit it.
- When pasting, you will be prompted to enter a name. Usually, you just want to enter the same name as the source - which is exactly what you should do here.
- Click on the `JES2JOB1` member and review the code.
- It looks like it will be running the `IRXJCL` program with a `COMBINE` parameter.
- It will be doing something in your `OUTPUT` data set, and will also be using two members from the `ZXP.PUBLIC.SOURCE` data set.
- Right-click on on your `JES2JOB1` JCL member and select `Submit Job`.
- In the VSCode left-side navigation area, go to the JOBS section and find the job you just submitted, which matches the job name that popped up in the previous Step.
- You will notice that it shows a completion code `CC 0008`. That is a `condition code`, and `8` means that there was definitely an error.
- Look through the output that the failed job created. You may not be able to make sense of much of this, but one line in the `JESYSMSG` section gives a very clear clue about why the program didn’t run correctly.
- Edit your copy of `JES2JOB1` and try to fix the problem.
- There is one missing line of code which you need to add.
- You can use the `BRAND DD` Statement as a reference for the line you need to create, but there are two parts of that line that you will need to change to make the job work correctly.

> **Note:** And remember, spacing matters! Make sure those columns line up.

---

- Add the following line to your `JES2JOB1` JCL code:
```jcl
//ARTIST    DD DSN=ZXP.PUBLIC.SOURCE(ARTIST),DISP=SHR
```

- Once you have saved your changes, right-click and select `Submit Job`, again noting the number that pops up so you can easily find it in the JOBS section.
- When corrected, the job should produce output in your `OUTPUT` data set called `JES2JOB1`.

### 👉Step 2: Finished

- Now submit the job `CHKJCL2` from `ZXP.PUBLIC.JCL` to validate the correct output from code (`CC`) of `0000`.

## 🔗Links
- 👯 Web hosting company [EliasDH.com](https://eliasdh.com).
- 📫 How to reach us elias.dehondt@outlook.com