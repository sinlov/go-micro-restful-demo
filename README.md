# info

## before-use

- install golang SDK [gomirrors.org](https://gomirrors.org/) `must 1.13+`
- install docker
- Discovery by `etcd` more info see [https://github.com/etcd-io/etcd](https://github.com/etcd-io/etcd)
> if use consul see [https://www.consul.io/](https://www.consul.io/)
- install Protobuf [https://github.com/protocolbuffers/protobuf](https://github.com/protocolbuffers/protobuf)
- install protoc-gen-micro [github.com/micro/protoc-gen-micro](https://github.com/micro/protoc-gen-micro)

```bash
go get -v github.com/golang/protobuf/{proto,protoc-gen-go}
go get -v github.com/micro/protoc-gen-micro
```
- install micro cli

## use release binaries

```bash
# Mac OS or Linux
curl -fsSL https://micro.mu/install.sh | /bin/bash

# Windows
powershell -Command "iwr -useb https://micro.mu/install.ps1 | iex"
```

# run-project

## get micro cli

### use official images

get docker images `micro/micro` page is https://hub.docker.com/r/micro/micro
```bash
docker pull micro/micro
```

## init code

- install depends

```bash
make dep
```

- this task will add base depends of this project at project `vendor` folder

| lib                             | version | url                                                                |
|:--------------------------------|:--------|:-------------------------------------------------------------------|
| github.com/micro/go-micro       | v1.16.0 | [github.com/micro/go-micro](https://github.com/micro/go-micro)     |
| github.com/spf13/viper          | v1.5.0  | [github.com/spf13/viper](https://github.com/spf13/viper)           |

more version info see [go.mod](go.mod)

## update proto module

```bash
make protoUpdate
```

## run Discovery

```bash
etcd
```

> use different cli for run discovery

# document

[micro.mu/docs/framework](https://micro.mu/docs/framework.html)

# run Service Discovery

```sh
consul agent -dev
# or
consul agent -server -bootstrap-expect 1 -data-dir /tmp/consul
```

- run web config UI

```sh
micro web
```

see at [http://localhost:8082/](http://localhost:8082/)
config at [http://localhost:8082/client](http://localhost:8082/client)

# run server

```sh
go run main.go
```

- test at web ui [http://localhost:8082/query](http://localhost:8082/query)

or use curl

```sh
curl -v 'http://localhost:8082/rpc' \
  -H "Content-Type:application/json" -H "Accept:application/json" \
  -d '{"service":"go.micro.restful.demo","method":"Version.Version","request":{"name":"my"}}' \
  -X POST
```