FROM alpine:3.22.0@sha256:8a1f59ffb675680d47db6337b49d22281a139e9d709335b492be023728e11715

RUN apk add --no-cache \
	gcc=14.2.0-r6 \
	build-base=0.5-r3

WORKDIR /workspace

ENTRYPOINT ["gcc", "-o", "shellcode-generator", "src/shellcode-generator.c"]
