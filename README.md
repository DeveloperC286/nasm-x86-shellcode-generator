# NASM x86 Shellcode Generator
[![Continuous Integration (CI)](https://github.com/DeveloperC286s-Open-Source/starlingbanktechnicalchallenge/actions/workflows/continuous-integration.yml/badge.svg)](https://github.com/DeveloperC286s-Open-Source/starlingbanktechnicalchallenge/actions/workflows/continuous-integration.yml)
[![Conventional Commits](https://img.shields.io/badge/Conventional%20Commits-1.0.0-yellow.svg)](https://conventionalcommits.org)
[![License](https://img.shields.io/badge/License-AGPLv3-blue.svg)](https://www.gnu.org/licenses/agpl-3.0)


This program provides you with the utility to generate NASM x86 shellcode corresponding to your provided Shell/Bash command and arguments.
The assembly produced pushes the provided command and arguments onto the stack, then uses them as arguments in an execve system call.
The assembly generated uses various tricks not to include any null bytes; so that you can use the NASM generated in a buffer overflow attack.
Additionally, there are tricks used to allow odd length commands/arguments, which can not be padded.

Embedded into a char * is the hexadecimal representation of the generated assembly in an outputted proof of concept C file `output.c`.
Alongside the hexadecimal representation is the NASM assembly equivalent as comments, to allow you to understand the generated code.
You can ensure the generated assembly is functional and correct through compiling and executing the proof of concept C file.
The Makefile has the utility `make payload` to compile `output.c` with the relevant flags to allow execution on the stack to prove the correctness.


## Content
 * [Benefits](#benefits)
 * [Limitations](#limitations)
 * [Installation](#installation)
 * [CUnit Tests](#cunit-tests)
 * [Usage](#usage)
 * [Example Usage and Tips](#example-usage-and-tips)
 * [Recommended Resources](#recommended-resources)


## Benefits
 * The payload can include Bash commands which can't be called natively through a system call in assembly.
 * Faster and less error-prone than handcrafting shellcode.
 * Generates shellcode for lengthy/complex Bash which would be difficult to do by hand.
 * Through the use of `./shellcode-generator /bin/bash -c "<- commands ->"` you can execute multiple commands at once. Instead of singular command execution payload shellcode.


## Limitations
 * The smallest possible shellcode may not be generated. Especially for specific commands as it embeds it inside an execve call, instead of calling natively through a system call.


## Installation
 * Ubuntu: `apt-get install gcc libc6-dev-i386 make` - Needed to be able to compile C programs in 32bit architecture.
 * Arch: `pacman -Sy gcc lib32-gcc-libs lib32-glibc make` - Needed to be able to compile C programs in 32 bit architecture.
 * `make` - Compiles the generator `shellcode-generator.c` and outputs the binary to `shellcode-generator`.


## CUnit Tests
In order to execute the unit tests using the CUnit framework you will need to install CUnit.

 * Ubuntu: `apt-get install libcunit1-dev` - Needed to be able to compile CUnit framework tests.
 * Arch: `pacman -Sy cunit` - Needed to be able to compile CUnit framework tests.
 * `make test` - Compiles the CUnit tests and runs then, printing the results to the terminal.


## Usage
 * `./shellcode-generator <- desired command -> <- arguments ->` Invokes the generator which takes the provide Bash command and arguments and generates the corresponding shellcode, outputting the result to output.c.
 * `make payload` Compiles output.c with the relevant flags for stack execution of the char * and then executes the outputted binary to prove the functionality of the shellcode.


## Example Usage and Tips
Because of the techniques used to push strings whose length is not a multiple of four strings with no null bytes, the shellcode to push a non multiple can be larger than the shellcode to push a larger strings which is a multiple of four.
Strings can be padded so as to not affect the behavior but make them a multiple of four.

Below is an example to generate shellcode to call `/usr/bin/whoami`.
Running `./build.sh` to build the output.c and execute it we can see the length of the shellcode is 39 bytes.
As `/usr/bin/whoami` is 15 characters in length some techniques have to be used to push the non multiple.

| Command | Generated output.c |
|---------|--------------------|
| `./shellcode-generator /usr/bin/whoami` | http://pastebin.com/VjPrTH5B |

However paths can be padded with additional '/'s at any directory interval, without affecting the path.
In the example below one addition '/' is added to the beginning to get the length to 16.
As we can now see even though the string length has increased the shellcode byte size has reduced by 3 bytes, around an 8% reduction.

`//usr/bin/whoami` could be `/usr//bin/whoami` or `/usr/bin//whoami`.
Also the number of '/'s don't affect the path.
But only one was needed in this case to get to the optimal multiple of four, anymore than 1 would start to increase the shellcode size instead of decreasing it.

| Command | Generated output.c |
|---------|--------------------|
| `./shellcode-generator //usr/bin/whoami` | http://pastebin.com/6s9XAM8E |

Below is a more complicated example, the usage of `/bin/bash -c "<cmds>"` allows multiple commands to be executed within one payload and use the functionality of a Bash environment.
I.E. usage of $PATH so you don't need a commands full path.

| Command | Generated output.c |
|---------|--------------------|
| `./shellcode-generator /bin/bash -c "echo test > test.txt; ls; cat test.txt"` | http://pastebin.com/nvsd1qq3 |

The above example can be optimised.
`/bin/bash` is 9 characters in length we could pad it with 3 '/'s to 12 a multiple of 4.
But doing that produces longer shellcode than leaving it as `/bin/bash`.
Spaces inside the command can be removed shortening the string length without affecting the command.
Removing the spaces reduce it to 92 bytes in length, instead of the prior length of 97 bytes.

| Command | Generated output.c |
|---------|--------------------|
| `./shellcode-generator /bin/bash -c "echo test>test.txt;ls;cat test.txt"` | http://pastebin.com/eYhA7iHg |


## Recommended Resources
 * http://insecure.org/stf/smashstack.html
