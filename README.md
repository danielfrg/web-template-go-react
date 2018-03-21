# Go + React web template

Template for:
- Go as a server
- Typescript + React for frontend
- Package into single binary

## Dev setup

Requires:

- make
- go (+ dep)
- yarn

Steps:
1. Clone/fork repo
2. 
```
make devsetup
```
3. Rename (TODO)

### How to run for development

1. Terminal 1 for npm build: `make jsdev`
1. Terminal 2 for Go web server `make godev`
1. Open browser and activate live-reload

Changing Go code will be re-built by `fresh` and changing JS/TS will be re-built by webpack automatically.

## Build

Build a single binary with assets included:

```
make
make package
```

Version is based on the git tag so `git tag 1.0` before building.
