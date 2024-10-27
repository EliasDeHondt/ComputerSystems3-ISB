![logo](https://eliasdh.com/assets/media/images/logo-github.png)
# 💙🤍9 ZOWE🤍💙

## 📘Table of Contents

1. [📘Table of Contents](#📘table-of-contents)
2. [📚Reference](#📚reference)
3. [✨Steps](#✨steps)
    1. [👉Step 1: Using zowe](#👉step-1-using-zowe)
    2. [👉Step 2: Using vsam](#👉step-2-using-vsam)
    3. [👉Step 3: Records](#👉step-3-records)
    4. [👉Step 4: Print](#👉step-4-print)
    5. [👉Step 5: Finished](#👉step-5-finished)
4. [🔗Links](#🔗links)

---

## 📚Reference

- [📚IBM Mainframe Challenge](https://ibmzxplore-static.s3.eu-gb.cloud-object-storage.appdomain.cloud/ZCLI1.pdf)

![IBM Fundamentals](/Images/IBM-Advanced.png)

## ✨Steps

### 👉Step 1: Using zowe

- You’ve been using the functionality of Zowe to issue commands and do all sorts of things through VSCode. In this challenge, you will use the standalone CLI component to do things in a different way, which can be useful in some situations.
- For example, to see what else can be done in the console group, enter the command `zowe console`. 
- You can see there is an option to issue commands, as well as collect responses. Those are two `sub command` groups within console.
- Use the command `zowe zos-jobs --help-examples` for a nice listing of zowe commands you can use related to z/OS jobs.
- Make sure you have your VSCode JOBS view active so that you can see your running jobs, and enter the command `zowe zos-jobs list jobs`.
- You get back a listing of actively running z/OS jobs that you have access to look at. Neat!
- Now, issue the same command with `--rfj` (Response Format JSON) after it.
- Now you get the FULL output, and the output is in JSON format, which can be much more easily interpreted by programs that prefer JSON format.
- Take a look at the `zowe files` command group and use that to `allocate` (create) a sequential dataset named `Zxxxxx.ZOWEPS`.
```powershell
zowe zos-files create data-set-sequential "Z58577.ZOWEPS" --recfm FB
```
- Next, use another zowe cli command to show the attributes of the dataset you just created. They should look similar to the following:
```powershell
zowe zos-files list ds "Z58577.ZOWEPS" -a
```
- Delete the `ZOWEPS` dataset and re-create that sequential data set with some customized attributes.
```powershell
zowe zos-files delete data-set "Z58577.ZOWEPS" -f
```
- The requirement this time is for the Record Length to be `120` instead of the default `80` and a specific block size of `9600`.
```powershell
zowe zos-files create data-set-sequential "Z58577.ZOWEPS" --lrecl 120 --blksize 9600 --recfm FB
```
- When you get it, you’ll see a different readout for the Block Size `blksz` and Record Length `lrecl` properties.
```powershell
zowe zos-files list ds "Z58577.ZOWEPS" -a
```

### 👉Step 2: Using vsam

- Make a VSAM data set called `Zxxxxx.VSAMDS`.
- When done, look at its attributes (you know how) and you’ll notice something pretty interesting; it looks like there are THREE data sets here.
```powershell
zowe zos-files create data-set-vsam "Z58577.VSAMDS"
```
- Now, look at the attributes of the VSAM data set you just created.
```powershell
zowe zos-files list ds "Z58577.VSAMDS" -a
```

### 👉Step 3: Records

- Empty datasets are not very useful - so now you’re going to add some records.
- You can use the existing sample data in `ZXP.PUBLIC.SAMPDATA`.
    - The first column (the “keys”) must be in (ascending) order.
    - Omit any blank records/rows.
    - You will need leading zeroes for keys, otherwise VSAM may not see them as being in order when you try to import.
    - Make sure this new input data is stored in a zOS sequential dataset or a PDS member.
- Download the sample `REPRO` member from the `ZXP.PUBLIC.JCL` dataset to your personal workstation, placing it in the directory you’re currently working from.
- Name your `REPRO` file as [repro.txt](/Source/repro.txt).
```powershell
zowe jobs submit local-file "repro.txt"
```
- You’ll see a nice little animation, and a job number. Check that job number and make sure it ran smoothly.
```powershell
zowe jobs view job-status-by-jobid "JOB04530" | Select-String "retcode"
```

### 👉Step 4: Print

- There is another very handy IDCAMS command to look at your data - the aptly-named `PRINT` command.
- Check out the example and pay attention to the CHARACTER parameter to help produce output.
- You’ll be putting together information from several sources here, so think about what you have, and what you want. You will want to print out that `VSAM` dataset in character format.
- The first 20 lines of output from an `IDCAMS PRINT` command, copy/pasted into a sequential `Zxxxxx.OUTPUT.VSAMPRNT` data set.
```jcl
//PRINTJOB JOB (Z58577),'PRINT VSAM'
//STEP1    EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
  PRINT - 
        INDATASET(Z58577.VSAMDS) -
        OUTDATSET(Z58577.OUTPUT.VSAMPRNT) -
        CHAR
/*
```
- Submit the job `PRINTJOB` from `Z58577.JCL` to print the `VSAM` dataset in character format.
```powershell
zowe jobs submit data-set "Z58577.JCL(PRINTJOB)"
```
- Get the status of the job and check the output.
```powershell
zowe jobs view job-status-by-jobid "JOB04534" | Select-String "retcode"
# Get the output
zowe files download data-set "Z58577.OUTPUT.VSAMPRNT" "C:\Users\elias\Downloads\Z58577.OUTPUT.VSAMPRNT.txt"
# open the file
notepad "C:\Users\elias\Downloads\Z58577.OUTPUT.VSAMPRNT.txt"
```

### 👉Step 5: Finished

- Now submit the job `CHKAZCLI` from `ZXP.PUBLIC.JCL` to validate the correct output from code (`CC`) of `0000`.

## 🔗Links
- 👯 Web hosting company [EliasDH.com](https://eliasdh.com).
- 📫 How to reach us elias.dehondt@outlook.com