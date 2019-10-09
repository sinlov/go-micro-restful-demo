# before USE

- install golang
- install consul [https://www.consul.io/](https://www.consul.io/)
- install Protobuf [https://github.com/protocolbuffers/protobuf](https://github.com/protocolbuffers/protobuf)

- install depends

```sh
go get -u github.com/micro/micro
```

if use docker

```sh
docker pull microhq/micro
```

https://hub.docker.com/r/microhq/micro

# document

https://micro.mu/docs/

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