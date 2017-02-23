package web

import "github.com/go-martini/martini"

func Root() {
    m := martini.Classic()
    m.Get("/", func() string {
        return "Hello world!"
    })
    m.Run()
}
