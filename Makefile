.PHONY: test check clean build dist all

TOP_DIR := $(shell pwd)

DIST_VERSION := 1.0.0
DIST_OS := linux
DIST_ARCH := amd64

DIST_OS_DOCKER ?= linux
DIST_ARCH_DOCKER ?= amd64

ROOT_NAME ?= go-micro-restful-demo
ROOT_DOCKER_SERVICE ?= $(ROOT_NAME)
ROOT_BUILD_PATH ?= ./build
ROOT_DIST ?= ./dist
ROOT_REPO ?= ./dist
ROOT_TEST_BUILD_PATH ?= $(ROOT_BUILD_PATH)/test/$(DIST_VERSION)
ROOT_TEST_DIST_PATH ?= $(ROOT_DIST)/test/$(DIST_VERSION)
ROOT_TEST_OS_DIST_PATH ?= $(ROOT_DIST)/$(DIST_OS)/test/$(DIST_VERSION)
ROOT_REPO_DIST_PATH ?= $(ROOT_REPO)/$(DIST_VERSION)
ROOT_REPO_OS_DIST_PATH ?= $(ROOT_REPO)/$(DIST_OS)/release/$(DIST_VERSION)

ROOT_LOG_PATH ?= ./log

# can use as https://goproxy.io/ https://gocenter.io https://mirrors.aliyun.com/goproxy/
INFO_GO_PROXY ?= https://goproxy.io/

init:
	@echo "~> start init this project"
	@echo "-> check version"
	go version
	@echo "-> check env golang"
	go env
	@echo "-> check env protobuf"
	protoc --version
	@echo "-> check env micro"
	@echo "~> if error check error just see https://github.com/micro/micro#install"
	micro -h
	@echo "~> you can use [ make help ] see more task"
	-GOPROXY="$(INFO_GO_PROXY)" GO111MODULE=on go mod vendor
	@echo "~> you can use [ make help ] see more task"

checkDepends:
	# in GOPATH just use GO111MODULE=on go mod init to init after golang 1.12
	-GOPROXY="$(INFO_GO_PROXY)" GO111MODULE=on go mod verify

dependenciesVendor:
	-GOPROXY="$(INFO_GO_PROXY)" GO111MODULE=on go mod vendor

dep: checkDepends dependenciesVendor
	@echo "just check dependencies info below"

dependenciesInit:
	-GOPROXY="$(INFO_GO_PROXY)" GO111MODULE=on go mod init

dependenciesTidy:
	-GOPROXY="$(INFO_GO_PROXY)" GO111MODULE=on go mod tidy

dependenciesDownload:
	-GOPROXY="$(INFO_GO_PROXY)" GO111MODULE=on go mod download

dependenciesGraph:
	GOPROXY="$(INFO_GO_PROXY)" GO111MODULE=on go mod graph

cleanBuild:
	@if [ -d ${ROOT_BUILD_PATH} ]; then rm -rf ${ROOT_BUILD_PATH} && echo "~> cleaned ${ROOT_BUILD_PATH}"; else echo "~> has cleaned ${ROOT_BUILD_PATH}"; fi

cleanLog:
	@if [ -d ${ROOT_LOG_PATH} ]; then rm -rf ${ROOT_LOG_PATH} && echo "~> cleaned ${ROOT_LOG_PATH}"; else echo "~> has cleaned ${ROOT_LOG_PATH}"; fi

cleanDist:
	@if [ -d ${ROOT_DIST} ]; then rm -rf ${ROOT_DIST} && echo "~> cleaned ${ROOT_DIST}"; else echo "~> has cleaned ${ROOT_DIST}"; fi

clean: cleanBuild cleanLog
	@echo "~> clean finish"

checkTestBuildPath:
	@if [ ! -d ${ROOT_TEST_BUILD_PATH} ]; then mkdir -p ${ROOT_TEST_BUILD_PATH} && echo "~> mkdir ${ROOT_TEST_BUILD_PATH}"; fi

checkTestDistPath:
	@if [ ! -d ${ROOT_TEST_DIST_PATH} ]; then mkdir -p ${ROOT_TEST_DIST_PATH} && echo "~> mkdir ${ROOT_TEST_DIST_PATH}"; fi

checkTestOSDistPath:
	@if [ ! -d ${ROOT_TEST_OS_DIST_PATH} ]; then mkdir -p ${ROOT_TEST_OS_DIST_PATH} && echo "~> mkdir ${ROOT_TEST_OS_DIST_PATH}"; fi

checkReleaseDistPath:
	@if [ ! -d ${ROOT_REPO_DIST_PATH} ]; then mkdir -p ${ROOT_REPO_DIST_PATH} && echo "~> mkdir ${ROOT_REPO_DIST_PATH}"; fi

checkReleaseOSDistPath:
	@if [ ! -d ${ROOT_REPO_OS_DIST_PATH} ]; then mkdir -p ${ROOT_REPO_OS_DIST_PATH} && echo "~> mkdir ${ROOT_REPO_OS_DIST_PATH}"; fi

