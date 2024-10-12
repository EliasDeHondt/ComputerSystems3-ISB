         START ,
         YREGS ,
FIBONACI CSECT ,
FIBONACI AMODE 31
FIBONACI RMODE ANY
*---------------------------------------------------------------------
* FIBONACCI SEQUENCE FIRST 40 RESULTS, invoke BPX1WRT to print
* to stdout in z/OS Unix
*---------------------------------------------------------------------
*---------------------------------------------------------------------
* Linkage and getmain
*---------------------------------------------------------------------
         BAKR  R14,0
         LR    R12,R15
         USING FIBONACI,R12
STOR1    STORAGE OBTAIN,LENGTH=WALEN1
         LR    R10,R1
         USING WAREA1,R10
         MVC   SAVEA1+4(4),=C'F1SA'
         LAE   R13,SAVEA1
*---------------------------------------------------------------------
* application logic
*---------------------------------------------------------------------
         MVI   RESULT,C' '
         MVC   RESULT+1(L'RESULT-1),RESULT
         MVC   WACALL(LDCALL),DCALL
         LA    R5,38
         LA    R2,0
         LA    R3,1
         LA    R6,RESULT
         ST    R6,BUFFADDR
         MVC   RESULT(8),=C'00000000'
         MVI   RESULT+8,X'15'
         BAS   R7,TOSTDOUT
LOOP     DS    0H
         LR    R4,R3
         AR    R2,R3
         CVD   R2,PACKED
         OI    PACKED+7,X'0F'
         UNPK  ZONED,PACKED
         MVC   RESULT(L'ZONED),ZONED
         MVI   RESULT+L'ZONED,X'15'
         BAS   R7,TOSTDOUT
         LR    R3,R2
         LR    R2,R4
         BCT   R5,LOOP
*---------------------------------------------------------------------
* Linkage and freemain, set return code RC (reg 15) to value of WORD1
*---------------------------------------------------------------------
         STORAGE RELEASE,ADDR=(R10),LENGTH=WALEN1
         LA    R15,0
         PR    ,
*---------------------------------------------------------------------
* Subroutine
*---------------------------------------------------------------------
TOSTDOUT DS    0H
         CALL  BPX1WRT,(FILEDESC,                                      x
               BUFFADDR,                                               x
               ALET,                                                   x
               WRITECNT,                                               x
               WARETVAL,                                               x 
               WARC,                                                   x
               WARSN),MF=(E,WACALL)
         BR R7
*---------------------------------------------------------------------
* constants and literal pool
*---------------------------------------------------------------------
DCALL    CALL  ,(0,0,0,0,0,0,0),MF=L
LDCALL   EQU   *-DCALL
ALET     DC    F'0'
FILEDESC DC    F'1'
WRITECNT DC    F'9'
         LTORG ,
*
WAREA1   DSECT
SAVEA1   DS    18F
PACKED   DS    CL8
ZONED    DS    CL8
RESULT   DS    CL32
WACALL   DS    CL(LDCALL)          
BUFFADDR DS    F
WARETVAL DS    F
WARC     DS    F
WARSN    DS    F
WALEN1   EQU   *-SAVEA1
         END   FIBONACI