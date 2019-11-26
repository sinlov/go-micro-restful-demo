#!/usr/bin/env bash

# doc see https://developers.google.com/protocol-buffers/docs/reference/go-generated
# --go_out see https://github.com/golang/protobuf
# --micro_out see https://github.com/micro/protoc-gen-micro

def_out_pkg_name="demo"
def_out_folder_go="../model/${def_out_pkg_name}"

if [[ -d ${def_out_folder_go} ]]; then
	rm -rf ${def_out_folder_go}/
fi
mkdir -p ${def_out_folder_go}

protoc --go_out=${def_out_folder_go} --micro_out=${def_out_folder_go} *.proto
