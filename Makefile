BIN := binder

# This repo's root import path (under GOPATH).
PKG := github.com/danielfrg/binder

VERSION := 1.0.0

PID := go-server.pid

######
# These variables should not need tweaking.
######

APP := ./bin/$(BIN)

all: build

build:
	go build -o ./bin/$(BIN)

serve:
	$(APP)

# fresh |& tee /dev/tty |& grep runner > tmp/trigger.log
devserve:
	fresh

npm-build:
	npm run build

cleanall:
	rm -rf bin tmp vendor node_modules public npm-debug.log

devsetup:
	dep ensure \
	npm install
