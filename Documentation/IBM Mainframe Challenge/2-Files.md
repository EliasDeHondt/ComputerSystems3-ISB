![logo](https://eliasdh.com/assets/media/images/logo-github.png)
# 💙🤍2 Files🤍💙

## 📘Table of Contents

1. [📘Table of Contents](#📘table-of-contents)
2. [📚Reference](#📚reference)
3. [✨Steps](#✨steps)
    1. [👉Step 1: Refine your filter](#👉step-1-refine-your-filter)
    2. [👉Step 2: Les's make some datasets](#👉step-2-less-make-some-datasets)
    3. [👉Step 3: Rename in the mainframe](#👉step-3-rename-in-the-mainframe)
    4. [👉Step 4: Member Deletion](#👉step-4-member-deletion)
    5. [👉Step 5: Copy and paste](#👉step-5-copy-and-paste)
    6. [👉Step 6: Sequential access](#👉step-6-sequential-access)
    7. [👉Step 7: Make your own member](#👉step-7-make-your-own-member)
    8. [👉Step 8: Record your victory](#👉step-8-record-your-victory)
4. [🔗Links](#🔗links)

---

## 📚Reference

- [📚IBM Mainframe Challenge](https://ibmzxplore-static.s3.eu-gb.cloud-object-storage.appdomain.cloud/FILES1.pdf)
- [📚Extra](https://s3.amazonaws.com/infl-prod-videos/ibmzxplore%2F1627919051273-Data+Sets+and+Members-rendered.mp4)

## ✨Steps

### 👉Step 1: Refine your filter

-  Click on the Magnifying Glass to the right of your `ZOWE` connection profile name `zxplore`, and enter the following:
    - Zxxxxx, ZXP.PUBLIC **(Please make sure to enter your own userid here, not Zxxxxx)**.
    - Also, make sure to note the comma before `ZXP.PUBLIC`.
- You have now set the filter to see not only your own Zxxxxx data sets, but the data sets starting with `ZXP.PUBLIC` as well.

### 👉Step 2: Les's make some datasets

- There is some code written specifically to build most of the data sets and members you will use for this challenge. You will find that in the `ZXP.PUBLIC.JCL` dataset.
- Open it up and look for a member called `PDSBUILD`. Right-click on that and select `Submit Job`.
- In your VSCode `DATA SETS` view, close and reopen your `zxplore` search view, by clicking on the "arrow" icons.
- Look for your `Zxxxxx.INPUT` data set. This is a Partitioned Data Set `PDS` and these are members inside it, just like `ZXP.PUBLIC.JCL`. (members = files)
- If at any time you want to reset back to Square 1 (the beginning) for this challenge, just submit the IBM Z Xplore `PDSBUILD` JCL from Step 3 again.

### 👉Step 3: Rename in the mainframe

- To view each member of your `INPUT` dataset, you will need to click on the member to see its contents load in the editor on the right side.
- One of the members will contain text directing you to rename it, and the name you should rename it to.
-  To rename a member, just right-click on it, and select Rename Member . Then simply enter the new name in the dialog box that pops up at the top of your VSCode window.

> Rename member `M6` to `PUBLIC`.

### 👉Step 4: Member Deletion

- In a similar way to the renaming step, track down the member in your `INPUT` dataset that is directing you to delete it. Right-click on that one and select `Delete Member`.

> Delete member `M1`.

### 👉Step 5: Copy and paste

- Look in your `SURPRISE` data set, because SURPRISE! there is yet another member in there for you.
- Open it up and read the contents. It will be asking you to copy it and then paste it into your `INPUT` data set.
- Start by Right-clicking on the source data set (the one you found in `SURPRISE`) and select `Copy`.
- With the source data set member safely copied, Right-click on your `INPUT` data set and select `Paste Member`. You will be prompted for a name
- This is a chance for you to move the contents of a file from one place to another with a new, unique name; but in this case, we want to keep the same name, so just call it what it originally was in the `SURPRISE` data set.

> Copy member `YELLOW` from `Zxxxxx.SURPRISE` to `Zxxxxx.INPUT`.

### 👉Step 6: Sequential access

- You been using the `INPUT` Partitioned Data Set (PDS) to hold the members for this challenge.
- Now let’s look at your `SEQDS` dataset.
- Instead of separate members, this data set just contains its own records. This is known as a Sequential Data Set.
- When you open it up, you see that each record is represented as a line in the dataset. Adding a new record is as simple as adding a new line and entering text.
- For this step, we want you to do just that; + add a new line (record) + say hello, tell us how the weather is, what your favorite cartoon is + save the file. And you’re done with this step.

> Open `Zxxxxx.SEQDS` and add a new line with the text `Hello, the weather is nice today. My favorite series is Game of Thrones.`

### 👉Step 7: Make your own member

-  Right-click on your `INPUT` dataset and select `Create New Member`.
- Give it the name of `MYNEWMBR` when prompted for a name. Creating a new member within a data set is as simple as that.
- If you get an error, make sure you’re not adding any additional spaces or punctuation, as member names can only be `1 to 8 characters`, made from - `letters (A-Z)` - `numbers (0-9)` - `@` - `#` - `$`.

### 👉Step 8: Record your victory

- At this point, you should have 5 members in your `INPUT` dataset.
    - Two that were there originally (`M4` and `M8`).
    - One that you renamed (`PUBLIC`).
    - One you created (`MYNEWMBR`).
    - One that you copied from `SURPRISE` (`YELLOW`).

- Your `SEQDS` data set should also have an additional record with your input.
- Double check your work, then find the `CHKFILES` member in `ZXP.PUBLIC.JCL`.
- Right-click on it and select `Submit Job` to hand in your work.
- If you have completed all the steps correctly, the validation job will complete with a "completion code" `CC` of `0000`.
- If you have missed a step or two, or not implemented an instruction correctly, the validation job will return a `CC` of `0127`.

## 🔗Links
- 👯 Web hosting company [EliasDH.com](https://eliasdh.com).
- 📫 How to reach us elias.dehondt@outlook.com