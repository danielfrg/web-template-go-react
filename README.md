# Go + JS project template

Simple template to use Go as a server and Typescript for frontend.
Plus handy tools for development and packaging into a single binary.

## Uses

Make for basic commands.

Go:
- [go dep](https://github.com/golang/dep) for dependencies
- [fresh](https://github.com/pilu/fresh/) for recompiling

JS (Typescript):
- [webpack](https://webpack.js.org/) for dependencies and building
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

Changing Go code will be re-built by `fresh` and changing JS or templates will be re-built by npm/webpack automatically.

## Build

Build a single binary with assets included:

```
make
```

## Clean

`make cleanall`
