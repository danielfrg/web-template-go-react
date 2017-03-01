BIN := go-template

# This repo's root import path (under GOPATH).
PKG := github.com/danielfrg/go-web-template

VERSION := $(shell git describe --always --long)

######
# These variables should not need tweaking.
######

APP := ./bin/$(BIN)

# Build and package the application into a binary
all: build

# Build and package the application into a binary
build: npm-build
	go-bindata -pkg pkg -o ./pkg/assets.go ./dist/bundle.js ./dist/bundle.css; \
	go build -o $(APP) -ldflags="-X main.VERSION=${VERSION}" ${PKG}

# Build
npm-build:
	NODE_ENV=prod npm run build

# Server a built binary
serve:
	$(APP)

# Start the Go server with auto reload
devserve:
	go-bindata -debug -pkg pkg -o ./pkg/assets.go ./dist/bundle.js ./dist/bundle.css; \
	fresh

# Start the npm build process with auto reload
npm-devserve:
	NODE_ENV=dev npm run devserve

# Clean all created directories by the build process
cleanall:
	rm -rf bin tmp vendor node_modules dist npm-debug.log

# Download the dependencies of the project
devsetup:
	go get -u github.com/jteeuwen/go-bindata/... \
	dep ensure \
	npm install
