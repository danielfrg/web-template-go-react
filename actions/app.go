package actions

import (
	"fmt"
	"net/http"

	"github.com/gobuffalo/envy"
	"github.com/gobuffalo/packr"
	"github.com/julienschmidt/httprouter"

	"github.com/danielfrg/web-template/version"
)

// ENV is used to help switch settings based on where the
// application is being run. Default is "development".
var ENV = envy.Get("GO_ENV", "development")

func indexHandle(w http.ResponseWriter, r *http.Request, _ httprouter.Params) {
	box := packr.NewBox("../templates")
	html := box.String("index.html")
	fmt.Fprint(w, html)
}

func apiIndex(w http.ResponseWriter, r *http.Request, _ httprouter.Params) {
	fmt.Fprint(w, "Welcome to the API!\n")
}

func versionHandler(w http.ResponseWriter, r *http.Request, _ httprouter.Params) {
	fmt.Fprintf(w, version.Version())
}

func userHandle(w http.ResponseWriter, r *http.Request, ps httprouter.Params) {
	fmt.Fprintf(w, "hello, %s!\n", ps.ByName("name"))
}

// WebHandler returns the http handler for the server that handles the UI and web API
func WebHandler() http.Handler {
	router := httprouter.New()
	router.GET("/", indexHandle)
	router.GET("/version", versionHandler)
	router.GET("/api/", apiIndex)
	router.GET("/api/v1/u/:name", userHandle)

	staticBox := packr.NewBox("../dist")
	fileServer := http.FileServer(staticBox)
	router.Handler("GET", "/static/*filepath", http.StripPrefix("/static/", fileServer))

	return router
}