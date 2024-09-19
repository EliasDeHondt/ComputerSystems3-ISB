/*

 *      This program is free software; you can redistribute it and/or modify
 *      it under the terms of the GNU General Public License as published by
 *      the Free Software Foundation; either version 2 of the License, or
 *      (at your option) any later version.
 *
 *      This program is distributed in the hope that it will be useful,
 *      but WITHOUT ANY WARRANTY; without even the implied warranty of
 *      MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *      GNU General Public License for more details.
 *
 *      You should have received a copy of the GNU General Public License
 *      along with this program; if not, write to the Free Software
 *      Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
 */


#include <stdio.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

int main(int argc, char** argv)
{
    struct sockaddr_in servaddr;
    struct hostent *hp;
    int sock_id;
    char message[1024*1024] = {0};
    int msglen;
    char request[] = "GET / HTTP/1.0\n"
    "From: slava!!!\nUser-Agent: Firefox by slava - tweaked for KdG\n\n";
    if((sock_id = socket(AF_INET, SOCK_STREAM, 0)) == -1) {
        fprintf(stderr,"Couldn't get a socket.\n"); exit(EXIT_FAILURE);
    }
    //book uses bzero which my man pages say is deprecated
    //the man page said to use memset instead. :-)
    memset(&servaddr,0,sizeof(servaddr));
    if((hp = gethostbyname("localhost")) == NULL) {
        fprintf(stderr,"no address.\n"); exit(EXIT_FAILURE);
    }
    //bcopy is deprecated also, using memcpy instead
    memcpy((char *)&servaddr.sin_addr.s_addr, (char *)hp->h_addr, hp->h_length);
    servaddr.sin_port = htons(80);
    servaddr.sin_family = AF_INET;
    while (1==1) {
		if(connect(sock_id, (struct sockaddr *)&servaddr, sizeof(servaddr)) != 0) {
			fprintf(stderr, "DOS problem.\n");
		}
    write(sock_id,request,strlen(request));
    msglen = read(sock_id,message,1024*1024);
	}
	
    return 0;
}