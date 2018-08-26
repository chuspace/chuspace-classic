package git

import (
	"fmt"
	"gopkg.in/src-d/go-git.v4"
	"os"
)

func InitBareRepo(username string, reponame string) *git.Repository {
	path := fmt.Sprintf("%s/%s/%s", os.GetEnv("GIT_STORAGE_PATH"), username, reponame)

	return git.PlainInit(path, true)
}
