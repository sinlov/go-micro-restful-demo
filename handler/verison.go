package handler

import (
	"context"
	"fmt"

	modelDemo "github.com/sinlov/go-micro-restful-demo/model/demo"
)

type VersionHandler interface {
}

type Version struct {
	VersionHandler
}

func (v *Version) Version(ctx context.Context, req *modelDemo.ApiRequest, resp *modelDemo.ApiResponse) error {
	*resp = modelDemo.ApiResponse{
		Code: modelDemo.ApiCodes_StatusOK,
		Msg:  fmt.Sprintf("you send name => %v", req.VersionReq.Vn),
		VersionResp: &modelDemo.VersionResp{
			Vc: 10,
			Vn: "0.0.010",
		},
	}
	return nil
}

func (v *Version) GetVersion(ctx context.Context, req *modelDemo.ApiRequest, resp *modelDemo.ApiResponse) error {
	*resp = modelDemo.ApiResponse{
		Code: modelDemo.ApiCodes_StatusOK,
		Msg:  "getVersion",
		VersionResp: &modelDemo.VersionResp{
			Vc: 100,
			Vn: "0.0.100",
		},
	}
	return nil
}
