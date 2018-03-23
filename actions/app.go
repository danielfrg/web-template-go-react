package actions

import (
	"encoding/json"
	"fmt"
	"net/http"
	"strconv"

	"github.com/gobuffalo/packr"
	"github.com/julienschmidt/httprouter"
	log "github.com/sirupsen/logrus"

	"github.com/danielfrg/web-template/version"
)

// App returns the http handler for the server that handles the UI and web API
func App() http.Handler {
	log.WithFields(log.Fields{}).Debug("Building routes")
	router := httprouter.New()
	router.GET("/", indexHandler)
	router.GET("/api/", apiIndex)
	router.GET("/api/version", versionHandler)
	router.GET("/api/v1/add", addHandler)
	router.GET("/api/v1/user/:name", userHandler)

	staticBox := packr.NewBox("../dist")
	fileServer := http.FileServer(staticBox)
	router.Handler("GET", "/static/*filepath", http.StripPrefix("/static/", fileServer))

	return router
}

func indexHandler(w http.ResponseWriter, r *http.Request, _ httprouter.Params) {
	box := packr.NewBox("../assets/html")
	html := box.String("index.html")
	fmt.Fprint(w, html)
}

func versionHandler(w http.ResponseWriter, r *http.Request, _ httprouter.Params) {
	ver := version.Version()

	data, err := json.Marshal(ver)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	w.Write(data)
}

func apiIndex(w http.ResponseWriter, r *http.Request, _ httprouter.Params) {
	fmt.Fprint(w, "Welcome to the API!\n")
}

func addHandler(w http.ResponseWriter, r *http.Request, _ httprouter.Params) {
	queryValues := r.URL.Query()
	a, err := strconv.Atoi(queryValues.Get("a"))
	if err != nil {
		fmt.Fprintf(w, "Cannot convert `%s` to number", queryValues.Get("a"))
		return
	}
	b, err := strconv.Atoi(queryValues.Get("b"))
	if err != nil {
		fmt.Fprintf(w, "Cannot convert `%s` to number", queryValues.Get("b"))
		return
	}

	log.WithFields(log.Fields{"a": a, "b": b}).Debug("Adding two numbers")
	sum := a + b
	fmt.Fprintf(w, "%d", sum)
}

func userHandler(w http.ResponseWriter, r *http.Request, ps httprouter.Params) {
	fmt.Fprintf(w, "hello, %s!\n", ps.ByName("name"))
}
