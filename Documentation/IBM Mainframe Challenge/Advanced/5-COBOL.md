![logo](https://eliasdh.com/assets/media/images/logo-github.png)
# 💙🤍5 COBOL🤍💙

## 📘Table of Contents

1. [📘Table of Contents](#📘table-of-contents)
2. [📚Reference](#📚reference)
3. [✨Steps](#✨steps)

4. [🔗Links](#🔗links)

---

## 📚Reference

- [📚IBM Mainframe Challenge](https://ibmzxplore-static.s3.eu-gb.cloud-object-storage.appdomain.cloud/CBLH.pdf)

![IBM Fundamentals](/Images/IBM-Advanced.png)

## ✨Steps

### 👉Step 1: Modify cobol code

- Create yourself a COBOL source “library” – from your VSCode terminal, allocate a new partitioned dataset using the zowe CLI:
    ```powershell
    zowe files create pds 'Z58577.CBL' --data-class spds
    ```
- Open the source dataset `ZXP.PUBLIC.SOURCE` and copy the `JSONCBL` and `JSONJCL` members into your own CBL and JCL datasets, as `CBLJSON` and `JSONJCL` respectively.
- Open your COBOL source file `CBLJSON` by doing `Select View -> Problems` in the top menu.
- Once they are resolved, the “Problems” tab should show 0 errors and there should be no red underlines in your COBOL program.
- Save using File -> Save or Ctrl+S.
- Right-click your JCL member `JSONJCL` and select `Submit Job`.
- The JCL script compiles and runs the COBOL program.

---

- Fix the errors in the COBOL program and recompile it.
```cobol
    PROCEDURE DIVISION using parameters-from-jcl.
        If parameters-total-length > 0 then
            Move function trim (parameter-values) to flyerformat
        End-if
* End
Compute todays-date-int =
    function INTEGER-OF-DATE(todays-date)
* End
File-control.
    Select flyer assign to FLYRFILE.
* End
If flyerformat = 'TEXT' then
    Move "Corner Grocery Store" to flyer-file
    Write flyer-file
* End
Move function trim(prod-img(inv-rec-cnt))
    to product-image-url
* End
Else
    String
        htmltablestart product-image-url
        htmlprice "$"
        saleprice htmldiscount "$" discount htmlproduct 
        productname htmloldprice "$" pricefrmt 
        htmltableend
* End
1 product-image-url pic x(99).
* End
1 inv-data.
    2 inv-record occurs 7 times.
        3 prod-name     pic x(20).
        3 prod-img      pic x(99).
        3 expiry        pic 9(8).
        3 quantity      pic 9(3).
        3 salesperday   pic 9(3).
        3 price         pic 9(1)V9(2).
```
-  Perhaps there is a parameter to pass to the program to add HTML formatting?
```JCL
//* //RUNPROG   EXEC PGM=CBLJSON,PARM=('TEXT')
//* To
//RUNPROG   EXEC PGM=CBLJSON,PARM=('HTML')
```
- [CBLCBL.cbl](/Scripts/CBLJSON.cbl)
- [cobol.html](/html/cobol.html)

- Right-click your JCL member `JSONJCL` and select `Submit Job`.
- Copy the output from the job in `cobol.html` in the home directory of your USS.

### 👉Step 5: Finished

- Now submit the job `CHKACBLH` from `ZXP.PUBLIC.JCL` to validate the correct output from code (`CC`) of `0000`.

## 🔗Links
- 👯 Web hosting company [EliasDH.com](https://eliasdh.com).
- 📫 How to reach us elias.dehondt@outlook.com