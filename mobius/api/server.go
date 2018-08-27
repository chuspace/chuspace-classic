package api

import (
	"fmt"
	"net/http"
	"os"
)

func Run() error {
	h := Handler{}

	mux := http.NewServeMux()
	mux.HandleFunc("/init_repo", h.InitRepo)

	port := fmt.Sprintf(":%s", os.Getenv("API_PORT"))
	return http.ListenAndServe(port, mux)
}
