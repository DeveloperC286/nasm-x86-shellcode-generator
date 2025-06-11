VERSION 0.7


COPY_CI_DATA:
    COMMAND
    COPY --dir "ci/" ".github/" "./"


COPY_METADATA:
    COMMAND
    DO +COPY_CI_DATA
    COPY --dir ".git/" "./"


alpine-base:
    FROM alpine:3.21.3@sha256:a8560b36e8b8210634f77d9f7f9efd7ffa463e380b75e2e74aff4511df3ef88c
    # renovate: datasource=repology depName=alpine_3_21/bash versioning=loose
    ENV BASH_VERSION="5.2.37-r0"
    RUN apk add --no-cache bash=$BASH_VERSION
    WORKDIR "/nasm-x86-shellcode-generator"


check-clean-git-history:
    FROM +alpine-base
    # renovate: datasource=github-releases depName=DeveloperC286/clean_git_history
    ENV CLEAN_GIT_HISTORY_VERSION="v1.0.3"
    RUN wget -O - "https://github.com/DeveloperC286/clean_git_history/releases/download/${CLEAN_GIT_HISTORY_VERSION}/x86_64-unknown-linux-musl.tar.gz" | tar xz --directory "/usr/bin/"
    DO +COPY_METADATA
    ARG from="origin/HEAD"
    RUN ./ci/check-clean-git-history.sh "${from}"


check-conventional-commits-linting:
    FROM +alpine-base
    # renovate: datasource=github-releases depName=DeveloperC286/conventional_commits_linter
    ENV CONVENTIONAL_COMMITS_LINTER_VERSION="v0.14.3"
    RUN wget -O - "https://github.com/DeveloperC286/conventional_commits_linter/releases/download/${CONVENTIONAL_COMMITS_LINTER_VERSION}/x86_64-unknown-linux-musl.gz" | gzip -d > /usr/bin/conventional_commits_linter && chmod 755 /usr/bin/conventional_commits_linter
    DO +COPY_METADATA
    ARG from_reference="origin/HEAD"
    RUN ./ci/check-conventional-commits-linting.sh --from-reference "${from_reference}"


golang-base:
    FROM golang:1.24.4@sha256:01f861b85f25cd045191578c87ed057b92bd185f2226bbf375c7510ebcb8abf4
    WORKDIR "/nasm-x86-shellcode-generator"


yaml-formatting-base:
    FROM +golang-base
    # renovate: datasource=github-releases depName=google/yamlfmt
    ENV YAMLFMT_VERSION="v0.17.0"
    RUN go install github.com/google/yamlfmt/cmd/yamlfmt@$YAMLFMT_VERSION
    COPY ".yamlfmt" "./"
    DO +COPY_CI_DATA


check-yaml-formatting:
    FROM +yaml-formatting-base
    RUN ./ci/check-yaml-formatting.sh


fix-yaml-formatting:
    FROM +yaml-formatting-base
    RUN ./ci/fix-yaml-formatting.sh
    SAVE ARTIFACT ".github/" AS LOCAL "./"


check-github-actions-workflows-linting:
    FROM +golang-base
    # renovate: datasource=github-releases depName=rhysd/actionlint
    ENV ACTIONLINT_VERSION="v1.7.7"
    RUN go install github.com/rhysd/actionlint/cmd/actionlint@$ACTIONLINT_VERSION
    DO +COPY_CI_DATA
    RUN ./ci/check-github-actions-workflows-linting.sh


COPY_SOURCECODE:
    COMMAND
    DO +COPY_CI_DATA
    COPY --dir "src/" "tests/" "./"


compile:
    FROM +alpine-base
    # renovate: datasource=repology depName=alpine_3_21/gcc versioning=loose
    ENV GCC_VERSION="14.2.0-r4"
    # renovate: datasource=repology depName=alpine_3_21/musl-dev versioning=loose
    ENV MUSL_VERSION="1.2.5-r9"
    RUN apk add --no-cache gcc=$GCC_VERSION musl-dev=$MUSL_VERSION
    DO +COPY_SOURCECODE
    RUN ./ci/compile.sh
