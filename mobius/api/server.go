package api

import (
	"encoding/json"
	"fmt"
	"github.com/gauravtiwari/chuspace/mobius/git"
	"log"
	"net/http"
	"os"
)

type InitRepoParams struct {
	Nickname string `json:"nickname"`
	Reponame string `json:"reponame"`
}

func handleInitRepo(w http.ResponseWriter, r *http.Request) {
	p := &InitRepoParams{}

	if err := json.NewDecoder(r.Body).Decode(p); err != nil {
		http.Error(w, err.Error(), http.StatusUnprocessableEntity)
		return
	}

	_, err := git.InitBareRepo(p.Nickname, p.Reponame)

	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	w.WriteHeader(http.StatusOK)
}

func Run() {
	mux := http.NewServeMux()
	mux.HandleFunc("/init_repo", handleInitRepo)

	port := fmt.Sprintf(":%s", os.Getenv("PORT"))
	log.Fatal(http.ListenAndServe(port, mux))
}
