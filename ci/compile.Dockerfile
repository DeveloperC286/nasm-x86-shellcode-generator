FROM alpine:3.22.2@sha256:4b7ce07002c69e8f3d704a9c5d6fd3053be500b7f1c69fc0d80990c2ad8dd412

RUN apk add --no-cache \
	gcc=14.2.0-r6 \
	build-base=0.5-r3

WORKDIR /workspace

ENTRYPOINT ["gcc", "-o", "shellcode-generator", "src/shellcode-generator.c"]
