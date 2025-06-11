# So new files are owned by the user.
UID := $(shell id -u)
GID := $(shell id -g)

.PHONY: check-clean-git-history check-conventional-commits-linting check-yaml-formatting fix-yaml-formatting check-github-actions-workflows-linting compile unit-test payload

check-clean-git-history:
	docker build -t check-clean-git-history -f ci/check-clean-git-history.Dockerfile .
	docker run --rm -v $(PWD):/workspace -u $(UID):$(GID) check-clean-git-history $(FROM)

check-conventional-commits-linting:
	docker build -t check-conventional-commits-linting -f ci/check-conventional-commits-linting.Dockerfile .
	docker run --rm -v $(PWD):/workspace -u $(UID):$(GID) check-conventional-commits-linting $(FROM)

check-yaml-formatting:
	docker pull ghcr.io/google/yamlfmt:0.17.0
	docker run --rm -v $(PWD):/workspace -u $(UID):$(GID) ghcr.io/google/yamlfmt:0.17.0 -verbose -lint -dstar .github/workflows/*

fix-yaml-formatting:
	docker pull ghcr.io/google/yamlfmt:0.17.0
	docker run --rm -v $(PWD):/workspace -u $(UID):$(GID) ghcr.io/google/yamlfmt:0.17.0 -verbose -dstar .github/workflows/*

check-github-actions-workflows-linting:
	docker pull rhysd/actionlint:1.7.7
	docker run --rm -v $(PWD):/workspace -w /workspace -u $(UID):$(GID) rhysd/actionlint:1.7.7 -verbose -color

compile:
	docker build -t compile -f ci/compile.Dockerfile .
	docker run --rm -v $(PWD):/workspace -u $(UID):$(GID) compile

unit-test:
	docker build -t unit-test -f ci/unit-test.Dockerfile .
	docker run --rm -v $(PWD):/workspace -u $(UID):$(GID) unit-test

PAYLOAD_SOURCE=output.c
PAYLOAD_OBJECT=output
PAYLOAD_CFLAGS=-m32 -fno-stack-protector -z execstack

payload: $(PAYLOAD_OBJECT)	
	./$(PAYLOAD_OBJECT)	

$(PAYLOAD_OBJECT): $(PAYLOAD_SOURCE)
	$(CC) -o $(PAYLOAD_OBJECT) $(PAYLOAD_SOURCE) $(PAYLOAD_CFLAGS)



