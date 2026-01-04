.PHONY: default
default: compile

.PHONY: check-yaml-formatting
check-yaml-formatting:
	yamlfmt -verbose -lint -dstar .github/workflows/*

.PHONY: fix-yaml-formatting
fix-yaml-formatting:
	yamlfmt -verbose -dstar .github/workflows/*

.PHONY: check-github-actions-workflows-linting
check-github-actions-workflows-linting:
	actionlint -verbose -color

.PHONY: compile
compile:
	gcc -o shellcode-generator src/shellcode-generator.c

.PHONY: unit-test
unit-test:
	gcc -o shellcode-generator-tests tests/shellcode-generator-tests.c -lcunit

PAYLOAD_SOURCE=output.c
PAYLOAD_OBJECT=output
PAYLOAD_CFLAGS=-m32 -fno-stack-protector -z execstack

.PHONY: payload
payload: $(PAYLOAD_OBJECT)
	./$(PAYLOAD_OBJECT)

$(PAYLOAD_OBJECT): $(PAYLOAD_SOURCE)
	$(CC) -o $(PAYLOAD_OBJECT) $(PAYLOAD_SOURCE) $(PAYLOAD_CFLAGS)
