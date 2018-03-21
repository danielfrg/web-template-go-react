GOPATH ?= $(HOME)/go

ENV := development
GO_ENV := $(ENV)
NODE_ENV := $(ENV)

MKFILE_PATH := $(lastword $(MAKEFILE_LIST))
CURRENT_DIR := $(patsubst %/,%,$(dir $(realpath $(MKFILE_PATH))))
BUILDDIR := $(CURRENT_DIR)/build

# Project metadata
PROJECT := $(CURRENT_DIR:$(GOPATH)/src/%=%)
OWNER := $(notdir $(patsubst %/,%,$(dir $(PROJECT))))
NAME := $(notdir $(PROJECT))
BIN := $(BUILDDIR)/$(NAME)
PKG := $(OWNER)/$(NAME)
GIT_COMMIT := $(shell git rev-parse --short HEAD)
GIT_TAG := $(shell git describe --tags --always --long)
VERSION := $(GIT_TAG)

EXTERNAL_TOOLS = \
	github.com/pilu/fresh

# Build info
GOOS ?= $(shell go env GOOS)
GOARCH ?= $(shell go env GOARCH)
BUILDTAGS :=
GOOSARCHES := linux/amd64 windows/amd64 darwin/amd64 linux/arm64 
CTIMEVAR := -X $(PKG)/version.GIT_TAG=$(GIT_TAG) -X $(PKG)/version.GIT_COMMIT=$(GIT_COMMIT)
GO_LDFLAGS := -ldflags "-w $(CTIMEVAR)"
GO_LDFLAGS_STATIC := -ldflags "-w $(CTIMEVAR) -extldflags -static"

MD5_CMD ?= md5 -r
SHA256_CMD ?= shasum -a 256

ifdef DEBUG
	GO_ENV := development
	NODE_ENV := development
endif

# Build single binary
all: clean jsbuild gobuild  ## Runs a clean, jsbuild, build

gobuild:
	@packr
	@go build -tags "$(BUILDTAGS)" $(GO_LDFLAGS) -o $(BIN) .
	@packr clean
.PHONY: build

serve:
	@$(BIN)
.PHONY: serve

jsbuild:
	@yarn run build
.PHONY: assets

jsdev:
	@yarn run watch
.PHONY: jsdev

godev:
	@fresh
.PHONY: godev

define buildrelease
GOOS=$(1) GOARCH=$(2) CGO_ENABLED=0 go build \
	 -o $(BUILDDIR)/$(NAME)-$(1)-$(2) \
	 -a -tags "$(BUILDTAGS) static_build netgo" \
	 -installsuffix netgo ${GO_LDFLAGS_STATIC} .;
$(MD5_CMD) $(BUILDDIR)/$(NAME)-$(1)-$(2) > $(BUILDDIR)/$(NAME)-$(1)-$(2).md5;
$(SHA256_CMD) $(BUILDDIR)/$(NAME)-$(1)-$(2) > $(BUILDDIR)/$(NAME)-$(1)-$(2).sha256;
endef

release: ## Builds the cross-compiled binaries, naming them in such a way for release (eg. binary-GOOS-GOARCH)
	@echo "+ $@"
	$(foreach GOOSARCH,$(GOOSARCHES), $(call buildrelease,$(subst /,,$(dir $(GOOSARCH))),$(notdir $(GOOSARCH))))
.PHONY: release

bootstrap:  ## Installs the necessary go tools for development or build.
	@echo "==> Bootstrapping ${PROJECT}"
	@for t in ${EXTERNAL_TOOLS}; do \
		echo "--> Installing $$t" ; \
		go get -u "$$t"; \
	done
	@yarn install
.PHONY: bootstrap

deps:  ## Updates all dependencies for this project.
	@echo "==> Updating deps for ${PROJECT}"
	@dep ensure -update
.PHONY: deps

clean: ## Cleanup any build binaries or packages
	@rm -rf bin build dist release tmp *.log
	@find . -name '*-packr.go' -delete
.PHONY: clean

cleanall: clean  ## Clean + cleanup any build deps
	@rm -rf vendor node_modules
.PHONY: cleanall

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
.PHONY: help
