# test

## github.com/smartystreets/goconvey

[github.com/smartystreets/goconvey](https://github.com/smartystreets/goconvey)

```bash
GO111MODULE=on go mod edit -require=github.com/smartystreets/goconvey@^1.6.3
GO111MODULE=on go mod vendor
```

# depend

## github.com/micro/go-micro

[github.com/micro/go-micro](https://github.com/micro/go-micro)

```bash
GO111MODULE=on go mod edit -require=github.com/micro/go-micro@v1.16.0
GO111MODULE=on go mod vendor
```

## github.com/spf13/viper

[github.com/spf13/viper](https://github.com/spf13/viper)

```bash
GO111MODULE=on go mod edit -require=github.com/spf13/viper@v1.5.0
GO111MODULE=on go mod vendor
```

## github.com/parnurzeal/gorequest

- api [https://gowalker.org/github.com/parnurzeal/gorequest](https://gowalker.org/github.com/parnurzeal/gorequest)
[https://godoc.org/github.com/parnurzeal/gorequest](https://godoc.org/github.com/parnurzeal/gorequest)
- source [https://github.com/parnurzeal/gorequest](https://github.com/parnurzeal/gorequest)

```bash
GO111MODULE=on go mod edit -require=github.com/parnurzeal/gorequest@v0.2.16
GO111MODULE=on go mod vendor
```

- use fast

```go
import (
	"github.com/parnurzeal/gorequest"
)

request := gorequest.New()
resp, body, errs := request.Get("http://example.com").
  RedirectPolicy(redirectPolicyFunc).
  Set("If-None-Match", `W/"wyzzy"`).
  End()

// PUT -> request.Put("http://example.com").End()
// DELETE -> request.Delete("http://example.com").End()
// HEAD -> request.Head("http://example.com").End()
// ANYTHING -> request.CustomMethod("TRACE", "http://example.com").End()
```

- json

```go
m := map[string]interface{}{
  "name": "backy",
  "species": "dog",
}
mJson, _ := json.Marshal(m)
contentReader := bytes.NewReader(mJson)
req, _ := http.NewRequest("POST", "http://example.com", contentReader)
req.Header.Set("Content-Type", "application/json")
req.Header.Set("Notes","GoRequest is coming!")
client := &http.Client{}
resp, _ := client.Do(req)
```

- Callback

```go
func printStatus(resp gorequest.Response, body string, errs []error){
  fmt.Println(resp.Status)
}
gorequest.New().Get("http://example.com").End(printStatus)
```