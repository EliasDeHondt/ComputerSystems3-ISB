![logo](https://eliasdh.com/assets/media/images/logo-github.png)
# 💙🤍3 JCL🤍💙

## 📘Table of Contents

1. [📘Table of Contents](#📘table-of-contents)
2. [📚Reference](#📚reference)
3. [✨Steps](#✨steps)
    1. [👉Step 1: Setup](#👉step-1-setup)
    2. [👉Step 2: Filter and find](#👉step-2-filter-and-find)
    3. [👉Step 3: You got a zero](#👉step-3-you-got-a-zero)
    4. [👉Step 4: Create a new JCL](#👉step-4-create-a-new-jcl)
    5. [👉Step 5: Kicking off some COBOL](#👉step-5-kicking-off-some-cobol)
    6. [👉Step 6: JCL3](#👉step-6-jcl3)
    7. [👉Step 7: Finished](#👉step-7-finished)
4. [🔗Links](#🔗links)

---

## 📚Reference

- [📚IBM Mainframe Challenge](https://ibmzxplore-static.s3.eu-gb.cloud-object-storage.appdomain.cloud/JCL1.pdf)

## ✨Steps

### 👉Step 1: Setup

- Look in `ZXP.PUBLIC.JCL` for a member named `JCLSETUP`.
- This is a fairly simple job that will allocate a few new data sets that you need for this, and other challenges.
- Right-click on that job and select `Submit Job`.

### 👉Step 2: Filter and find

- You should already have a profile under `JOBS` on the left side of VSCode.
- Click on the magnifying glass to the right of it.
    - Enter your userid for the Job Owner
    - Enter an asterisk ( * ) for the Job Prefix
    - Hit Enter (blank, no data) for Job Id Search

### 👉Step 3: You got a zero

- Open up the triangle "twistie" next to the `JCLSETUP` job you just submitted. There will probably be other jobs in there as well, but you are specifically looking for `JCLSETUP` . If you submitted it more than once, find the one with `CC 0000` to the right.
- You will also see this number in the `JESMSGLG` member once you open the twistie. A condition code `CC` of zero means everything ran as expected, with no errors, so that’s good!

### 👉Step 4: Create a new JCL

- Copy the `JCL1` member from `ZXP.PUBLIC.JCL` to your own `JCL` data set, and then open your copy. You need to have this in your own `JCL` dataset as you will be modifying it over the next few steps.
- You may need to close and re-open your `DATA SETS` triangle to refresh the view so your `JCL1` shows up.
- This job is provided so you can copy the `JCL2` member from `ZXP.PUBLIC.JCL` into your `JCL` dataset, but using the `IEBGENER` utility program instead of `VSCode`.
- Submit `JCL1` in the same way you submitted the `JCLSETUP`, and look at the joblog.
- When you you look at the `JOBS` section and see your `JCL1` job, you should see straight away that the completion code is **0012**; assume that means something went wrong.

---

- Open the `JES2:JESMSGLG` section of the job and check for an indication of what caused the failure.
- In this case, you can see that the problem is due to a missing `DD` statement for `SYSIN`.
- In `JCL`, statements that define where data is coming from, or going to, are known as Data Definition statements, or simply, "DD statements".
- In this job there are only two steps - both execute the `IEBGENER`  program; if you search online, you would eventually find the following  information about the setup for `IEBGENER`.
    - [IEBGENER](https://www.ibm.com/docs/en/zos/3.1.0?topic=c-job-control-statements-4).

- Old JCL1:
```jcl
//SYSUT    DD DISP=SHR,DSN=&SYSUID..JCL(JCL2)        <== FIX THIS ONE

//SYSUT    DD DISP=SHR,DSN=&SYSUID..JCL(JCL3)        <== AND THIS ONE
```

- New JCL1:
```jcl
//SYSUT2   DD DISP=SHR,DSN=&SYSUID..JCL(JCL2)

//SYSUT2   DD DISP=SHR,DSN=&SYSUID..JCL(JCL3)
```

### 👉Step 5: Kicking off some COBOL

- Edit your personal copy of the `JCL2` job definition.
- You may need to close and re-open your `DATA SETS` triangle to refresh the view, so your `JCL2` shows up.
- This JCL is used to compile and run some `COBOL` code.  After compiling, it will put the resulting program in your `LOAD` dataset.
- Look for the line that begins with `//COBRUN` - this is the start of a job "step" that will run the COBOL compiler.
- On the next line, you can see the input data set (the source) on Line 18 (`//COBOL.SYSIN`), and where it will put the output on the following line (`//LKED.SYSLMOD`).
- The lines following the start of the `//RUN` step have a similar format:
    ```jcl
    //ddname  DD DSN=dataset,DISP=access
    ```
    - "ddname" is also known as the filename - the name used by programs to access data in datasets.
    - "dataset" is the actual location of the data - this can change, but the program doesn’t need to be aware.
    - "access" (or "disposition") states how the program can use the dataset.
- Reading further, if the jobstep finishes with a Completion Code of 0 (because there were no problems) from the compile step, it will then run the `CBL0001` program.
- All making sense so far? You will be using JCL to compile `COBOL` source code, and then run the resulting program.

---

- After successfully compiling the COBOL code, `JES` will run the program (the `//RUN  EXEC PGM=CBL0001` command) and tell it where the find the input data sets, as well as where the output will be stored in your OUTPUT dataset:
    ```jcl
    //COMBINE   DD DSN=&SYSUID..OUTPUT(NAMES),DISP=SHR
    ```
- The name of the DD statement is what comes directly after the double slashes, so `FNAMES` and `LNAMES` for example.
- Submit `JCL2` from your JCL data set and then look at the output, using what you learned from the earlier steps in this challenge.

---

- The JCL statement beginning `//COBOL.SYSIN` points to the COBOL source code dataset it will compile, so start there. Open up that program source code in VSCode , and start by looking at the `FILE-CONTROL` area.
- This is where you get the names used by the program which you need to match in the JCL. For example, `FIRST-NAME` is a record reference in the 
`COBOL` code for a file, and that is assigned (or linked to) the `FNAMES` `DD` statement in the JCL.

- Cobol source code:
```cobol
      *-----------------------
       IDENTIFICATION DIVISION.
      *-----------------------
       PROGRAM-ID.    NAMES
       AUTHOR.        Otto B. Named
      *--------------------
       ENVIRONMENT DIVISION.
      *--------------------
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT FIRST-NAME ASSIGN TO FNAMES.
           SELECT LAST-NAME  ASSIGN TO LNAMES.
           SELECT FIRST-LAST ASSIGN TO COMBINED.
      *-------------
       DATA DIVISION.
      *-------------
       FILE SECTION.
       FD  FIRST-NAME RECORDING MODE F.
       01  FIRST-REC.
           05  FIRST-IN       PIC X(10).
           05  FILLER         PIC X(70).
      *
       FD  LAST-NAME RECORDING MODE F.
       01  LAST-REC.
           05  LAST-IN        PIC X(15).
           05  FILLER         PIC X(65).
      *
       FD  FIRST-LAST RECORDING MODE F.
       01  FIRST-LAST-REC.
           05  FIRST-OUT      PIC X(10).
           05  LAST-OUT       PIC X(15).
           05  FILLER         PIC X(55).
      *
       WORKING-STORAGE SECTION.
       01 FLAGS.
         05 LASTREC           PIC X VALUE SPACE.
      *------------------
       PROCEDURE DIVISION.
      *------------------
       OPEN-FILES.
           OPEN INPUT  FIRST-NAME.
           OPEN INPUT  LAST-NAME.
           OPEN OUTPUT FIRST-LAST.
      *
       READ-WRITE-UNTIL-LASTREC.
            PERFORM READ-FIRST-NAME
            PERFORM READ-LAST-NAME
            PERFORM UNTIL LASTREC = 'Y'
            PERFORM WRITE-COMBINED
            PERFORM READ-FIRST-NAME
            PERFORM READ-LAST-NAME
            END-PERFORM.
      *
       CLOSE-STOP.
           CLOSE FIRST-NAME.
           CLOSE LAST-NAME.
           CLOSE FIRST-LAST.
           GOBACK.
      *
       READ-FIRST-NAME.
           READ FIRST-NAME
           AT END MOVE 'Y' TO LASTREC
           END-READ.
      *
       READ-LAST-NAME.
           READ LAST-NAME
           END-READ.
      *
       WRITE-COMBINED.
           MOVE SPACES       TO  FIRST-LAST-REC
           MOVE FIRST-IN     TO  FIRST-OUT
           MOVE LAST-IN      TO  LAST-OUT
           WRITE FIRST-LAST-REC.
      *
```

- Old JCL2:
```jcl
//COMBINE  DD DSN=&SYSUID..OUTPUT(NAMES),DISP=SHR       <== FIX THIS ONE
```

- New JCL2:
```jcl
//COMBINED  DD DSN=&SYSUID..OUTPUT(NAMES),DISP=SHR
```

- Run the `JCL2` job and check the output.

### 👉Step 6: JCL3

- Submit your copy of the `JCL3` job and look at the output.

> **Note:** You should expect this job to complete with code 0000 – that means nothing is broken - it does not mean that the output is correct!

- There are two edits you need to make in order for this job to run 100% correctly:
    - A full listing of all **10 station stops**, from Poughkeepsie to Grand Central Terminal.
    - The information at the top and bottom of the data set.
    - You should have **no repeat stops**. If Beacon or Cortlandt is listed in there twice, something still needs fixing.

> **Note:**: You will need to delete the `JCL3OUT` output data set each time before re-submitting `JCL3`.

- New JCL2:
```jcl
//JCL3     JOB ,MSGLEVEL=(2,0)
//HEADER EXEC PGM=IEBGENER
//SYSPRINT DD DUMMY
//SYSIN    DD DUMMY
//SYSUT1   DD *
********************************************
METRO NORTH POUGHKEEPSIE -> NYC M-F SCHEDULE
PEAK HOUR OPERATION
********************************************
//SYSUT2   DD DSN=&SYSUID..JCL3OUT,DISP=(NEW,PASS,DELETE),
//            SPACE=(TRK,(1,1)),UNIT=SYSDA,
//            DCB=(DSORG=PS,RECFM=FB,LRECL=80)
//************************************************************//
//POK EXEC PGM=IEBGENER
//SYSPRINT DD DUMMY
//SYSIN    DD DUMMY
//SYSUT1   DD *
Poughkeepsie - 74mi
//SYSUT2   DD DSN=&SYSUID..JCL3OUT,DISP=(MOD,PASS,DELETE),
//            SPACE=(TRK,(1,1)),UNIT=SYSDA,
//            DCB=(DSORG=PS,RECFM=FB,LRECL=80)
//************************************************************//
//NHB EXEC PGM=IEBGENER
//SYSPRINT DD DUMMY
//SYSIN    DD DUMMY
//SYSUT1   DD *
New Hamburg - 65mi
//SYSUT2   DD DSN=&SYSUID..JCL3OUT,DISP=(MOD,PASS,DELETE),
//            SPACE=(TRK,(1,1)),UNIT=SYSDA,
//            DCB=(DSORG=PS,RECFM=FB,LRECL=80)
//************************************************************//
//BEACON EXEC PGM=IEBGENER
//SYSPRINT DD DUMMY
//SYSIN    DD DUMMY
//SYSUT1   DD *
Beacon - 59mi
//SYSUT2   DD DSN=&SYSUID..JCL3OUT,DISP=(MOD,PASS,DELETE),
//            SPACE=(TRK,(1,1)),UNIT=SYSDA,
//            DCB=(DSORG=PS,RECFM=FB,LRECL=80)
//************************************************************//
//CLDSPRNG EXEC PGM=IEBGENER
//SYSPRINT DD DUMMY
//SYSIN    DD DUMMY
//SYSUT1   DD *
Cold Spring - 52mi
//SYSUT2   DD DSN=&SYSUID..JCL3OUT,DISP=(MOD,PASS,DELETE),
//            SPACE=(TRK,(1,1)),UNIT=SYSDA,
//            DCB=(DSORG=PS,RECFM=FB,LRECL=80)
//************************************************************//
//GARRISON EXEC PGM=IEBGENER
//SYSPRINT DD DUMMY
//SYSIN    DD DUMMY
//SYSUT1   DD *
Garrison - 50mi
//SYSUT2   DD DSN=&SYSUID..JCL3OUT,DISP=(MOD,PASS,DELETE),
//            SPACE=(TRK,(1,1)),UNIT=SYSDA,
//            DCB=(DSORG=PS,RECFM=FB,LRECL=80)
//************************************************************//
//PEEKSKL EXEC PGM=IEBGENER
//SYSPRINT DD DUMMY
//SYSIN    DD DUMMY
//SYSUT1   DD *
Peekskill - 41mi
//SYSUT2   DD DSN=&SYSUID..JCL3OUT,DISP=(MOD,PASS,DELETE),
//            SPACE=(TRK,(1,1)),UNIT=SYSDA,
//            DCB=(DSORG=PS,RECFM=FB,LRECL=80)
//************************************************************//
//CORTLNDT EXEC PGM=IEBGENER
//SYSPRINT DD DUMMY
//SYSIN    DD DUMMY
//SYSUT1   DD *
Cortlandt - 38mi
//SYSUT2   DD DSN=&SYSUID..JCL3OUT,DISP=(MOD,PASS,DELETE),
//            SPACE=(TRK,(1,1)),UNIT=SYSDA,
//            DCB=(DSORG=PS,RECFM=FB,LRECL=80)
//************************************************************//
//CROTONH EXEC PGM=IEBGENER
//SYSPRINT DD DUMMY
//SYSIN    DD DUMMY
//SYSUT1   DD *
Croton-Harmon - 33mi
//SYSUT2   DD DSN=&SYSUID..JCL3OUT,DISP=(MOD,PASS,DELETE),
//            SPACE=(TRK,(1,1)),UNIT=SYSDA,
//            DCB=(DSORG=PS,RECFM=FB,LRECL=80)
//************************************************************//
//H125 EXEC PGM=IEBGENER
//SYSPRINT DD DUMMY
//SYSIN    DD DUMMY
//SYSUT1   DD *
Harlem - 125th Street - 4mi
//SYSUT2   DD DSN=&SYSUID..JCL3OUT,DISP=(MOD,PASS,DELETE),
//            SPACE=(TRK,(1,1)),UNIT=SYSDA,
//            DCB=(DSORG=PS,RECFM=FB,LRECL=80)
//************************************************************//
//GCT EXEC PGM=IEBGENER
//SYSPRINT DD DUMMY
//SYSIN    DD DUMMY
//SYSUT1   DD *
Grand Central Terminal - 0mi
//SYSUT2   DD DSN=&SYSUID..JCL3OUT,DISP=(MOD,PASS,DELETE),
//            SPACE=(TRK,(1,1)),UNIT=SYSDA,
//            DCB=(DSORG=PS,RECFM=FB,LRECL=80)
//************************************************************//
//PEAKINFO EXEC PGM=IEBGENER
//SYSPRINT DD DUMMY
//SYSIN    DD DUMMY
//SYSUT1   DD *
**************************************************************
Peak fares are charged during business rush hours on any
weekday train scheduled to arrive in NYC terminals between
6 a.m. and 10 a.m. or depart NYC terminals between 4 p.m.
and 8 p.m. On Metro-North trains, peak fares also apply to
travel on any weekday train that leaves Grand Central Terminal
between 6 a.m. and 9 a.m.
Off-peak fares are charged all other times on weekdays, all
day Saturday and Sunday, and on holidays.
//SYSUT2   DD DSN=&SYSUID..JCL3OUT,DISP=(MOD,CATLG,DELETE),
//            SPACE=(TRK,(1,1)),UNIT=SYSDA,
//            DCB=(DSORG=PS,RECFM=FB,LRECL=80)
//************************************************************//
```

- Submit `JCL3` again and check to see if you have the correct output.

### 👉Step 7: Finished

- Now submit the job `CHKJCL1` from `ZXP.PUBLIC.JCL` to validate the correct output from code (`CC`) of `0000`.

## 🔗Links
- 👯 Web hosting company [EliasDH.com](https://eliasdh.com).
- 📫 How to reach us elias.dehondt@outlook.com