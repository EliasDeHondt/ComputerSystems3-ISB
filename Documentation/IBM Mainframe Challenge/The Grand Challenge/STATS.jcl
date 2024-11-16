//STATS    JOB ,MSGLEVEL=(2,0)
//HEADER EXEC PGM=IEBGENER
//SYSPRINT DD DUMMY
//SYSIN    DD DUMMY
//SYSUT1   DD *
CPU STATISTIEKEN:
  Aantal CPU's: 8
  Gemiddelde CPU-belasting: 75%
  Maximale CPU-belasting: 95%
  Minimale CPU-belasting: 30%

RAM STATISTIEKEN:
  Totale RAM: 64 GB
  Beschikbaar RAM: 12 GB
  Gebruikt RAM: 52 GB
  Gemiddeld RAM-gebruik: 81%

DISK STATISTIEKEN:
  Totaal schijfruimte: 2 PB
  Beschikbare schijfruimte: 450 TB
  Gebruikte schijfruimte: 1.55 PB
  Gemiddeld schijfgebruik: 78%

NETWERK STATISTIEKEN:
  Verkeer inkomend: 300 Mbps
  Verkeer uitgaand: 150 Mbps
  Gemiddelde vertraging: 25 ms
  Pakketverlies: 0.2%

SYSTEEM OPERATIE STATISTIEKEN:
  Uptime: 247 dagen, 13 uur
  Aantal herstarts: 2
//SYSUT2   DD DSN=&SYSUID..METRICS,DISP=(NEW,CATLG,DELETE),
//            SPACE=(TRK,(1,1)),UNIT=SYSDA,
//            DCB=(DSORG=PS,RECFM=FB,LRECL=80)
//* Due to security restrictions, it was not possible to retrieve
//* real-time system statistics from the mainframe. The following
//* statistics are simulated using technical parameters to represent
//* typical system performance. To make this as realistic as possible,
//* I also copied the UI from available statistic commands.