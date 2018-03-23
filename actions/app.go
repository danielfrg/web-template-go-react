package actions

import (
	"encoding/json"
	"fmt"
	"net/http"
	"strconv"

	"github.com/gobuffalo/envy"
	"github.com/gobuffalo/packr"
	"github.com/julienschmidt/httprouter"
	"github.com/sirupsen/logrus"

	"github.com/danielfrg/web-template/version"
)

// ENV is used to help switch settings based on where the
// application is being run. Default is "development".
var ENV = envy.Get("ENV", "development")

// Create a new instance of the logger. You can have any number of instances.
var Log = logrus.New()

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
	sum := a + b
	fmt.Fprintf(w, "%d", sum)
}

func userHandler(w http.ResponseWriter, r *http.Request, ps httprouter.Params) {
	fmt.Fprintf(w, "hello, %s!\n", ps.ByName("name"))
}

// App returns the http handler for the server that handles the UI and web API
func App() http.Handler {
	// TODO
	// if Environment == "production" {
	// 	logrus.SetFormatter(&logrus.JSONFormatter{})
	// }

	Log.WithFields(logrus.Fields{
		"animal": "walrus",
		"size":   10,
	}).Info("A group of walrus emerges from the ocean")

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
