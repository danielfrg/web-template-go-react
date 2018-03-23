package main

import (
	"fmt"
	"net/http"
	"os"

	"github.com/danielfrg/web-template/actions"
	"github.com/gobuffalo/envy"
	log "github.com/sirupsen/logrus"
)

// ENV is used to help switch settings based on where the
// application is being run. Default is "development".
var ENV = envy.Get("ENV", "development")

func init() {
	log.SetOutput(os.Stdout)
	log.SetLevel(log.DebugLevel)

	if ENV == "production" {
		log.SetFormatter(&log.JSONFormatter{})
	}
}

func main() {
	log.WithFields(log.Fields{"env": ENV}).Info("Environment")

	port := 3000
	log.WithFields(log.Fields{"port": port}).Info("Serving application")
	http.ListenAndServe(fmt.Sprintf(":%d", port), actions.App())
}
