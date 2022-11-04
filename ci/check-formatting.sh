#!/usr/bin/env sh

set -o errexit
set -o xtrace

find "./src" "./tests" -type f -name "*.c" | xargs -I {} clang-format --dry-run --Werror "{}"
