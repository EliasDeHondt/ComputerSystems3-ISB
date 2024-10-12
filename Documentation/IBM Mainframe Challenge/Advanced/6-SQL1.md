![logo](https://eliasdh.com/assets/media/images/logo-github.png)
# 💙🤍6 SQL1🤍💙

## 📘Table of Contents

1. [📘Table of Contents](#📘table-of-contents)
2. [📚Reference](#📚reference)
3. [✨Steps](#✨steps)
    1. [👉Step 1: Install DB2 and Java in VSCode](#👉step-1-install-db2-and-java-in-vscode)
    2. [👉Step 2: Let's learn the basics](#👉step-2-lets-learn-the-basics)
    3. [👉Step 3: The challenge](#👉step-3-the-challenge)
    4. [👉Step 4: Finished](#👉step-4-finished)
4. [🔗Links](#🔗links)

---

## 📚Reference

- [📚IBM Mainframe Challenge](https://ibmzxplore-static.s3.eu-gb.cloud-object-storage.appdomain.cloud/SQL1.pdf)

![IBM Fundamentals](/Images/IBM-Advanced.png)

## ✨Steps

### 👉Step 1: Install DB2 and Java in VSCode

- Install IBM Db2 extension for Visual Studio Code.
- Install Java extension for Visual Studio Code.
- In the VSCode left-side menu, navigate to `Db2 Developer Extension` and click the plus sign to add a new connection profile.
- Enter the following values for the profile configuration:
    - `DALLASC` for location name.
    - `204.90.115.200` for host.
    - `5040` for port.
    - Your z/OS login for User ID and password.
- Unless you want to type your password every time you start doing SQL queries, check the `Save password` box.
- Then click `Finish` at the bottom and you should be setup and ready to use Db2!

### 👉Step 2: Let's learn the basics

- Let's use the following [SQL file](/Scripts/sql/sample.sql) to learn the basics of SQL.
- For this part, focus on:
```sql
SELECT * FROM ibmuser.emp;
```
- Highlight the statement and right-click to see options to run. Choose `Run SQL Statement`.
- The `SQL Results` tab will pop up after the statement is run and this is where you can view the set of records as a result of your SQL statement.

---

- Not only can you specify the columns you want to select, but you can specify the rows as well.
- This is done by specifying the value of one (or more) of the columns so that only rows that meet the column values are displayed.
- For this part, focus on:
```sql
SELECT firstnme FROM ibmuser.emp WHERE job = 'MANAGER';
```

---

- There are also some functions that allow you to count, average, or sum the rows - these are called `aggregate` functions.
- For this part, focus on:
```sql
SELECT COUNT(*) FROM ibmuser.emp;
SELECT AVG(salary) FROM ibmuser.emp;
SELECT SUM(salary) FROM Iibmuser.emp;
SELECT MAX(salary) FROM ibmuser.emp;
SELECT MIN(salary) FROM ibmuser.emp;
```

---

- A `join` is the process of combining data from two or more tables based on some common domain of information.
- Rows from one table are paired with rows from another table when information in the corresponding rows match based on the joining criteria.
- In order to do this, a WHERE clause comes in handy again.
- You simply have to relate two common columns from two different tables by setting them equal to each other in the WHERE clause.
- For this part, focus on:
```sql
SELECT deptname, COUNT(empno)
        FROM ibmuser.dept D, ibmuser.emp E
        WHERE D.deptno = E.workdept
        GROUP BY deptname
        ORDER BY deptname;
```

### 👉Step 3: The challenge

- Your challenge is to query the maximum compensation (all the ways of paying someone) in each department sort by department name. Display the results as two columns - `DEPTNAME` and `MAX_COMPENSATION`. Make sure you know what all of the columns in each table are; perhaps write a list of the columns in each table. When you have the output you want, download it as a `.csv` file by clicking the File icon in the results tab. This will download it to your laptop/workstation.
- **Hint:** there is more than one column that counts as `compensation`!
- `COMM` is the "commission" columnn - it shows the amount an employee has been paid from the value of sales. 
- `BONUS` shows how much an employee has been paid because they have achieved targets, or for winning sales competitions.
- For this part, focus on:
```sql
SELECT D.deptname, MAX(E.salary + E.comm + E.bonus) AS MAX_COMPENSATION
        FROM ibmuser.dept D, ibmuser.emp E
        WHERE D.deptno = E.workdept
        GROUP BY D.deptname
        ORDER BY D.deptname;
```

### 👉Step 4: Finished

- [DB2OUT.csv](/Scripts/sql/DB2OUT.csv) is the output file you should have after running the query.
- It’s now time to validate the challenge, so after you’ve downloaded the `.csv` file, right-click on your `Zxxxxx.OUTPUT` data set and click on `Upload Member`. Then upload your .csv file. After uploading, rename the file as `DB2OUT` so the checker job can find it, and you should be good to go!
- Now submit the job `CHKSQL` from `ZXP.PUBLIC.JCL` to validate the correct output from code (`CC`) of `0000`.

## 🔗Links
- 👯 Web hosting company [EliasDH.com](https://eliasdh.com).
- 📫 How to reach us elias.dehondt@outlook.com