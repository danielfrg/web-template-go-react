# Go + JS project template

Simple template to use Go as a server and Typescript for frontend.
Plus handy tools for development and packaging into a single binary.

## Uses

Make for basic commands.

Go:
- [go dep](https://github.com/golang/dep) for dependencies
- [fresh](https://github.com/pilu/fresh/) for recompiling

JS (Typescript):
- [yarn](https://github.com/yarnpkg/yarn) for dependencies
- [webpack](https://webpack.js.org/) for compiling TS and bundling
- [livereload](http://livereload.com) for refreshing browser

## Dev setup

Requires:
- make`
- `go` (+ [`dep`](https://github.com/golang/dep) for dependencies)
- `npm` and `yarn`

Steps:
1. Clone repo
2. `make devsetup`

### How to run for development

1. Terminal 1 for Go server: `make devserve`
2. Terminal 2 for npm build: `make npm-devserve`

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
