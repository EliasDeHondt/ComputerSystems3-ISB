#!/bin/bash
############################
# @author Elias De Hondt   #
# @see https://eliasdh.com #
# @since 19/09/2024        #
############################

mijnschijf="/dev/sdx"

(
echo o # Create a new empty DOS partition table
echo n # Add a new partition
echo p # Primary partition
echo 1 # Partition number
echo   # First sector (Accept default: 1)
echo   # Last sector (Accept default: last)
echo w # Write changes
) | sudo fdisk ${mijnschijf} 
