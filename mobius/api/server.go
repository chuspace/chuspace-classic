package api

import (
	"encoding/json"
	"fmt"
	"github.com/gauravtiwari/chuspace/git"
	"log"
	"net/http"
	"os"
)

type handler struct{}

type InitRepoParams struct {
	Nickname string `json:"nickname"`
	Reponame string `json:"reponame"`
}

func (*handler) InitRepo(w http.ResponseWriter, r *http.Request) {
	p := &InitRepoParams{}

	if err := json.NewDecoder(r).Decode(p); err != nil {
		http.Error(w, err.Error(), http.StatusUnprocessableEntity)
		return
	}

	repo, err := git.InitBareRepo(p.nickname, p.reponame)

	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
	}

	w.WriteHeader(http.StatusOK)
}

func Run() {
	mux := http.NewServeMux()
	mux.Handle("/init_repo", handler.InitGitRepo)

	port := fmt.Sprintf(":%", os.GetEnv("PORT"))
	log.Fatal(http.ListenAndServe(port, nil))
}
