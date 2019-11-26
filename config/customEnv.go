package config

import (
	"github.com/spf13/viper"
	"os"
)

const (
	// env prefix is web
	defaultEnvPrefix string = "ENV_WEB"
	// env ENV_WEB_HTTPS_ENABLE default false
	defaultEnvHttpsEnable string = "HTTPS_ENABLE"
	// env ENV_WEB_HOST default ""
	defaultEnvHost string = "HOST"
	// env ENV_AUTO_HOST default true
	defaultEnvAutoGetHost string = "AUTO_HOST"
)

func (c *Config) customEnv() {
	viper.SetEnvPrefix(defaultEnvPrefix)
	// 读取环境变量的前缀为 defaultEnvPrefix
	// 设置默认环境变量
	_ = os.Setenv(defaultEnvHost, "")
	_ = os.Setenv(defaultEnvHttpsEnable, "false")
	_ = os.Setenv(defaultEnvAutoGetHost, "true")
}
