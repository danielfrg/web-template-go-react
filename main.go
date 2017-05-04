package main

import (
	"fmt"
	"log"
	"net/http"

	"github.com/danielfrg/go-web-template/pkg"
	assetfs "github.com/elazarl/go-bindata-assetfs"
	"github.com/julienschmidt/httprouter"
)

func Index(w http.ResponseWriter, r *http.Request, _ httprouter.Params) {
	data, err := pkg.Asset("index.html")
	if err != nil {
		// Asset was not found.
	}
	fmt.Fprint(w, string(data[:]))
}

func ApiIndex(w http.ResponseWriter, r *http.Request, _ httprouter.Params) {
	fmt.Fprint(w, "Welcome!\n")
}

func Version(w http.ResponseWriter, r *http.Request, _ httprouter.Params) {
	fmt.Fprintf(w, pkg.Version())
}

func User(w http.ResponseWriter, r *http.Request, ps httprouter.Params) {
	fmt.Fprintf(w, "hello, %s!\n", ps.ByName("name"))
}

func main() {
	fmt.Println("Starting server")
	router := httprouter.New()
	router.GET("/", Index)
	router.GET("/api/", ApiIndex)
	router.GET("/api/version", Version)
	router.GET("/api/u/:name", User)
	router.Handler("GET", "/static/*filepath",
		http.FileServer(
			&assetfs.AssetFS{Asset: pkg.Asset, AssetDir: pkg.AssetDir, AssetInfo: pkg.AssetInfo},
		),
	)
	log.Fatal(http.ListenAndServe(":8080", router))
}
