# Go + JS project template

Simple template to use Go as a server and JS for frontend.
Plus handy tools for development and packaging into a single binary.

## Uses

Make for basic commands

Go:
- [go dep](https://github.com/golang/dep) for dependencies
- [fresh](https://github.com/pilu/fresh/) for recompiling
- [martini](https://github.com/go-martini/martini) as web framework (very easy to change)

JS:
- [webpack](https://webpack.js.org/) for dependencies and building
- [livereload](http://livereload.com) for refreshing browser

## Dev setup

Requires: `make`, `go` (+ [`dep`](https://github.com/golang/dep) for dependencies), `npm`

1. Get repo
2. `make devsetup`

## How to use

1. Terminal 1 for Go server: `make devserve`
2. Terminal 2 for npm build: `make npm-build`

Changing Go code will be re-built by `fresh`
and changing JS or templates will be re-built
by npm/webpack automatically.

## Clean

`make cleanall`
