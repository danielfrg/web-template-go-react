BIN := go-template

# This repo's root import path (under GOPATH).
PKG := github.com/danielfrg/go-web-template

######
# Variables below should not need tweaking
######

REPO_VERSION := $(shell git describe --tags --always --long)

APP := ./bin/$(BIN)

node_env := prod
ifdef DEBUG
	bindata_flags = -debug
	node_env = dev
endif

# Build and package the application into a binary
all: build

# Build everything and package the application into a binary
build: npm-build go-build

# Build go binary data
go-bindata:
	go-bindata $(bindata_flags) -pkg pkg -o ./pkg/assets.go -prefix resources -ignore=\\.gitignore ./resources/...

# Build go sources
go-build: go-bindata
	go build -o $(APP) -ldflags="-X ${PKG}/pkg.RepoVersion=${REPO_VERSION}" ${PKG}

# Server a built binary
serve:
	$(APP)

# Start the Go server with auto reload
devserve: go-bindata
	fresh

# Build JS sources
npm-build:
	NODE_ENV=$(node_env) npm run build

# Start the npm build process with auto reload
npm-devserve:
	NODE_ENV=dev npm run devserve

# Clean all created directories by the build process
cleanall:
	rm -rf bin tmp vendor node_modules npm-debug.log resources/static

# Download the dependencies of the project
setup:
	go get -u github.com/jteeuwen/go-bindata/...; \
	dep ensure; \
	yarn install
