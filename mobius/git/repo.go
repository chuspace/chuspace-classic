package git

import (
	"fmt"
	"gopkg.in/src-d/go-git.v4"
	"os"
)

func InitBareRepo(username string, reponame string) (*git.Repository, error) {
	path := fmt.Sprintf("%s/%s/%s", os.Getenv("GIT_STORAGE_PATH"), username, reponame)

	repo, err := git.PlainInit(path, true)
	if err != nil {
		return nil, err
	}

	return repo, nil
}
