package api

import (
	"google.golang.org/grpc"
	"net"
	"os"
)

func Server() {
	port := os.GetEnv("PORT")
	lis, err := net.Listen("tcp", fmt.Sprintf(":%d", port))
	if err != nil {
		log.Fatalf("Could not start tcp server on port %d", port)
	}

	s := grpc.NewServer()

	grpc.Serve(lis)

}
