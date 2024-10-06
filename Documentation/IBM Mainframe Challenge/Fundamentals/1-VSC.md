![logo](https://eliasdh.com/assets/media/images/logo-github.png)
# 💙🤍1 VSC🤍💙

## 📘Table of Contents

1. [📘Table of Contents](#📘table-of-contents)
2. [📚Reference](#📚reference)
3. [✨Steps](#✨steps)
    1. [👉Step 1: Download Programs](#👉step-1-download-programs)
    2. [👉Step 2: Install Z open Editor](#👉step-2-install-z-open-editor)
    3. [👉Step 3: Create your profile](#👉step-3-create-your-profile)
    4. [👉Step 4: Connect to the mainframe](#👉step-4-connect-to-the-mainframe)
    5. [👉Step 5: Fixing Issues](#👉step-5-fixing-issues)
    6. [👉Step 6: Styling and profiling](#👉step-6-styling-and-profiling)
    7. [👉Step 7: Navigate and submit for VSCJCL](#👉step-7-navigate-and-submit-for-vscjcl)
4. [🔗Links](#🔗links)

---

## 📚Reference

- [📚IBM Mainframe Challenge](https://ibmzxplore-static.s3.eu-gb.cloud-object-storage.appdomain.cloud/VSC1.pdf)

## ✨Steps

### 👉Step 1: Download Programs

- **Download the file** `VSC1.pdf` from the [📚IBM Mainframe Challenge VSC1](https://ibmzxplore-static.s3.eu-gb.cloud-object-storage.appdomain.cloud/VSC1.pdf) link.
- **Download Nodejs** from the [📚Nodejs](https://nodejs.org/en/download/) link.
- **Download a Java runtime** from the [📚Java](https://www.java.com/en/download/) link.
- **Download Visual Studio Code** from the [📚Visual Studio Code](https://code.visualstudio.com/download) link.

### 👉Step 2: Install Z open Editor

- Open Visual Studio Code.
- Click on the Extensions icon.
- Search for Z Open Editor.
- Click on Install.
- You’ll notice a new icon at the bottom of the side bar on the left in Visual Studio Code. Click on it to open the Z Open Editor.

### 👉Step 3: Create your profile

- Click on the `Zowe` icon to launch the `Zowe Explorer` view.
- As you can see, there is an editor area to your right, and three sections on the left. You will explore those more later.
- Next, click the (+) Plus sign next to `DATA SETS` at the top of the `ZOWE` navigation area.
- The info you need for setting up the profile for connection to the mainframe server is detailed in the next step.
- **NOTE** `VSCode` prompt windows disappear if you switch between applications.
- This may be annoying if you are trying to copy/paste information from one window (a web browser) into it.
- You may want to line up your windows side-by-side, rather than switching between them.
---
1. Press the `+`.
2. Press the `Create a new Team Connection file`.
3. Press the `Global: in the Zone home directory`.
4. You will now see an edit session open on a file called `zowe.config.json` you will make a few changes to this file.
5. At the top of the file you will see a section named `zosmf`, and below it, another named `tso` - these need modified to enable connection to the 
`IBM Z XPlore` mainframe server.
- In the `zosmf` section, set the value of the `port` property to `10443`.
- In the `tso` section, set the value of the `account` property to `FB3`.
- In the `base` section, set the value of the `host` property to `204.90.115.200`.
- In the `base` section, set the value of the `rejectUnauthorized` property to `false`.

### 👉Step 4: Connect to the mainframe

- Mouse-over the new connection you just created under `DATA SETS` and click the magnifying glass next to it.
- In the window that pops up, type in your Z-userid and password.

### 👉Step 5: Fixing Issues

- If you get an error about invalid credentials, `REST API` Error, or see a red circle next to your profile name, it is possible that you typed in your username or password wrong.
- Simply right-click on the profile you created (zxplore , for example) and select `Update Profile`. This will let you re-enter all of your connection information, step by step.
- If you want to start all over again, simply right-click on it and select `Delete Profile`. 
- Because of the asynchronous nature of the plugin, sometimes it’s good to quit `VSCode` before updating, or after deleting a profile, as you may see an error message that is not accurate.
- When in doubt, restart `VSCode` . This clears up a lot of problems.

### 👉Step 6: Styling and profiling

-  Click the (+) next to `Unix System Services (USS)` and select the connection profile you created in Step 4. Repeat the step for `JOBS` down at the bottom section.

### 👉Step 7: Navigate and submit for VSCJCL

- Right click on your zone and press `Search data sets`.
- Then enter the filter `ZXP.PUBLIC.*`.
- Then go in the `ZXP.PUBLIC.JCL` folder and the right-click on `VSCJCL` file and press `Submit Job`.

- This is the contents of the mainframe job.
```jcl
//WSLJCL    JOB ,MSGLEVEL=(0,0)
//COMBINE   EXEC PGM=IRXJCL,PARM='WSL'
//SYSEXEC   DD DSN=ZXP.PUBLIC.EXEC,DISP=SHR
//SYSTSPRT  DD SYSOUT=*
//SYSTSIN   DD DUMMY
//IDIREPRT  DD DUMMY
//TAAM      DD DSN=ZXP.PUBLIC.DATA(team),DISP=SHR
//CITY      DD DSN=ZXP.PUBLIC.DATA(CITY),DISP=SHR
//STATE     DD DSN=ZXP.PUBLIC.DATA(STATE),DISP=SHR
//STADIUM   DD DSN=ZXP.PUBLIC.DATA(STADIUM),DISP=SHR
//CAPACITY  DD DSN=ZXP.PUBLIC.DATA(CAPACITY),DISP=SHR
//COACH     DD DSN=ZXP.PUBLIC.DATA(COACH),DISP=SHR
```

## 🔗Links
- 👯 Web hosting company [EliasDH.com](https://eliasdh.com).
- 📫 How to reach us elias.dehondt@outlook.com