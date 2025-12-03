FROM alpine:3.23.0@sha256:51183f2cfa6320055da30872f211093f9ff1d3cf06f39a0bdb212314c5dc7375

RUN apk add --no-cache \
	gcc=14.2.0-r6 \
	build-base=0.5-r3

WORKDIR /workspace

ENTRYPOINT ["gcc", "-o", "shellcode-generator", "src/shellcode-generator.c"]
