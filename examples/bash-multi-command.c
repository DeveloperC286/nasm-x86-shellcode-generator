#include <string.h>
#include <stdio.h>
#include <unistd.h>
void printHex(const char *s);

//Assemlbly comments in NASM syntax.
char *shellcode="\x31\xc0" //xor eax, eax
"\xb0\x68" //movb al, 'h'
"\x50" //push eax
"\x31\xc0" //xor eax, eax
"\x68\x2f\x62\x61\x73" //push '/bas'
"\x68\x2f\x62\x69\x6e" //push '/bin'
"\x89\xe3" //mov ebx, esp
"\x50" //push eax
"\x50" //push eax
"\x50" //push eax
"\x53" //push ebx
"\x89\xe1" //mov ecx, esp
"\x50" //push eax
"\x66\x68\x2d\x63" //pushw '-c'
"\x89\xe2" //mov edx, esp
"\x89\x51\x4" //mov [ecx+4], edx
"\x50" //push eax
"\x66\x68\x78\x74" //pushw 'xt'
"\x68\x73\x74\x2e\x74" //push 'st.t'
"\x68\x74\x20\x74\x65" //push 't te'
"\x68\x3b\x20\x63\x61" //push '; ca'
"\x68\x3b\x20\x6c\x73" //push '; ls'
"\x68\x2e\x74\x78\x74" //push '.txt'
"\x68\x74\x65\x73\x74" //push 'test'
"\x68\x74\x20\x3e\x20" //push 't > '
"\x68\x20\x74\x65\x73" //push ' tes'
"\x68\x65\x63\x68\x6f" //push 'echo'
"\x89\xe2" //mov edx, esp
"\x89\x51\x8" //mov [ecx+8], edx
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
