       IDENTIFICATION DIVISION.
       Program-id. cbl_json.
       Author. Student.
       ENVIRONMENT DIVISION.
       Input-output section.
       File-control.
           Select flyer assign to FLYRFILE.
       DATA DIVISION.
       File section.
       FD flyer recording mode V.
       1 flyer-file        pic x(10000) value spaces.
       Working-storage section.
       1 json-line         pic x(80) value spaces.
       1 json-doc          pic x(10000) value spaces.
       1 json-doc-1208     pic x(10000) value spaces.
       1 inv-data.
        2 inv-record occurs 7 times.
           3 prod-name     pic x(20).
           3 prod-img      pic x(99).
           3 expiry        pic 9(8).
           3 quantity      pic 9(3).
           3 salesperday   pic 9(3).
           3 price         pic 9(1)V9(2).
       1 end-of-json       pic x(1) value 'N'.
       1 inv-rec-cnt       pic 9(1) value 1.
       1 todays-date       pic 9(8) value 20210918.
       1 todays-date-int   pic 9(10).
       1 sale-end-date-int pic 9(10).
       1 prod-img-broken   pic x(99) value "https://ibmzxplore-static.s3
      -    ".eu-gb.cloud-object-storage.appdomain.cloud/unknown.png".
       1 pricefrmt         pic 9.99.
       1 saleprice         pic 9.99.
       1 discount          pic 9.99.
       1 productname       pic x(20).
       1 product-image-url pic x(99).
       1 daystoexpiry      pic ZZ9.
       1 daystosellall     pic ZZ9.
       1 expiry-date-int   pic 9(10).
       1 flyerformat       pic x(4).
       1 htmlheader1 pic x(151) value "<html><head><style>body{font-fami
      -    "ly:IBM Plex Sans;background:#98CEF4;color:black;}img{width:2
      -    "50px;}table{margin-left:auto;margin-right:auto;border:1px ".
       1 htmlheader2 pic x(151) value "solid black;width:250px;backgroun
      -    "d:white;}#title{text-align:center;font-family:IBM Plex Sans;
      -    "}.price{color:green;font-size:50px;}.discount{color:red;fo".
       1 htmlheader3 pic x(151) value "nt-size:20px;}.product{font-size:
      -    "15px;}#footer{text-align:center;font-size:larger;}</style></
      -    "head><body><div id=""title""><h1>Corner Grocery Store</h1>".
       1 htmltablestart    pic x(41) value "</div><table><tr><td colspan
      -    "=2><img src=""".
       1 htmlprice         pic x(35) value """></td></tr> <tr><td class=
      -    """price"">".
       1 htmldiscount      pic x(37) value "</td><td><span class=""disco
      -    "unt"">Save ".
       1 htmlproduct       pic x(33) value "</span><br><span class=""pro
      -    "duct"">".
       1 htmloldprice      pic x(9) value "<br>Was: ".
       1 htmltableend pic x(29) value "</span></td></tr></table><br>".
       1 htmlflyerfooter   pic x(20) value "<div id=""footer""><p>".
       1 htmlfooter        pic x(24) value "</p></div></body></html>".

       Linkage section.
       1 parameters-from-jcl.
         2 parameters-total-length pic 9(4) usage comp.
         2 parameter-values        pic x(20).

       PROCEDURE DIVISION using parameters-from-jcl.
           If parameters-total-length > 0 then
             Move function trim (parameter-values) to flyerformat
           End-if

           Perform until end-of-json = 'Y'
             Move spaces to json-line
             Accept json-line
             If json-line = '***'
               Move 'Y' to end-of-json
             Else
               String function trim(json-doc)
                      function trim(json-line)
                        delimited by size
                into json-doc
             End-if
           End-perform

           Move function display-of(
             function national-of(json-doc 1047) 1208) to
             json-doc-1208(1:function length(json-doc))

           Json parse json-doc-1208 into inv-data
           end-json

           Compute todays-date-int =
              function INTEGER-OF-DATE(todays-date)

           Open output flyer
           Initialize flyer-file
           If flyerformat = 'TEXT' then
              Move "Corner Grocery Store" to flyer-file
              Write flyer-file
           Else
              String htmlheader1 htmlheader2 htmlheader3
                 delimited by size into flyer-file
           Write flyer-file.

           Perform until inv-rec-cnt = 8
              Compute expiry-date-int =
                 function INTEGER-OF-DATE(expiry(inv-rec-cnt))
              Compute daystoexpiry =
                 expiry-date-int - todays-date-int
              Compute daystosellall rounded =
                 quantity(inv-rec-cnt) / salesperday(inv-rec-cnt)
              If daystoexpiry < daystosellall then
                 Move price(inv-rec-cnt) to pricefrmt
                 Compute saleprice = price(inv-rec-cnt) / 2
                 Compute discount =
                    price(inv-rec-cnt) - price(inv-rec-cnt) / 2

                 Move function trim(prod-name(inv-rec-cnt))
                    to productname

                 Move prod-img(inv-rec-cnt) to product-image-url

                 Initialize flyer-file
                 If flyerformat = 'TEXT' then
                    String productname saleprice
                       " Was: " pricefrmt
                        delimited by size
                    into flyer-file
                 Else
                    String
                      htmltablestart product-image-url
                      htmlprice "$"
                      saleprice htmldiscount "$" discount htmlproduct 
                      productname htmloldprice "$" pricefrmt 
                      htmltableend
                      delimited by size
                  into flyer-file
                 End-if
                 Write flyer-file
              End-if
              Add 1 to inv-rec-cnt
           End-perform

           Compute sale-end-date-int = todays-date-int + 7
           Initialize flyer-file
           If flyerformat not = 'TEXT' then
              Move htmlflyerfooter to flyer-file
              Write flyer-file
           End-if

           String
              "Flyer in effect "
              function formatted-date("YYYY-MM-DD" todays-date-int)
              " to "
              function formatted-date("YYYY-MM-DD" sale-end-date-int)
              delimited by size
              into flyer-file
           Write flyer-file

           If flyerformat not = 'TEXT' then
              Move htmlfooter to flyer-file
           Write flyer-file
           End-if

           Close flyer

           Goback.
       End program cbl_json.