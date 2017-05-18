# Project template for Go + TS web server + gRPC

Simple template to use Go as a server and Typescript for frontend.

It also has example to have a gRPC based on [gRPC web](https://github.com/improbable-eng/grpc-web) and its proxy.

Includes handy tools for development and packaging into a single binary.

## Uses

Make for basic commands.

Go:
- [go dep](https://github.com/golang/dep) for dependencies
- [fresh](https://github.com/pilu/fresh) for recompiling

JS (Typescript):
- [yarn](https://github.com/yarnpkg/yarn) for dependencies
- [webpack](https://webpack.js.org/) for compiling TS and bundling
- [livereload](http://livereload.com) for refreshing browser

Python (external gRPC service)

## Dev setup

Requires:
- make
- `go` (+ [`dep`](https://github.com/golang/dep))
- `npm` and `yarn`
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
make release

# Build and release for another platform
GOOS=linux GOARCH=amd64 make release
```

## Clean

`make cleanall`
