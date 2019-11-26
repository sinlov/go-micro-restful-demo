package config

import (
	"fmt"
	"github.com/spf13/viper"
)

var mustConfigString = []string{
	"version",
	"runmode",
	"addr",
	"name",
	"basePath",
	// project set
}

// check config.yaml must has string key
//	config.mustConfigString
func checkMustHasString() error {
	for _, config := range mustConfigString {
		if "" == viper.GetString(config) {
			return fmt.Errorf("not has must string key [ %v ]", config)
		}
	}
	return nil
}
