/*
** getip.c -- a hostname lookup demo
*/

#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <netdb.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>

int main(int argc, char *argv[])
{
	struct hostent *h;

	if (argc != 2) {  // error check the command line
		fprintf(stderr,"usage: getname address\n");
		exit(1);
	}

	if ((h=gethostbyaddr((void *)htonl(argv[1])), sizeof(struct sockaddr_in), AF_INET) == NULL) {  // get the host info
		herror("gethostbyip");
		exit(1);
	}

	printf("Host name  : %s\n", h->h_name);
	printf("IP Address : %s\n", inet_ntoa(*((struct in_addr *)h->h_addr)));
   
   return 0;
}
