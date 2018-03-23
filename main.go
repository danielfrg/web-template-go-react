package main

import (
	"fmt"
	"net/http"

	"github.com/danielfrg/web-template/actions"
)

func main() {
	port := 3000
	// log.Info().Int("port", port).Msg("Serving application")
	fmt.Println("Starting web server. http port:", port)
	http.ListenAndServe(fmt.Sprintf(":%d", port), actions.App())
}
