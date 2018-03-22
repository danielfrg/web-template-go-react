PREFIX ?= $(shell pwd)
GOPATH ?= $(HOME)/go
ENV ?= development

# Output dir
BUILDDIR := $(PREFIX)/build

# Project metadata
PKG := $(PREFIX:$(GOPATH)/src/%=%)
NAME := $(notdir $(PKG))
OWNER := $(notdir $(patsubst %/,%,$(dir $(PKG))))
BIN := $(BUILDDIR)/$(NAME)
VERSION := $(shell cat VERSION.txt)
GITCOMMIT := $(shell git rev-parse --short HEAD)
GITUNTRACKEDCHANGES := $(shell git status --porcelain --untracked-files=no)
ifneq ($(GITUNTRACKEDCHANGES),)
	GITCOMMIT := $(GITCOMMIT)-dirty
endif

# Bootstrap info
EXTERNAL_TOOLS = \
	github.com/pilu/fresh \
	github.com/gobuffalo/packr/...

# Build info
GOOS ?= $(shell go env GOOS)
GOARCH ?= $(shell go env GOARCH)
BUILDTAGS :=
CTIMEVAR=-X $(PKG)/version.GITCOMMIT=$(GITCOMMIT) -X $(PKG)/version.VERSION=$(VERSION)
GO_LDFLAGS=-ldflags "-w $(CTIMEVAR)"
GO_LDFLAGS_STATIC=-ldflags "-w $(CTIMEVAR) -extldflags -static"

# List the GOOS and GOARCH to build
GOOSARCHES = linux/amd64 windows/amd64 darwin/amd64

# Helpers
MD5_CMD=md5sum
SHA256_CMD=sha256sum
UNAME_S=$(shell uname -s)
ifeq ($(UNAME_S),Darwin)
	MD5_CMD=md5 -r
	SHA256_CMD=shasum -a 256
endif

all: clean jsbuild gobuild  ## Runs: clean, jsbuild, build

.PHONY: gobuild
gobuild:
	@packr
	go build -tags "$(BUILDTAGS)" $(GO_LDFLAGS) -o $(BIN) .
	@packr clean

.PHONY: serve
serve:
	@$(BIN)

.PHONY: jsbuild
jsbuild:
	@yarn run build

.PHONY: jsdev
jsdev:
	@yarn run watch

.PHONY: godev
godev:
	@fresh

define buildrelease
packr
GOOS=$(1) GOARCH=$(2) CGO_ENABLED=0 go build \
	 -o $(BUILDDIR)/$(NAME)-$(1)-$(2) \
	 -a -tags "$(BUILDTAGS) static_build netgo" \
	 -installsuffix netgo ${GO_LDFLAGS_STATIC} .;
$(MD5_CMD) $(BUILDDIR)/$(NAME)-$(1)-$(2) > $(BUILDDIR)/$(NAME)-$(1)-$(2).md5;
$(SHA256_CMD) $(BUILDDIR)/$(NAME)-$(1)-$(2) > $(BUILDDIR)/$(NAME)-$(1)-$(2).sha256;
endef

.PHONY: release
release: jsbuild ## Builds the cross-compiled binaries, naming them in such a way for release (eg. binary-GOOS-GOARCH)
	@echo "+ $@"
	$(foreach GOOSARCH,$(GOOSARCHES), $(call buildrelease,$(subst /,,$(dir $(GOOSARCH))),$(notdir $(GOOSARCH))))

.PHONY: bootstrap
bootstrap:  ## Installs the necessary go tools for development or build.
	@echo "==> Bootstrapping ${PKG}"
	@for t in ${EXTERNAL_TOOLS}; do \
		echo "--> Installing $$t" ; \
		go get -u "$$t"; \
	done
	@echo "--> Installing JS deps" ; \
	yarn install

.PHONY: deps
deps:  ## Updates all dependencies for this project.
	@echo "==> Updating deps for ${PKG}"
	dep ensure -update

.PHONY: tag
tag: ## Create a new git tag to prepare to build a release
	git tag -sa $(VERSION) -m "$(VERSION)"
	@echo "Run git push to push your new tag to GitHub"

.PHONY: clean
clean: ## Cleanup any build binaries or packages
	@rm -rf bin build dist release tmp *.log
	@find . -name '*-packr.go' -delete

.PHONY: cleanall
cleanall: clean  ## Clean + cleanup any build deps
	@rm -rf vendor node_modules

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
