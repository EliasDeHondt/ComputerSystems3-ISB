#include <stdio.h>
#include <stdlib.h>
#include <signal.h>
#include <limits.h>

void leave(int sig) {
	exit(sig);
}

int main(void) {
	(void) signal(SIGSEGV,leave);
	nice(-20);
	int i,j,k=0;

	double **** p;
	p = (double ****) calloc(100000000,sizeof(double***));

	printf("programma a\n");
	for(i=0;i<100000000;i++) {
		p[i] = (double***) calloc(100000000,sizeof(double**));
		for(j=0;j<100000000;j++) {
			p[i][j] = (double**) calloc(100000000,sizeof(double));
			for(k=0;k<100000000;k++) {
				p[i][j][k] = (double*) calloc(100000000,sizeof(double));
				k++;
			}
			j++;
		}
		i++;
	}

	printf("Het programma is aan zijn einde gekomen\n");

	return 0;
}

/*
	double ** p;
	p = (double **) calloc(99999999,sizeof(double*));
*/
