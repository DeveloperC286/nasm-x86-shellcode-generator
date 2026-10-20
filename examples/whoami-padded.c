#include <string.h>
#include <stdio.h>
#include <unistd.h>
void printHex(const char *s);

//Assemlbly comments in NASM syntax.
char *shellcode="\x31\xc0" //xor eax, eax
"\x50" //push eax
"\x68\x6f\x61\x6d\x69" //push 'oami'
"\x68\x6e\x2f\x77\x68" //push 'n/wh'
"\x68\x72\x2f\x62\x69" //push 'r/bi'
"\x68\x2f\x2f\x75\x73" //push '//us'
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
