BIN := go-template

# This repo's root import path (under GOPATH).
PKG := github.com/danielfrg/go-web-template

######
# Variables below should not need tweaking
######

REPO_VERSION := $(shell git describe --tags --always --long)

APP := ./bin/$(BIN)

node_env = prod

ifdef DEBUG
	bindata_flags = -debug
	node_env = dev
endif

# Build and package the application into a binary
all: format build

# Build everything and package the application into a binary
build: npm-build go-build

# Format code
format:
	go fmt $(PKG)

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
devserve: bindata_flags = -debug
devserve: go-bindata
	fresh

# Build JS sources
npm-build:
	NODE_ENV=$(node_env) npm run build

# Start the npm build process with auto reload
npm-devserve:
	NODE_ENV=dev npm run devserve

# Download the dependencies of the project
devsetup:
	go get -u github.com/jteeuwen/go-bindata/...; \
	dep ensure; \
	yarn install

# Clean all created files by the build process
clean:
	rm -rf bin tmp resources/static

# Clean all created files by the build and setup process
cleanall:
	rm -rf bin tmp vendor node_modules npm-debug.log resources/static
