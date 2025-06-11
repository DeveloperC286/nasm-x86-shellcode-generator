FROM alpine:3.22.0

RUN apk add --no-cache \
    gcc=14.2.0-r6 \
    build-base=0.5-r3

WORKDIR /workspace

ENTRYPOINT ["gcc", "-o", "shellcode-generator", "src/shellcode-generator.c"]