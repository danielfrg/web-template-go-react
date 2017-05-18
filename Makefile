BIN := go-template

PKG := github.com/danielfrg/go-web-template/go

######
# Variables below should not need tweaking
######

GOOS := 
GOARCH := 

REPO_VERSION := $(shell git describe --tags --always --long)

APP := ./bin/$(BIN)

node_env = prod

ifdef DEBUG
	bindata_flags = -debug
	node_env = dev
endif

.PHONY: format build proto go-bindata go-build serve devserve npm-build npm-devserve devsetup clean cleanall release

# Build and package the application into a binary
all: build

# Download the dependencies of the project
devsetup:
	go get github.com/pilu/fresh; \
	go get -u github.com/jteeuwen/go-bindata/...; \
	go get -u github.com/golang/protobuf/protoc-gen-go; \
	pushd go; dep ensure; popd; \
	pushd ts; yarn install; popd

# Generate protobuf code
proto:
	mkdir -p ./go/_proto ./ts/src/_proto; \
	protoc \
		--plugin=protoc-gen-ts=./ts/node_modules/.bin/protoc-gen-ts \
		--plugin=protoc-gen-go=${GOBIN}/protoc-gen-go \
		-I ./proto \
		--js_out=import_style=commonjs,binary:./ts/src/_proto \
		--go_out=plugins=grpc:./go/_proto \
		--ts_out=service=true:./ts/src/_proto \
		./proto/book_service.proto

# Build everything and package the application into a binary
build: js-build go-build

# Server a built binary
serve:
	go/$(APP)

# Format code
format:
	go fmt $(PKG)
	
# Build go binary data
go-bindata:
	go-bindata $(bindata_flags) -pkg main -o ./go/assets.go -prefix ts/resources -ignore=\\.gitignore ./ts/resources/...

# Build go sources
go-build: go-bindata
	cd go; GOOS=$(GOOS) GOARCH=$(GOARCH) go build -o $(APP) -ldflags="-X ${PKG}/RepoVersion=${REPO_VERSION}" ${PKG}

# Start the Go server with auto reload
go-dev: bindata_flags = -debug
go-dev: go-bindata
	cd go; fresh

# Build JS sources
js-build:
	cd ts; NODE_ENV=$(node_env) yarn run build

# Start the npm build process with auto reload
js-dev:
	cd ts; NODE_ENV=dev yarn run devserve

# Clean all created files by the build process
clean:
	rm -rf go/bin go/tmp ts/resources/static release

# Clean all created files by the build and setup process
cleanall: clean
	rm -rf go/vendor ts/node_modules ts/npm-debug.log

release: go-bindata js-build go-build
	mkdir -p release; tar -cvzf "./release/$(BIN).$(REPO_VERSION)_$(GOOS)_$(GOARCH).tar.gz" ./go/bin/$(BIN)
