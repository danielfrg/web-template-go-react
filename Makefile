BIN := go-template

# This repo's root import path (under GOPATH).
PKG := github.com/danielfrg/go-web-template

REPO_VERSION := $(shell git describe --tags --always --long)

######
# These variables should not need tweaking.
######

APP := ./bin/$(BIN)

# Build and package the application into a binary
all: build

# Build everything and package the application into a binary
build: npm-build go-build

# Build go sources
go-build:
	go-bindata -pkg pkg -o ./pkg/assets.go ./dist/bundle.js ./dist/bundle.css; \
	go build -o $(APP) -ldflags="-X ${PKG}/pkg.RepoVersion=${REPO_VERSION}" ${PKG}

# Build go sources with assets pointing to local files
go-build-dev:
	go-bindata -pkg pkg -debug -o ./pkg/assets.go ./dist/bundle.js ./dist/bundle.css; \
	go build -o $(APP) -ldflags="-X ${PKG}/pkg.RepoVersion=${REPO_VERSION}" ${PKG}

# Build JS sources
npm-build:
	NODE_ENV=prod npm run build

# Server a built binary
serve:
	$(APP)

# Start the Go server with auto reload
devserve: go-build-dev
	fresh

# Start the npm build process with auto reload
npm-devserve:
	NODE_ENV=dev npm run devserve

# Clean all created directories by the build process
cleanall:
	rm -rf bin tmp vendor node_modules dist npm-debug.log

# Download the dependencies of the project
setup:
	go get -u github.com/jteeuwen/go-bindata/...; \
	dep ensure; \
	npm install
