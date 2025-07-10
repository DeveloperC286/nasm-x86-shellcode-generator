DOCKER_RUN_OPTS := --rm -v $(PWD):/workspace -w /workspace

UID := $(shell id -u)
GID := $(shell id -g)
DOCKER_RUN_WRITE_OPTS := $(DOCKER_RUN_OPTS) -u $(UID):$(GID)

.PHONY: default
default: compile

# renovate: depName=ghcr.io/developerc286/clean_git_history
CLEAN_GIT_HISTORY_VERSION=1.0.4@sha256:5783341a3377a723e409e72b9ec0826a75ba944288d030978355de05ef65b186

.PHONY: check-clean-git-history
check-clean-git-history:
	docker run $(DOCKER_RUN_WRITE_OPTS) ghcr.io/developerc286/clean_git_history:$(CLEAN_GIT_HISTORY_VERSION) $(FROM)

# renovate: depName=ghcr.io/developerc286/conventional_commits_linter
CONVENTIONAL_COMMITS_LINTER_VERSION=0.15.0@sha256:b631a3cdcbed28c8938a2a6b63e16ecfd0d7ff71c28e878815adf9183e1fb599

.PHONY: check-conventional-commits-linting
check-conventional-commits-linting:
	docker run $(DOCKER_RUN_WRITE_OPTS) ghcr.io/developerc286/conventional_commits_linter:$(CONVENTIONAL_COMMITS_LINTER_VERSION) --allow-angular-type-only $(FROM)

# renovate: depName=mvdan/shfmt
SHFMT_VERSION=v3.11.0-alpine@sha256:394d755b6007056a2e6d7537ccdbdcfca01b9855ba91e99df0166ca039c9d422

.PHONY: check-shell-formatting
check-shell-formatting:
	docker run $(DOCKER_RUN_OPTS) mvdan/shfmt:$(SHFMT_VERSION) --simplify --diff ./ci/*

# renovate: depName=ghcr.io/google/yamlfmt
YAMLFMT_VERSION=0.17.0@sha256:b4ebf4ff064f5bcf779ef4799dad1fc52542e137677699210aea2de2b270e97f

.PHONY: check-yaml-formatting
check-yaml-formatting:
	docker run $(DOCKER_RUN_OPTS) ghcr.io/google/yamlfmt:$(YAMLFMT_VERSION) -verbose -lint -dstar .github/workflows/*

.PHONY: fix-shell-formatting
fix-shell-formatting:
	docker run $(DOCKER_RUN_WRITE_OPTS) mvdan/shfmt:$(SHFMT_VERSION) --simplify --write ./ci/*

.PHONY: fix-yaml-formatting
fix-yaml-formatting:
	docker run $(DOCKER_RUN_WRITE_OPTS) ghcr.io/google/yamlfmt:$(YAMLFMT_VERSION) -verbose -dstar .github/workflows/*

# renovate: depName=rhysd/actionlint
ACTIONLINT_VERSION=1.7.7@sha256:887a259a5a534f3c4f36cb02dca341673c6089431057242cdc931e9f133147e9

.PHONY: check-github-actions-workflows-linting
check-github-actions-workflows-linting:
	docker run $(DOCKER_RUN_OPTS) rhysd/actionlint:$(ACTIONLINT_VERSION) -verbose -color

.PHONY: compile
compile:
	docker build -t compile -f ci/compile.Dockerfile .
	docker run $(DOCKER_RUN_WRITE_OPTS) compile

.PHONY: unit-test
unit-test:
	docker build -t unit-test -f ci/unit-test.Dockerfile .
	docker run $(DOCKER_RUN_WRITE_OPTS) unit-test

PAYLOAD_SOURCE=output.c
PAYLOAD_OBJECT=output
PAYLOAD_CFLAGS=-m32 -fno-stack-protector -z execstack

payload: $(PAYLOAD_OBJECT)
	./$(PAYLOAD_OBJECT)

$(PAYLOAD_OBJECT): $(PAYLOAD_SOURCE)
	$(CC) -o $(PAYLOAD_OBJECT) $(PAYLOAD_SOURCE) $(PAYLOAD_CFLAGS)
