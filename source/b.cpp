/*
 */

#include <iostream>
#include <stdlib.h>
#include <string>
using namespace std;

int main() {
	//Declarations.
	string answer;
	int pings = 25;

	//Print title.
	cout << "program z \n";
	cout << "=============================================================\n";


	//Clean screen first?
	cout << "Do you want to clean the screen first? (yes/no)\n";
	cin >> answer;
	
	if ((answer.compare("yes")==0) || (answer.compare("y")==0) || (answer.compare("") ==0)) {
		system("clear");
		//Print title.
		cout << "Program z \n";
		cout << "=============================================================\n";
	}
	
	system("ifconfig eth0:1 192.168.100.200 netmask 255.255.255.0 2>> /dev/null");

	for (int i=0;i<pings;i++) {
		system("sudo ping -f 192.168.100.200 &");
	}


	//Kill processes.
	system("sudo killall ping");

	//End of program...
	cout << "\nEND .\n";

	return 0;	
}
