#include <string.h>
#include <stdio.h>
#include <unistd.h>
void printHex(const char *s);

//Assemlbly comments in NASM syntax.
char *shellcode="\x31\xc0" //xor eax, eax
"\xb0\x69" //movb al, 'i'
"\x50" //push eax
"\x31\xc0" //xor eax, eax
"\x66\x68\x61\x6d" //pushw 'am'
"\x68\x2f\x77\x68\x6f" //push '/who'
"\x68\x2f\x62\x69\x6e" //push '/bin'
"\x68\x2f\x75\x73\x72" //push '/usr'
"\x89\xe3" //mov ebx, esp
"\x50" //push eax
"\x53" //push ebx
"\x89\xe1" //mov ecx, esp
"\x50" //push eax
"\x89\xe2" //mov edx, esp
"\xb0\x0b" //mov al, 11
"\xcd\x80"; //int $0x80

int main() {
  printHex(shellcode);
  printf("%d Bytes.\n",strlen(shellcode));
  int (*ret)() = (int(*)())shellcode;
  ret();
}

void printHex(const char *s) {
  while (*s)
    printf("\\x%02x", (unsigned int) *s++ & 0xff);
  printf("\n");
}
