#include "types.h"
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
	if (argc != 2){
		printf(2, "incorrect number of arguments: %d\n", argc);
		exit(1);
	}
	int pl = atoi(argv[1]);
	if (pl < 0 || pl > 2){
		printf(2, "invalid number of policy: %d\n", pl);
		exit(1);		
	}
	policy(pl);
	printf(1, "policy changed successfully to %d\n", pl);
}
