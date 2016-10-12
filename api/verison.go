package api

import (
	"github.com/emicklei/go-restful"
	"github.com/emicklei/go-restful/log"
	"github.com/micro/go-micro/server"
	"golang.org/x/net/context"
	m_version "github.com/sinlov/go-micro-restful-demo/proto/go"
)

type Version struct {

}

type VersionHandler interface {
	Hello(context.Context, *m_version.Request, *m_version.Response) error
}

type HVersion struct {
	VersionHandler
}

func RegisterVersionHandler(s server.Server, hdlr VersionHandler) {
	s.Handle(s.NewHandler(&HVersion{hdlr}))
}

func (s *Version) Anything(req *restful.Request, rsp *restful.Response) {
	log.Print("Received Anything API request")
	rsp.WriteEntity(map[string]string{
		"message": "Hi, this is the Greeter API",
	})
}

func (v *Version)GetVersion(req *restful.Request, rsp *restful.Response) {
	log.Print("Received GetVersion API request")
	rsp.WriteEntity(map[string]string{
		"message": "your version is 1",
	})
}

func BindVerionRoute(path string) {
	ws := new(restful.WebService)
	ws.Consumes(restful.MIME_XML, restful.MIME_JSON)
	ws.Produces(restful.MIME_JSON, restful.MIME_XML)
	ws.Path(path)
	version := new(Version)
	ws.Route(ws.GET("/").To(version.Anything))
	ws.Route(ws.GET("/{name}").To(version.GetVersion))
	wc := restful.NewContainer()
	wc.Add(ws)
	// TODO bind server
	//service := web.NewService(
	//	web.Name("go.micro.web.greeter"),
	//)
	//
	//// Register Handler
	//service.Handle("/", wc)
	//
	//// Run server
	//if err := service.Run(); err != nil {
	//	log.Fatal(err)
	//}
}