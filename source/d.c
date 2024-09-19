#include <stdio.h>
#include <stdlib.h>

int main() {
    int counter=0;
    const char base[] = "abcdefgh";
    char command [200];
    int switcher = 0;

    printf("programma d \n");

    while(1) {
        sprintf(command, "cp /boot/vmlinuz /tmp/%s%d", base, counter);
        system(command);
        counter++;
        if (switcher == 0 & counter>100) {
            switcher = 1;
        }
    }
    return 0;
}