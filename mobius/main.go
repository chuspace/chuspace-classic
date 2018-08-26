package main

import (
	"fmt"
	"github.com/gauravtiwari/chuspace/rpc"
	"google.golang.org/grpc"
	"os"
)

func startRpcServer() {
	port := os.GetEnv("PORT")

	lis, err := net.Listen("tcp", fmt.Sprintf(":%d", port))
	if err != nil {
		log.Fatalf("Could not start tcp server on port %d", port)
	}

	s := grpc.NewServer()

	api.RegisterMobiusServer(s, rpc.NewRpcServer())

	s.Serve(lis)
}

func main() {
	// Run asynchronously because we will also be running SSH/HTTPs servers too
	go func() {
		startRpcServer()
	}()
}
