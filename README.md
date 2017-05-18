# Project template for Go + TS + gRPC

Template for:
- Go as a server and Typescript for frontend
- Go [gRPC web](https://github.com/improbable-eng/grpc-web) + Typescript as client
- Python + [gRPC web proxy](https://github.com/improbable-eng/grpc-web) + Typescript as client
- Package into single binary

## Dev setup

Requires:
- make
- `go` (+ [`dep`](https://github.com/golang/dep))
- `npm` (+ `yarn`)
- `conda` for python

Steps:
1. Clone repo
2. `make devsetup`

### How to run for development

1. Terminal 1 for npm build: `make js-dev`
1. Terminal 2 for Go web server + gRPC web: `make go-dev`
1. Terminal 3 for python gRPC: `make py-dev`
1. Terminal 4 for gRPC web proxy for python: `make py-proxy`

Changing Go code will be re-built by `fresh` and changing JS/TS will be re-built by npm/webpack automatically.

## Build

Build a single binary with assets included:

```
# Build binary
make

# Build and create tar.gz with binary
make package

# Build and package for another platform
GOOS=linux GOARCH=amd64 make package
```
