#!/usr/bin/env bash

rm -rf go/
mkdir -p go
protoc --go_out=go *.proto
