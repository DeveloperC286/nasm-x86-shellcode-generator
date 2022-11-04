VERSION 0.6


COPY_METADATA:
    COMMAND
    COPY "./ci" "./ci"
    COPY ".git" ".git"


clean-git-history-checking:
    FROM rust
    RUN cargo install clean_git_history
    DO +COPY_METADATA
    ARG from="origin/HEAD"
    RUN ./ci/clean-git-history-checking.sh --from-reference "${from_reference}"


conventional-commits-linting:
    FROM rust
    RUN cargo install conventional_commits_linter
    DO +COPY_METADATA
    ARG from="origin/HEAD"
    RUN ./ci/conventional-commits-linting.sh --from-reference "${from_reference}"


INSTALL_LINTING_DEPENDENCIES:
    COMMAND
    RUN pacman -S clang --noconfirm


INSTALL_TESTING_DEPENDENCIES:
    COMMAND
    RUN pacman -S cunit --noconfirm


INSTALL_PAYLOAD_DEPENDENCIES:
    COMMAND
    RUN pacman -S lib32-gcc-libs lib32-glibc --noconfirm


COPY_SOURCECODE:
    COMMAND
    COPY "./ci" "./ci"
    COPY "./src" "./src"
    COPY "./tests" "./tests"


SAVE_OUTPUT:
    COMMAND
    SAVE ARTIFACT "shellcode-generator" AS LOCAL "shellcode-generator"


archlinux-base:
    FROM archlinux:base-devel
    WORKDIR /tmp/nasm-x86-shellcode-generator
    RUN pacman -Sy --noconfirm


check-formatting:
    FROM +archlinux-base
    DO +INSTALL_LINTING_DEPENDENCIES
    DO +COPY_SOURCECODE
    RUN ./ci/check-formatting.sh


fix-formatting:
    FROM +archlinux-base
    DO +INSTALL_LINTING_DEPENDENCIES
    DO +COPY_SOURCECODE
    RUN ./ci/fix-formatting.sh
    SAVE ARTIFACT "./src" AS LOCAL "./src"
    SAVE ARTIFACT "./tests" AS LOCAL "./tests"


linting:
    FROM +archlinux-base
    DO +INSTALL_LINTING_DEPENDENCIES
    DO +COPY_SOURCECODE
    RUN find "./src" "./tests" -type f -name "*.c" | xargs -I {} clang-tidy --checks="*,-llvmlibc-restrict-system-libc-headers,-altera-id-dependent-backward-branch,-altera-unroll-loops,-cert-err33-c" --warnings-as-errors="*" "{}"


compiling:
    FROM +archlinux-base
    DO +COPY_SOURCECODE
    RUN gcc -o "./shellcode-generator" "./src/shellcode-generator.c"
    DO +SAVE_OUTPUT


unit-testing:
    FROM +archlinux-base
    DO +INSTALL_TESTING_DEPENDENCIES
    DO +COPY_SOURCECODE
    RUN gcc -lcunit -o "./shellcode-generator-tests" "./tests/shellcode-generator-tests.c"
    RUN "./shellcode-generator-tests"


payload-compiling:
    FROM +archlinux-base
    DO +INSTALL_PAYLOAD_DEPENDENCIES
    COPY "./output.c" "./output.c"
    RUN gcc -o "./output" "./output.c" -m32 -fno-stack-protector -z execstack
    RUN "./output"
