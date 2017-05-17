#!/bin/bash

set -e
set -x

bin=$1

if [ -z "$2" ]; then
    version=$(git describe --tags --always --long)
else
    version=$2
fi

GOOSS=("darwin" "windows" "linux")
GOARCHS=("amd64" "386")

for goos in "${GOOSS[@]}"; do
    for goarch in "${GOARCHS[@]}"; do
        echo "Building $goos $goarch $version"
        make GOOS=$goos GOARCH=$goarch go-build
        tar -cvzf "./release/$bin.$version.$goos.$goarch.tar.gz" ./bin/$bin
        rm -rf embedmd
    done
done
