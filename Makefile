BIN := binder

# This repo's root import path (under GOPATH).
PKG := github.com/danielfrg/go-web-template

VERSION := 1.0.0

######
# These variables should not need tweaking.
######

APP := ./bin/$(BIN)

all: build

build:
	npm run build; \
	go-bindata -pkg pkg -o ./pkg/assets.go ./dist/bundle.js ./dist/bundle.css; \
	go build -o ./bin/$(BIN)

serve:
	$(APP)

devserve:
	go-bindata -debug -pkg pkg -o ./pkg/assets.go ./dist/bundle.js ./dist/bundle.css; \
	fresh

npm-devserve:
	npm run devserve

cleanall:
	rm -rf bin tmp vendor node_modules dist npm-debug.log

devsetup:
	go get -u github.com/jteeuwen/go-bindata/... \
	dep ensure \
	npm install
