VERSION 0.6


clean-git-history-checking:
    FROM rust
    RUN cargo install clean_git_history
    COPY ".git" "."
    ARG from="origin/HEAD"
    RUN /usr/local/cargo/bin/clean_git_history --from-reference "${from}"


conventional-commits-linting:
    FROM rust
    RUN cargo install conventional_commits_linter
    COPY ".git" "."
    ARG from="origin/HEAD"
    RUN /usr/local/cargo/bin/conventional_commits_linter --from-reference "${from}" --allow-angular-type-only


clang-base:
    FROM archlinux:base
    RUN pacman -Sy --noconfirm
    RUN pacman -S clang cunit --noconfirm
    COPY "./src" "./src"
    COPY "./tests" "./tests"


check-formatting:
    FROM +clang-base
    RUN find "./src" "./tests" -type f -name "*.c" | xargs -I {} clang-format --dry-run --Werror "{}"


fix-formatting:
    FROM +clang-base
    RUN find "./src" "./tests" -type f -name "*.c" | xargs -I {} clang-format -i "{}"
    SAVE ARTIFACT "./src" AS LOCAL "./src"
    SAVE ARTIFACT "./tests" AS LOCAL "./tests"


linting:
    FROM +clang-base
    RUN find "./src" "./tests" -type f -name "*.c" | xargs -I {} clang-tidy --checks="*,-llvmlibc-restrict-system-libc-headers,-altera-id-dependent-backward-branch,-altera-unroll-loops,-cert-err33-c" --warnings-as-errors="*" "{}"


COPY_CI_DATA:
    COMMAND
    COPY "./ci" "./ci"
    COPY ".github" ".github"


check-github-actions-workflows-linting:
    FROM golang:1.20.4
    RUN go install github.com/rhysd/actionlint/cmd/actionlint@v1.6.24
    DO +COPY_CI_DATA
    RUN ./ci/check-github-actions-workflows-linting.sh


archlinux-base:
    FROM archlinux:base-devel
    RUN pacman -Sy --noconfirm
    RUN pacman -S lib32-gcc-libs lib32-glibc cunit --noconfirm
    COPY "./src" "./src"
    COPY "./tests" "./tests"


compiling:
    FROM +archlinux-base
    RUN gcc -o "./shellcode-generator" "./src/shellcode-generator.c"


unit-testing:
    FROM +archlinux-base
    RUN gcc -lcunit -o "./shellcode-generator-tests" "./tests/shellcode-generator-tests.c"
    RUN "./shellcode-generator-tests"


payload-compiling:
    FROM +archlinux-base
    COPY "./output.c" "./output.c"
    RUN gcc -o "./output" "./output.c" -m32 -fno-stack-protector -z execstack
    RUN "./output"
