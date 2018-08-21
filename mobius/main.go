package main

import (
	"fmt"
	"github.com/gauravtiwari/chuspace/mobius/api"
	"google.golang.org/grpc"
	"os"
)

func main() {
	port := os.GetEnv("PORT")

	lis, err := net.Listen("tcp", fmt.Sprintf(":%d", port))
	if err != nil {
		log.Fatalf("Could not start tcp server on port %d", port)
	}

	s := grpc.NewServer()

	api.RegisterMobiusServer(s, api.NewServer())

	s.Serve(lis)
}
