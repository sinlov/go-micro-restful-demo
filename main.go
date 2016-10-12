package main

import (
	"github.com/micro/go-micro"
	"time"
	api "github.com/sinlov/go-micro-restful-demo/api"
	"log"
)

func main() {
	service := micro.NewService(
		micro.Name("go.micro.srv.greeter"),
		micro.RegisterTTL(time.Second * 30),
		micro.RegisterInterval(time.Second * 10),
	)

	// optionally setup command line usage
	service.Init()

	// Register Handlers
	api.RegisterVersionHandler(service.Server(), new(api.Version))

	// Run server
	if err := service.Run(); err != nil {
		log.Fatal(err)
	}
}
