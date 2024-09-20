#!/bin/bash
#============================================================
#          FILE:  fdiskscript.sh
#         USAGE:  ./fdiskscript.sh
#   DESCRIPTION:  auto create partition on disk
#       OPTIONS:  none
#  REQUIREMENTS:  none
#        AUTHOR:  Jan Celis (jan.celis@kdg.be)
#       COMPANY:  KdG
#       VERSION:  20/09/2021 12:49:38 CET
#============================================================

mijnschijf="/dev/sdx" #replace by device 

(
echo o # Create a new empty DOS partition table
echo n # Add a new partition
echo p # Primary partition
echo 1 # Partition number
echo   # First sector (Accept default: 1)
echo   # Last sector (Accept default: last)
echo w # Write changes
) | sudo fdisk ${mijnschijf} 
