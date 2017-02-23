// package main
//
// import (
// 	"fmt"
// 	"github.com/danielfrg/binder/pkg/version"
// 	"github.com/danielfrg/binder/web"
// )
//
// func main() {
// 	// hello()
// 	fmt.Printf(version.VERSION)
// 	fmt.Printf("\n")
// 	web.Root()
// }

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