buildMain:
	@go build -o build/main main.go

buildARCH:
	@echo "-> start build OS:$(DIST_OS) ARCH:$(DIST_ARCH)"
	@GOOS=$(DIST_OS) GOARCH=$(DIST_ARCH) go build -o build/main main.go

buildDocker: checkDepends cleanBuild
	@echo "-> start build OS:$(DIST_OS_DOCKER) ARCH:$(DIST_ARCH_DOCKER)"
	@GOOS=$(DIST_OS_DOCKER) GOARCH=$(DIST_ARCH_DOCKER) go build -o build/main main.go

dev: buildMain
	-./build/main

runTest:  buildMain
	-./build/main

test: checkDepends buildMain checkTestDistPath
	mv ./build/main $(ROOT_TEST_DIST_PATH)
#	cp ./conf/test/config.yaml $(ROOT_TEST_DIST_PATH)
	@echo "=> pkg at: $(ROOT_TEST_DIST_PATH)"

testOS: checkDepends buildARCH checkTestOSDistPath
	@echo "=> Test at: $(DIST_OS) ARCH as: $(DIST_ARCH)"
	mv ./build/main $(ROOT_TEST_OS_DIST_PATH)
#	cp ./conf/test/config.yaml $(ROOT_TEST_OS_DIST_PATH)
	@echo "=> pkg at: $(ROOT_TEST_OS_DIST_PATH)"

release: checkDepends buildMain checkReleaseDistPath
	mv ./build/main $(ROOT_REPO_DIST_PATH)
#	cp ./conf/release/config.yaml $(ROOT_REPO_DIST_PATH)
	@echo "=> pkg at: $(ROOT_REPO_DIST_PATH)"

releaseOS: checkDepends buildARCH checkReleaseOSDistPath
	@echo "=> Release at: $(DIST_OS) ARCH as: $(DIST_ARCH)"
	mv ./build/main $(ROOT_REPO_OS_DIST_PATH)
#	cp ./conf/release/config.yaml $(ROOT_REPO_OS_DIST_PATH)
	@echo "=> pkg at: $(ROOT_REPO_OS_DIST_PATH)"

# just use test config and build as linux amd64
dockerRun: buildDocker checkTestBuildPath
	mv ./build/main $(ROOT_TEST_BUILD_PATH)
	@echo "=> pkg at: $(ROOT_TEST_BUILD_PATH)"
	@echo "-> try run docker container $(ROOT_NAME)"
	ROOT_NAME=$(ROOT_NAME) DIST_VERSION=$(DIST_VERSION) docker-compose up -d
	-sleep 5
	@echo "=> container $(ROOT_NAME) now status"
	docker inspect --format='{{ .State.Status}}' $(ROOT_NAME)
	docker logs $(ROOT_NAME)

dockerStop:
	ROOT_NAME=$(ROOT_NAME) DIST_VERSION=$(DIST_VERSION) docker-compose stoptemp-micro/go-micro-cli

dockerRemove: dockerStop
	ROOT_NAME=$(ROOT_NAME) DIST_VERSION=$(DIST_VERSION) docker-compose rm -f $(ROOT_DOCKER_SERVICE)
	ROOT_NAME=$(ROOT_NAME) DIST_VERSION=$(DIST_VERSION) docker-compose rm -f $(ROOT_DOCKER_SERVICE)-consul
	docker network prune

dockerCleanImages:
	(while :; do echo 'y'; sleep 3; done) | docker image prune

help:
	@echo "make init - check base env of this project"
	@echo "make dep - check dependencies of project"
	@echo "make dependenciesGraph - see dependencies graph of project"
	@echo "make dependenciesTidy - tidy dependencies graph of project"
	@echo ""
	@echo "make clean - remove binary file and log files"
	@echo ""
	@echo "-- now build name: $(ROOT_NAME) version: $(DIST_VERSION)"
	@echo "-- testOS or releaseOS will out abi as: $(DIST_OS) $(DIST_ARCH) --"
	@echo "make test - build dist at $(ROOT_TEST_DIST_PATH)"
	@echo "make testOS - build dist at $(ROOT_TEST_OS_DIST_PATH)"
	@echo "make testOSTar - build dist at $(ROOT_TEST_OS_DIST_PATH) and tar"
	@echo "make release - build dist at $(ROOT_REPO_DIST_PATH)"
	@echo "make releaseOS - build dist at $(ROOT_REPO_OS_DIST_PATH)"
	@echo "make releaseOSTar - build dist at $(ROOT_REPO_OS_DIST_PATH) and tar"
	@echo ""
	@echo "make runTest - run server use conf/test/config.yaml"
	@echo "make dev - run server use conf/config.yaml"
	@echo "make dockerRun - run docker-compose server as $(ROOT_DOCKER_SERVICE) container-name at $(ROOT_NAME)"
	@echo "make dockerStop - stop docker-compose server as $(ROOT_DOCKER_SERVICE) container-name at $(ROOT_NAME)"
