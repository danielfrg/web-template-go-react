package main

import (
	"fmt"
	"log"
	"net/http"
	"os"
	"strings"

	"golang.org/x/net/context"

	"google.golang.org/grpc"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/grpclog"
	"google.golang.org/grpc/metadata"

	assetfs "github.com/elazarl/go-bindata-assetfs"
	"github.com/improbable-eng/grpc-web/go/grpcweb"
	"github.com/julienschmidt/httprouter"

	library "github.com/danielfrg/go-web-template/go/_proto"
)

func Index(w http.ResponseWriter, r *http.Request, _ httprouter.Params) {
	data, err := Asset("index.html")
	if err != nil {
		// Asset was not found.
	}
	fmt.Fprint(w, string(data[:]))
}

func ApiIndex(w http.ResponseWriter, r *http.Request, _ httprouter.Params) {
	fmt.Fprint(w, "Welcome!\n")
}

func VersionHandler(w http.ResponseWriter, r *http.Request, _ httprouter.Params) {
	fmt.Fprintf(w, Version())
}

func User(w http.ResponseWriter, r *http.Request, ps httprouter.Params) {
	fmt.Fprintf(w, "hello, %s!\n", ps.ByName("name"))
}

var books = []*library.Book{
	&library.Book{
		Isbn:   60929871,
		Title:  "Brave New World",
		Author: "Aldous Huxley",
	},
	&library.Book{
		Isbn:   140009728,
		Title:  "Nineteen Eighty-Four",
		Author: "George Orwell",
	},
	&library.Book{
		Isbn:   9780140301694,
		Title:  "Alice's Adventures in Wonderland",
		Author: "Lewis Carroll",
	},
	&library.Book{
		Isbn:   140008381,
		Title:  "Animal Farm",
		Author: "George Orwell",
	},
}

type bookService struct{}

func (s *bookService) GetBook(ctx context.Context, bookQuery *library.GetBookRequest) (*library.Book, error) {
	grpc.SendHeader(ctx, metadata.Pairs("Pre-Response-Metadata", "Is-sent-as-headers-unary"))
	grpc.SetTrailer(ctx, metadata.Pairs("Post-Response-Metadata", "Is-sent-as-trailers-unary"))

	for _, book := range books {
		if book.Isbn == bookQuery.Isbn {
			return book, nil
		}
	}

	return nil, grpc.Errorf(codes.NotFound, "Book could not be found")
}

func (s *bookService) QueryBooks(bookQuery *library.QueryBooksRequest, stream library.BookService_QueryBooksServer) error {
	stream.SendHeader(metadata.Pairs("Pre-Response-Metadata", "Is-sent-as-headers-stream"))
	for _, book := range books {
		if strings.HasPrefix(book.Author, bookQuery.AuthorPrefix) {
			stream.Send(book)
		}
	}
	stream.SetTrailer(metadata.Pairs("Post-Response-Metadata", "Is-sent-as-trailers-stream"))
	return nil
}

func main() {
	// Web server
	port := 8000
	fmt.Println("Starting web server. http port:", port)
	router := httprouter.New()
	router.GET("/", Index)
	router.GET("/api/", ApiIndex)
	router.GET("/api/version", VersionHandler)
	router.GET("/api/u/:name", User)
	router.Handler("GET", "/static/*filepath",
		http.FileServer(
			&assetfs.AssetFS{Asset: Asset, AssetDir: AssetDir, AssetInfo: AssetInfo},
		),
	)
	go http.ListenAndServe(":8000", router)

	// WebGRPC server
	port = 9000
	grpclog.Printf("Starting WebGRPC server. http port: %d", port)

	grpcServer := grpc.NewServer()
	library.RegisterBookServiceServer(grpcServer, &bookService{})
	grpclog.SetLogger(log.New(os.Stdout, "exampleserver: ", log.LstdFlags))

	wrappedServer := grpcweb.WrapServer(grpcServer)
	handler := func(resp http.ResponseWriter, req *http.Request) {
		wrappedServer.ServeHTTP(resp, req)
	}

	httpServer := http.Server{
		Addr:    fmt.Sprintf(":%d", port),
		Handler: http.HandlerFunc(handler),
	}

	if err := httpServer.ListenAndServe(); err != nil {
		grpclog.Fatalf("failed starting http server: %v", err)
	}
}
