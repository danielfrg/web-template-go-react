package main

import (
	"fmt"
	"net/http"

	assetfs "github.com/elazarl/go-bindata-assetfs"
	"github.com/julienschmidt/httprouter"
)

func indexHandle(w http.ResponseWriter, r *http.Request, _ httprouter.Params) {
	data, err := Asset("index.html")
	if err != nil {
		// Asset was not found.
	}
	fmt.Fprint(w, string(data[:]))
}

func apiIndex(w http.ResponseWriter, r *http.Request, _ httprouter.Params) {
	fmt.Fprint(w, "Welcome!\n")
}

func versionHandler(w http.ResponseWriter, r *http.Request, _ httprouter.Params) {
	fmt.Fprintf(w, Version())
}

func userHandle(w http.ResponseWriter, r *http.Request, ps httprouter.Params) {
	fmt.Fprintf(w, "hello, %s!\n", ps.ByName("name"))
}

// WebHandler returns the http handler for the server that handles the UI and web API
func WebHandler() http.Handler {
	router := httprouter.New()
	router.GET("/", indexHandle)
	router.GET("/api/", apiIndex)
	router.GET("/api/version", versionHandler)
	router.GET("/api/u/:name", userHandle)
	router.Handler("GET", "/static/*filepath",
		http.FileServer(
			&assetfs.AssetFS{Asset: Asset, AssetDir: AssetDir, AssetInfo: AssetInfo},
		),
	)

	return router
}
