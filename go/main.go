package main

import (
	"fmt"
	"net/http"

	"google.golang.org/grpc/grpclog"
)

func main() {
	// Web server
	port := 8000
	fmt.Println("Starting web server. http port:", port)
	go http.ListenAndServe(fmt.Sprintf(":%d", port), WebHandler())

	// Web GRPC server
	port = 9000
	grpclog.Printf("Starting WebGRPC server. http port: %d", port)

	httpServer := WebGRPCServer(port)
	if err := httpServer.ListenAndServe(); err != nil {
		grpclog.Fatalf("failed starting http server: %v", err)
	}
}
