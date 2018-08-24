package main

import (
	"time"
	"log"
	"github.com/micro/go-micro"
	"github.com/sinlov/go-micro-restful-demo/api"
)

func main() {
	service := micro.NewService(
		micro.Name("go.micro.restful.demo"),
		micro.Version("last"),
		micro.RegisterTTL(time.Second*30),
		micro.RegisterInterval(time.Second*10),
		micro.Metadata(map[string]string{
			"type": "RESTful demo",
		}),
	)

	// optionally setup command line usage
	service.Init()

	server := service.Server()
	// Register Handlers
	server.Handle(server.NewHandler(&api.Version{}))

	// Run server
	if err := service.Run(); err != nil {
		log.Fatal(err)
	}
}
