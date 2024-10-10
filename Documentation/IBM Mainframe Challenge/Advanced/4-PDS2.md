![logo](https://eliasdh.com/assets/media/images/logo-github.png)
# 💙🤍4 PDS2🤍💙

## 📘Table of Contents

1. [📘Table of Contents](#📘table-of-contents)
2. [📚Reference](#📚reference)
3. [✨Steps](#✨steps)
    1. [👉Step 1: Upload the rocks](#👉step-1-upload-the-rocks)
    2. [👉Step 2: Create the ROCKS dataset](#👉step-2-create-the-rocks-dataset)
    3. [👉Step 3: Create a dataset](#👉step-3-create-a-dataset)
    4. [👉Step 4: Check the output](#👉step-4-check-the-output)
    5. [👉Step 5: Finished](#👉step-5-finished)
4. [🔗Links](#🔗links)

---

## 📚Reference

- [📚IBM Mainframe Challenge](https://ibmzxplore-static.s3.eu-gb.cloud-object-storage.appdomain.cloud/PDS2.pdf)

![IBM Fundamentals](/Images/IBM-Advanced.png)

## ✨Steps

### 👉Step 1: Upload the rocks

- Download the following files:
  - [Rocks 1](/source/rocks1.txt)
  - [Rocks 2](/source/rocks2.txt)
  - [Rocks 3](/source/rocks3.txt)

- Now upload these files into your dataset collection.
- Right-click on the `SOURCE` dataset and select `Upload member…`.
- You should be able to select multiple files, so go ahead and select all of the `rocks*.txt` files. Remember you may need to refresh the dataset view before they show up.

### 👉Step 2: Create the ROCKS dataset

- Locate `MERGSORT` in the `ZXP.PUBLIC.JCL` dataset and copy/paste that into your JCL dataset.
- Now submit the `MERGSORT` job.

### 👉Step 3: Create a dataset

- Select the `Create New Data Set` by right-clicking on your connection profile.
- Give it a name that starts with your HLQ (your userid), then PDS2, followed by any third qualifier 8 characters or less, that isn’t already used. For example, `Zxxxxx.PDS2.ANEWPDS` or `Zxxxxx.PDS2.PUMPKIN`.
- Select in the next step Data Set Partitioned, and finally select Dataset Allocate.

### 👉Step 4: Check the output

- Refresh the folder view of your `OUTPUT` dataset.
- Click on the new `ROCKSOUT` member and observe what the job did with the three input files.
- Rename the `ROCKSOUT` member to `PDS2OUT`.
- Lastly, delete any `PDS2.*` datasets you created earlier in this challenge.

### 👉Step 5: Finished

- Now submit the job `CHKAPDS2` from `ZXP.PUBLIC.JCL` to validate the correct output from code (`CC`) of `0000`.

## 🔗Links
- 👯 Web hosting company [EliasDH.com](https://eliasdh.com).
- 📫 How to reach us elias.dehondt@outlook.com