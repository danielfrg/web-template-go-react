package main

import (
    "github.com/codegangsta/martini"
    "github.com/codegangsta/martini-contrib/render"
)

func main() {
    m := martini.Classic()
    // render html templates from templates directory
    m.Use(render.Renderer())

    m.Get("/", func(r render.Render) {
        r.HTML(200, "index", "jeremy")
    })

    m.Run()
}
