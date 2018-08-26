package main

import (
	"github.com/gauravtiwari/chuspace/mobius/git"
	"golang.org/x/net/context"
	"google.golang.org/grpc"
	"net"
	"os"
	"sync"
)

type RpcServer struct {
	mu sync.Mutex
}

func NewRpcServer() *RpcServer {
	return &RpcServer{}
}

func (s *RpcServer) InitBareRepo(ctx context.Context, user *User) (*InitialRepo, error) {
	repo := git.InitBareRepo(user.Nickname, user.Repo.Name)
	return &InitialRepo{
		user: User,
		uri:  fmt.Sprintf("chuspace.com/%s/%s", user.Nickname, user.Repo.Name),
	}, nil
}
