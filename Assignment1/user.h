struct stat;
struct rtcdate;
struct perf; 

// system calls
int fork(void);
int exit(int status) __attribute__((noreturn)); // Ass1: task 2.1 
int wait(int *status); // Ass1: task 2.2
int pipe(int*);
int write(int, void*, int);
int read(int, void*, int);
int close(int);
int kill(int);
int exec(char*, char**);
int open(char*, int);
int mknod(char*, short, short);
int unlink(char*);
int fstat(int fd, struct stat*);
int link(char*, char*);
int mkdir(char*);
int chdir(char*); 
int dup(int);
int getpid(void);
char* sbrk(int);
int sleep(int);
int uptime(void);
int policy(int);
int wait_stat(int* ,struct perf*); 

// ulib.c
int stat(char*, struct stat*);
char* strcpy(char*, char*);
void *memmove(void*, void*, int);
char* strchr(const char*, char c);
int strcmp(const char*, const char*);
void printf(int, char*, ...);
char* gets(char*, int max);
uint strlen(char*);
void* memset(void*, int, uint);
void* malloc(uint);
void free(void*);
int atoi(const char*);

// our function
char* strcat(char *dest, const char *src) ;

