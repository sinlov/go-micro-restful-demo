package config

import (
	"path/filepath"
	"strings"

	"github.com/spf13/viper"
)

type Config struct {
	Name string
}

// read default config by conf/config.yaml
// can change by CLI by `-c`
// this config can config by ENV
//	ENV_WEB_HTTPS_ENABLE=false
//	ENV_AUTO_HOST=true
//	ENV_WEB_HOST 127.0.0.1:8000
func Init(cfg string) error {
	c := Config{
		Name: cfg,
	}

	// initialize configuration file
	if err := c.initConfig(); err != nil {
		return err
	}

	// initialization log package
	//if err := c.initLog(); err != nil {
	//	return err
	//}

	// init BaseConf
	//initBaseConf()

	// TODO other config

	// monitor configuration changes and hot loaders
	c.watchConfig()

	return nil
}

func (c *Config) initConfig() error {
	if c.Name != "" {
		viper.SetConfigFile(c.Name) // 如果指定了配置文件，则解析指定的配置文件
	} else {
		viper.AddConfigPath(filepath.Join("conf")) // 如果没有指定配置文件，则解析默认的配置文件 conf/config.go
		viper.SetConfigName("config")
	}
	viper.SetConfigType("yaml") // 设置配置文件格式为YAML
	viper.AutomaticEnv()        // 读取匹配的环境变量

	// set custom env
	c.customEnv()

	replacer := strings.NewReplacer(".", "_")
	viper.SetEnvKeyReplacer(replacer)
	if err := viper.ReadInConfig(); err != nil { // viper解析配置文件
		return err
	}

	if err := checkMustHasString(); err != nil {
		return err
	}

	return nil
}
