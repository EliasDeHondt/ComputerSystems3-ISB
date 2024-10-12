#!/bin/sh
############################
# @author Elias De Hondt   #
# @see https://eliasdh.com #
# @since 10/10/2024        #
############################

FILE1=animal1
FILE2=animal2
FILE3=animal3
DIRECTORY1=uss2output

: ${1?Make sure to run this with your name as the first parameter. Example: ./animals.sh Baron}
USERNAME=$1

echo "Checking for the files and folders"

if [ -s "$FILE1" ] && [ -s "$FILE2" ] && [ -s "$FILE3" ] && [ -d "$DIRECTORY1" ]; then
    echo "Everything looks good"
    cat $FILE1 $FILE2 $FILE3 > $DIRECTORY1/.animals

    cp $FILE1 $FILE2 $FILE3 $DIRECTORY1
    echo "Files have been copied!"

    echo "We're extremely happy to have $USERNAME on the system" > "$DIRECTORY1"/message
    MODELTYPE=$(uname -m)
    OS=$(uname -I)
    echo "The operating system is $OS running on a model type $MODELTYPE" >> "$DIRECTORY1"/message
    echo "" >> "$DIRECTORY1"/message
    echo "If $USERNAME looks out the window, they might say:" >> "$DIRECTORY1"/message

    for file in "$DIRECTORY1"/animal*
    do
        CURRENT_ANIMAL=$(cat $file)
        echo "Why hello there, $CURRENT_ANIMAL" >> "$DIRECTORY1"/message
    done

    echo "And they'll say back, \"Congratulations on finishing USS Part 2!\"" >> "$DIRECTORY1"/message

    echo "Script has run successfully! Check the 'message' file in the "$DIRECTORY1" directory"

else
    echo "Something is missing. Double-check the instructions and script"
fi