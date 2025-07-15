FROM alpine:3.22.1@sha256:4bcff63911fcb4448bd4fdacec207030997caf25e9bea4045fa6c8c44de311d1

RUN apk add --no-cache \
	gcc=14.2.0-r6 \
	build-base=0.5-r3

WORKDIR /workspace

ENTRYPOINT ["gcc", "-o", "shellcode-generator", "src/shellcode-generator.c"]
