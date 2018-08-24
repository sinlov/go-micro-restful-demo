package api

import (
	mVersion "github.com/sinlov/go-micro-restful-demo/proto/go"
	"golang.org/x/net/context"
	"fmt"
)

type Version struct {
	VersionHandler
}

func (v *Version) Version(ctx context.Context, req *mVersion.Request, resp *mVersion.Response) error {
	//*req = mVersion.Request{
	//	Name: "youName",
	//}
	*resp = mVersion.Response{
		Vc:  10,
		Vn:  "0.0.010",
		Msg: fmt.Sprintf("you send name => %v", req.Name),
	}
	return nil
}

func (v *Version) GetVersion(ctx context.Context, req *mVersion.Request, resp *mVersion.Response) error {
	*resp = mVersion.Response{
		Vc:  100,
		Vn:  "0.0.100",
		Msg: fmt.Sprintf("you send name => %v", req.Name),
	}
	return nil
}

type VersionHandler interface {
}
