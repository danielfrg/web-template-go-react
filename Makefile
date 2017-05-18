BIN := web-template

PKG := github.com/danielfrg/web-template/go

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

# Build and package the application into a binary
all: build

# Download the dependencies of the project
devsetup:
	go get github.com/pilu/fresh; \
	go get -u github.com/jteeuwen/go-bindata/...; \
	go get -u github.com/golang/protobuf/protoc-gen-go; \
	go get -u github.com/improbable-eng/grpc-web/go/grpcwebproxy; \
	pushd go; dep ensure; popd; \
	pushd ts; yarn install; popd; \
	conda create -y -p ./python/env python=2.7; \
	pushd python; ./env/bin/pip install -r requirements.txt; popd;

# Generate protobuf code
proto:
	mkdir -p ./go/_proto ./ts/src/_proto ./python/_proto; \
	protoc -I ./protos \
		--plugin=protoc-gen-ts=./ts/node_modules/.bin/protoc-gen-ts \
		--plugin=protoc-gen-go=${GOBIN}/protoc-gen-go \
		--js_out=import_style=commonjs,binary:./ts/src/_proto \
		--go_out=plugins=grpc:./go/_proto \
		--ts_out=service=true:./ts/src/_proto \
		./protos/book_service.proto; \
    protoc -I ./protos \
		--plugin=protoc-gen-ts=./ts/node_modules/.bin/protoc-gen-ts \
		--js_out=import_style=commonjs,binary:./ts/src/_proto \
		--ts_out=service=true:./ts/src/_proto \
		./protos/helloworld.proto
	./python/env/bin/python -m grpc_tools.protoc -I ./protos --python_out=./python/_proto --grpc_python_out=./python/_proto ./protos/helloworld.proto

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
	cd go; GOOS=$(GOOS) GOARCH=$(GOARCH) go build -o $(APP) -ldflags="-X main.RepoVersion=${REPO_VERSION}" ${PKG}

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

# Start the python gRPC server
py-dev:
	cd python; python main.py

# Start the gRPC web proxy for the python server
py-proxy:
	grpcwebproxy --backend_tls=false --backend_tls_noverify --server_tls_cert_file=./misc/localhost.crt --server_tls_key_file=./misc/localhost.key --backend_addr=localhost:9001

# Generate self signed certs
certs:
	openssl req -x509 -sha256 -nodes -newkey rsa:2048 -days 1024 -keyout misc/localhost.key -out misc/localhost.crt

# Clean all created files by the build process
clean:
	rm -rf go/bin go/assets.go go/tmp ts/resources/static release

# Clean all created files by the build and setup process
cleanall: clean
	rm -rf go/vendor ts/node_modules python/env ts/npm-debug.log

package: go-bindata js-build go-build
	mkdir -p release; tar -cvzf "./release/$(BIN).$(REPO_VERSION)_$(GOOS)_$(GOARCH).tar.gz" ./go/bin/$(BIN)
