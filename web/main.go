package main

import (
	"github.com/syncfuture/go/sconfig"
	log "github.com/syncfuture/go/slog"
	"github.com/syncfuture/host/sfasthttp"
)

func main() {
	cp := sconfig.NewJsonConfigProvider()
	log.Init(cp)
	h := sfasthttp.NewFHWebHost(cp)

	h.ServeFiles("/{filepath:*}", "./www")

	// h.GET("/", func(ctx host.IHttpContext) {
	// 	userAgent := ctx.UserAgent()
	// 	print(userAgent)
	// 	ctx.WriteString(userAgent)
	// })
	// h.ServeFiles("/{filepath:*}", "./www")

	log.Fatal(h.Run())
}
