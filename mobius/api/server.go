package api

import (
	"github.com/gauravtiwari/chuspace/mobius/git"
	"golang.org/x/net/context"
	"google.golang.org/grpc"
	"net"
	"os"
	"sync"
)

type Server struct {
	mu sync.Mutex
}

func NewServer() *Server {
	return &Server{}
}

func (s *Server) InitBareRepo(ctx context.Context, user *User) (*InitialRepo, error) {
	repo := git.InitBareRepo(user.Nickname, user.Repo.Name)
	return &InitialRepo{
		user: User,
		uri:  fmt.Sprintf("chuspace.com/%s/%s", user.Nickname, user.Repo.Name),
	}, nil
}
