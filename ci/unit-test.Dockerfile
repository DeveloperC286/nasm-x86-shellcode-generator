FROM alpine:3.22.0@sha256:8a1f59ffb675680d47db6337b49d22281a139e9d709335b492be023728e11715

RUN apk add --no-cache \
	gcc=14.2.0-r6 \
	build-base=0.5-r3 \
	cunit-dev=2.1.3-r7

WORKDIR /workspace

ENTRYPOINT ["gcc", "-o", "shellcode-generator-tests", "tests/shellcode-generator-tests.c", "-lcunit"]
