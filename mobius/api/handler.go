package api

import (
	"encoding/json"
	"net/http"

	"github.com/gauravtiwari/chuspace/mobius/git"
)

type Handler struct{}

type InitRepoParams struct {
	Nickname string `json:"nickname"`
	Reponame string `json:"reponame"`
}

func (h *Handler) InitRepo(w http.ResponseWriter, r *http.Request) {
	p := &InitRepoParams{}

	w.Header().Set("Content-Type", "application/json")

	if err := json.NewDecoder(r.Body).Decode(p); err != nil {
		http.Error(w, err.Error(), http.StatusUnprocessableEntity)
		return
	}

	_, err := git.InitBareRepo(p.Nickname, p.Reponame)

	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	w.WriteHeader(http.StatusNoContent)
}
